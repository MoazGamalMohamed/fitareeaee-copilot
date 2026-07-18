# Fitareeaee Pre-Build Week Baseline

Baseline recorded: 2026-07-17 21:10 CDT / 2026-07-17 19:10 PDT

This document establishes the honest starting point for the OpenAI Build Week submission. Fitareeaee was an existing Flutter/Firebase project before the submission period opened on July 13, 2026. The application code and the large dirty working tree described below are pre-existing work and are **not claimed as Build Week implementation**.

The Build Week product extension begins only after the baseline checkpoint on the `build-week/final` branch. Planning and evidence documents created on July 17 are contemporaneous contest records; they do not turn the older application code into contest work.

## Source checkpoint

- Previous committed branch: `master`
- Previous committed HEAD: `93780b707c60c0cd1dc4550a0e42ded787ec1d61`
- Previous commit subject: `Feature: Exclude user's own trips from Available trips section`
- Previous repository history ends in December 2025; it contains no commit in the Build Week submission period.
- Git remote at baseline: none
- GitHub CLI at baseline: not installed
- Root Flutter project: authoritative application
- Nested `fitareeae/` project: redundant starter retained only as pre-existing source until a safe cleanup decision is documented

## Pre-existing application scope

The baseline already contains substantial prototype work, including:

- Firebase authentication and user profiles
- ride and package trip creation and browsing
- trip details and client-side booking flows
- chat and notifications
- manual verification and an admin verification screen
- maps/location helpers
- prototype wallet, payment, escrow, support, safety, tracking, and ratings code
- Cloud Functions for notifications, places helpers, prototype payment state changes, and verification reset

These capabilities predate Build Week. Judges should evaluate the later Fitareeaee Copilot commits: secure GPT-5.6 request interpretation, reviewable trip drafts, transparent deterministic matching, the hardened judge path, security fixes required to support it, tests, and submission delivery.

## Dirty working tree preserved as pre-existing work

At baseline the working tree contained 57 tracked file changes (3,275 insertions and 1,467 deletions), two tracked deletions, and numerous untracked files. Major pre-existing change areas included authentication, booking, chat, home, notifications, profile, settings, trips, verification, wallet/payment prototypes, Functions, Android configuration, maps/location, admin verification, and generated models.

Nothing from this tree was reset or discarded. The checkpoint intentionally preserves it before Build Week product implementation begins.

## Baseline validation

- `flutter doctor -v`: pass; Flutter 3.38.3, Dart 3.10.1, Android SDK 36.1, JDK 21
- `flutter analyze`: no compile errors; 75 findings, including 3 warnings
- `flutter test`: pass, 6/6 tests
- `npm run build` in `functions/`: pass
- `flutter build apk --debug`: pass
- APK path: `build/app/outputs/flutter-apk/app-debug.apk`
- APK size: 149.15 MB
- APK SHA-256: `2E481974E61F47E5BC40DA0419D449DF687BAF5D4A0C74435B43A2038D483F85`
- Physical Android device: not connected; installation and phone smoke test not performed

This APK is only a compile baseline. It is not judge-ready because Firebase startup uses placeholder options and the judge path contains schema, routing, authorization, and prototype-feature issues.

## Configuration and publication constraints

- `.env` was tracked in the old local Git history even though it is now ignored.
- The only non-placeholder key-shaped value found in that file is Firebase client configuration. It must not be copied into the sanitized public submission history; Google/Firebase console restrictions and rotation remain an owner action where needed.
- `android/app/google-services.json` and `firestore.rules` were deleted in the dirty baseline.
- `firebase.json` and `.firebaserc` did not exist.
- No OpenAI API key is present in the baseline and none may be committed or embedded in the APK.
- A public submission repository must use sanitized history rather than exposing the old tracked `.env` history.

## Build Week boundary

The first Build Week implementation commit after this checkpoint will establish reliable Firebase startup and the secured judge path. Subsequent dated commits will add the GPT-5.6 Copilot, deterministic matching, tests, documentation, and release artifacts. `docs/BUILD_WEEK_PROGRESS.md` is the append-only evidence log for those checkpoints.
