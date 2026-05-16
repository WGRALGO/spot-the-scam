# Third-Party Notices

Spot the Scam bundles or builds against the following open-source components.
Only components actually used by the APK are listed.

## Runtime (shipped in the APK)

| Component | Version | License | Link |
|-----------|---------|---------|------|
| Capacitor (`@capacitor/core`, `@capacitor/android`) | ^6.2.1 | MIT | https://github.com/ionic-team/capacitor |
| Capacitor Splash Screen plugin (`@capacitor/splash-screen`) | ^6.0.4 | MIT | https://github.com/ionic-team/capacitor-plugins |
| AndroidX AppCompat | 1.6.1 | Apache-2.0 | https://developer.android.com/jetpack/androidx |
| AndroidX CoordinatorLayout | 1.2.0 | Apache-2.0 | https://developer.android.com/jetpack/androidx |
| AndroidX Core SplashScreen | 1.0.1 | Apache-2.0 | https://developer.android.com/jetpack/androidx |
| AndroidX Core | 1.12.0 | Apache-2.0 | https://developer.android.com/jetpack/androidx |

## Build-time only (not shipped in the APK)

| Component | Version | License | Link |
|-----------|---------|---------|------|
| Capacitor CLI (`@capacitor/cli`) | ^6.2.1 | MIT | https://github.com/ionic-team/capacitor |
| `@capacitor/assets` | ^3.0.5 | MIT | https://github.com/ionic-team/capacitor-assets |
| Android Gradle Plugin | 8.2.1 | Apache-2.0 | https://developer.android.com/build |
| Gradle | 8.2.1 | Apache-2.0 | https://gradle.org |
| JUnit | 4.13.2 | EPL-1.0 | https://junit.org/junit4/ |
| AndroidX Test (ext.junit, espresso-core) | 1.1.5 / 3.5.1 | Apache-2.0 | https://developer.android.com/training/testing |

## Notes

- The `com.google.gms:google-services` Gradle classpath is present in the
  default Capacitor scaffold but is **not applied** — no `google-services.json`
  exists and no Google/Firebase services are used.
- The Cordova Android plugin bridge module is included by the Capacitor
  scaffold; no Cordova plugins are bundled.
- No analytics, advertising, tracking, or crash-reporting libraries are
  included.

License texts: MIT and Apache-2.0 full texts are available at
https://opensource.org/license/mit and https://www.apache.org/licenses/LICENSE-2.0
respectively.
