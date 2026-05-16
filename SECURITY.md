# Security Policy

## Reporting

Report security or privacy issues privately to:

**wealthgapresolutionalgorithm@gmail.com**

Please include steps to reproduce and the app version. Do not open a public
issue for sensitive reports.

## Security posture

Spot the Scam is **offline-first** by design:

- The `INTERNET` permission and all network permissions are intentionally
  **not declared**.
- The app must **not** include analytics, ad SDKs, trackers, crash reporters,
  or any unnecessary permissions.
- No remote scripts, remote fonts, remote images, or external links are loaded
  inside the app.
- A strict Content-Security-Policy restricts the WebView to local content
  only (`default-src 'self'`, `connect-src 'none'`).
- Release builds are not debuggable and WebView debugging is disabled.
- Android backup and data-extraction are disabled.

Any change that weakens these properties is a security regression and should be
reported.
