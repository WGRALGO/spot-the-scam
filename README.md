# Spot the Scam

**Version: 1.0.0**

A free offline Android scam-awareness game from **WGRALGO / The Wealth Gap Resolution Algorithm™ Inc.**

Spot the Scam helps users practice recognizing common red flags in real-world
scams involving money, identity, jobs, banking, charity, delivery messages,
fake prizes, tech support, and urgent payment demands. It is designed for young
adults, seniors, and families learning together.

---

## Features

- 100 scam/safe scenarios
- 10-question randomized rounds
- Difficulty labels (Very Easy → Very Hard)
- Instant feedback after each answer
- Educational end-of-round score summary showing the question, your choice, the
  correct answer, the result, and an explanation for every question
- Offline-first
- No ads
- No analytics
- No trackers
- No account
- No cloud upload
- No in-app purchases

---

## Screenshots

_Screenshots will be added here._

| Start | Question | Results |
|-------|----------|---------|
| _TBD_ | _TBD_    | _TBD_   |

---

## Install / Sideload

1. Download `SpotTheScam-v1.0.0.apk` from the
   [GitHub Releases](../../releases) page (tag `v1.0.0`).
2. On your Android device, allow installation from your browser/file manager
   ("Install unknown apps").
3. Open the downloaded APK and tap **Install**.
4. Launch **Spot the Scam**.

No account, sign-in, or network connection is required.

---

## Build from source

Requirements: JDK 17, Android SDK (build-tools 35.0.0), Node.js 20+.

```bash
npm install
npx cap sync android
cd android
./gradlew assembleRelease
```

### Release signing (secrets stay out of git)

The build reads signing material from a `keystore.properties` file in the
`android/` folder **or** from environment variables. Neither the keystore nor
its passwords are committed.

Option A — `android/keystore.properties` (git-ignored):

```properties
storeFile=/absolute/path/to/spotthescam-release.keystore
storePassword=********
keyAlias=spotthescam
keyPassword=********
```

Option B — environment variables:

```bash
export STS_KEYSTORE_FILE=/absolute/path/to/spotthescam-release.keystore
export STS_KEYSTORE_PASSWORD=********
export STS_KEY_ALIAS=spotthescam
export STS_KEY_PASSWORD=********
```

Generate a keystore (once, kept private and off git):

```bash
keytool -genkeypair -v -keystore spotthescam-release.keystore \
  -alias spotthescam -keyalg RSA -keysize 2048 -validity 10000
```

If no signing config is supplied, Gradle produces an unsigned release APK that
you can sign manually with `apksigner`.

---

## Privacy summary

This app works offline. It does not collect personal data, does not use ads,
analytics, or trackers, does not require an account, and does not upload game
activity to any server. The `INTERNET` permission is **not** declared. See
[PRIVACY.md](PRIVACY.md).

---

## Contributors

- **WGRALGO** — Project owner, creator, maintainer, content direction, testing,
  and public-benefit mission.
- **ChatGPT** — Assisted with the original HTML/web game code used for the
  website version.
- **Claude** — Assisted with building the Android APK implementation.

This project is owned and maintained by WGRALGO. AI tools are credited for
development assistance and do not hold ownership of the project. See
[CONTRIBUTORS.md](CONTRIBUTORS.md).

---

## License

MIT License. Copyright © WGRALGO / The Wealth Gap Resolution Algorithm™ Inc.
See [LICENSE](LICENSE).

---

## Contact

wealthgapresolutionalgorithm@gmail.com
