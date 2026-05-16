# Contributing

Contributions are welcome. To keep Spot the Scam safe, private, and
family-friendly, all contributions must follow these rules.

## Ground rules

- **No ads, trackers, analytics, or crash reporters.**
- **No unnecessary permissions.** Do not add network access (including the
  `INTERNET` permission) unless explicitly approved by the maintainer.
- Keep the app **educational and family-friendly** — suitable for young
  adults, seniors, and families.
- Respect **WGRALGO ownership and branding** (the black/gold WGRALGO style,
  the name "Spot the Scam", and the project mission).
- Keep the app **offline-first**. No external links, remote fonts, remote
  images, or remote scripts inside the APK.
- The scenario pool must stay at **exactly 100 scenarios**, each with `text`,
  `correct` (`safe` or `risky`), `explanation`, and `difficulty` (1–5), with
  no duplicate scenario text. Each round must use 10 random questions.

## Workflow

1. Open an issue describing the change before large work.
2. Fork, branch, and make focused commits.
3. Run the release validation before opening a pull request:
   ```bash
   ./tools/validate-release.sh
   ```
4. Do not commit keystores, passwords, `local.properties`, signing configs, or
   any secrets.

## Ownership

This project is owned and maintained by WGRALGO / The Wealth Gap Resolution
Algorithm™ Inc. Submitting a contribution does not transfer project ownership
and does not make contributors copyright owners of the project.
