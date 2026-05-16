#!/usr/bin/env bash
# Spot the Scam — release validation.
# Usage: ./tools/validate-release.sh [path/to/app.apk]
# Exit non-zero if any check fails.
set -u
cd "$(dirname "$0")/.."

PASS=0
FAIL=0
ok()   { echo "  PASS  $1"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL  $1"; FAIL=$((FAIL+1)); }

echo "== Scenario pool =="
node - <<'NODE'
const fs = require("fs");
let h = fs.readFileSync("www/index.html", "utf8");
let m = h.match(/var scenarios = \[([\s\S]*?)\n  \];/);
let fails = 0;
const F = (m) => { console.log("  FAIL  " + m); fails++; };
const P = (m) => console.log("  PASS  " + m);
if (!m) { F("scenario array not found"); process.exit(1); }
let arr = eval("[" + m[1] + "]");
arr.length === 100 ? P("exactly 100 scenarios") : F("scenario count = " + arr.length);
let structOk = arr.every(s => s.text && s.explanation &&
  ["safe","risky"].includes(s.correct) && [1,2,3,4,5].includes(s.difficulty));
structOk ? P("every scenario has valid text/correct/explanation/difficulty")
         : F("one or more scenarios invalid");
let texts = arr.map(s => s.text.trim());
new Set(texts).size === texts.length ? P("no duplicate scenario text")
                                     : F("duplicate scenario text found");
/var ROUND = 10;/.test(h) && /slice\(0, ROUND\)/.test(h)
  ? P("round uses 10 random questions")
  : F("round size is not 10 random questions");
process.exit(fails ? 1 : 0);
NODE
[ $? -eq 0 ] && PASS=$((PASS+4)) || FAIL=$((FAIL+1))

echo "== Source / build config =="
GR=android/app/build.gradle
grep -q 'versionName "1.0.0"' $GR && ok "versionName 1.0.0" || bad "versionName not 1.0.0"
grep -q 'versionCode 100' $GR && ok "versionCode 100" || bad "versionCode not 100"
grep -q 'applicationId "com.wgra.spotthescam"' $GR && ok "appId com.wgra.spotthescam" || bad "appId wrong"
grep -q 'debuggable false' $GR && ok "release debuggable false" || bad "release not debuggable false"
grep -q 'minifyEnabled true' $GR && ok "minify enabled" || bad "minify not enabled"
grep -q 'shrinkResources true' $GR && ok "resource shrink enabled" || bad "resource shrink off"

MAN=android/app/src/main/AndroidManifest.xml
grep -q 'android.permission.INTERNET' $MAN && bad "INTERNET permission present" || ok "no INTERNET permission"
grep -q 'android:allowBackup="false"' $MAN && ok "allowBackup false" || bad "allowBackup not false"
grep -q 'dataExtractionRules' $MAN && ok "dataExtractionRules set" || bad "dataExtractionRules missing"

IDX=www/index.html
grep -qi 'gofundme' $IDX && bad "GoFundMe link in UI" || ok "no GoFundMe link"
grep -Eqi 'facebook\.com|instagram\.com|tiktok\.com|youtube\.com|linkedin\.com|x\.com/wealth' $IDX \
  && bad "social media link in UI" || ok "no social media links"
grep -Eqi 'src="https?://|href="https?://|@import .https?://' $IDX \
  && bad "external resource/link in UI" || ok "no external resources/links"
grep -qi 'Content-Security-Policy' $IDX && ok "CSP present" || bad "CSP missing"
grep -Eqi 'google-analytics|googletagmanager|gtag\(|firebase|admob|facebook-jssdk' $IDX \
  && bad "analytics/ads/tracker reference in UI" || ok "no analytics/ads/trackers in UI"

echo "== Repo docs =="
for f in README.md LICENSE PRIVACY.md CONTRIBUTORS.md THIRD_PARTY_NOTICES.md SECURITY.md CONTRIBUTING.md .gitignore; do
  [ -f "$f" ] && ok "$f present" || bad "$f missing"
done
grep -q 'WGRALGO' CONTRIBUTORS.md && grep -q 'ChatGPT' CONTRIBUTORS.md && grep -q 'Claude' CONTRIBUTORS.md \
  && ok "CONTRIBUTORS lists WGRALGO, ChatGPT, Claude" || bad "CONTRIBUTORS missing required names"

if [ "${1:-}" != "" ] && [ -f "${1:-}" ]; then
  APK="$1"
  echo "== APK: $APK =="
  BT=$(ls -d "$HOME"/Android/Sdk/build-tools/* 2>/dev/null | sort -V | tail -1)
  AAPT="$BT/aapt2"; APKSIGNER="$BT/apksigner"
  if [ -x "$AAPT" ]; then
    DUMP=$("$AAPT" dump badging "$APK" 2>/dev/null)
    echo "$DUMP" | grep -q "versionName='1.0.0'" && ok "APK versionName 1.0.0" || bad "APK versionName wrong"
    echo "$DUMP" | grep -q "versionCode='100'" && ok "APK versionCode 100" || bad "APK versionCode wrong"
    echo "$DUMP" | grep -q "package: name='com.wgra.spotthescam'" && ok "APK package id" || bad "APK package id wrong"
    echo "$DUMP" | grep -q "uses-permission: name='android.permission.INTERNET'" \
      && bad "APK declares INTERNET" || ok "APK has no INTERNET permission"
    PERMS=$(echo "$DUMP" | grep "uses-permission:" || true)
    [ -z "$PERMS" ] && ok "APK declares no permissions" || echo "  INFO  perms: $PERMS"
    XT=$("$AAPT" dump xmltree "$APK" --file AndroidManifest.xml 2>/dev/null)
    echo "$XT" | grep -A0 'allowBackup' | grep -qi '=false\|(0x0)' && ok "APK allowBackup false" || bad "APK allowBackup not false"
    if echo "$XT" | grep -qi 'debuggable.*true\|debuggable.*(0xffffffff)'; then bad "APK debuggable true"; else ok "APK not debuggable"; fi
  else
    bad "aapt2 not found ($AAPT)"
  fi
  if [ -x "$APKSIGNER" ]; then
    CERT=$("$APKSIGNER" verify --print-certs "$APK" 2>/dev/null)
    if echo "$CERT" | grep -qi "CN=Android Debug"; then bad "APK signed with Android Debug cert"; else ok "APK not signed with debug cert"; fi
    "$APKSIGNER" verify "$APK" >/dev/null 2>&1 && ok "APK signature verifies" || bad "APK signature invalid/unsigned"
  else
    bad "apksigner not found"
  fi
else
  echo "== APK checks skipped (no APK path given) =="
fi

echo
echo "RESULT: $PASS passed, $FAIL failed"
[ $FAIL -eq 0 ]
