# Build Week Changelog

Fitareeaee was a substantial Flutter/Firebase prototype before OpenAI Build Week. This changelog describes only the meaningful extension and hardening completed after the explicit baseline recorded on July 17, 2026.

## Evidence boundary

- Pre-existing baseline commit: `69f9a704c9612d0524a2027275ab0d259508bd49`
- Baseline tag: `build-week-preexisting-baseline`
- Build Week branch: `build-week/final`
- Detailed baseline: [`PRE_BUILD_WEEK_BASELINE.md`](PRE_BUILD_WEEK_BASELINE.md)
- Append-only execution evidence: [`BUILD_WEEK_PROGRESS.md`](BUILD_WEEK_PROGRESS.md)

The older marketplace, authentication, profiles, trip browsing/creation prototypes, chat, notifications, verification screens, and payment/wallet experiments are not claimed as Build Week work.

## What changed during Build Week

### Stage 0 — reliable Android/Firebase foundation

- Aligned the Android application with the confirmed Firebase project `fitareeaee` and package `com.fitareeaee.app`.
- Replaced placeholder Firebase startup with native Android configuration plus a project-ID guard.
- Added recoverable Firebase loading/error states and the Android internet permission.
- Removed unnecessary background-location and broad-storage permissions.
- Added Firebase project, Functions, Firestore, Storage, index, and emulator configuration.
- Removed client-side OpenRouter/Stripe key constants and expanded secret ignores.
- Produced and clean-installed an Android debug checkpoint on an API 36.1 emulator.

### Stage 1 — secure judge path

- Replaced direct client booking writes with authenticated callable Functions and Firestore transactions.
- Added server checks for trip status, ownership, departure time, duplicate booking, verification, and seat availability.
- Made booking creation/cancellation and seat inventory changes atomic.
- Added authenticated verification submission/contact sync and admin-only manual review callables.
- Kept identity decisions manual; no model approves identity or declares a person safe.
- Replaced permissive data access with default-deny Firestore rules, owner-scoped Storage rules, and participant-only chat access.
- Removed unsafe prototype payment/reset/Maps Functions from the deployable export surface.
- Hid simulated finance and broken prototype routes from the judge path.
- Added Functions contract tests and Firestore/Storage authorization tests.

### Stage 2 — Fitareeaee Copilot

- Added a prominent **Plan with AI** action on Home.
- Added English and Arabic natural-language planning for rides and packages.
- Added an authenticated Firebase callable using the official OpenAI server SDK, Responses API, and `gpt-5.6`.
- Added strict JSON Schema output plus independent server validation and normalization.
- Added request limits, a 30-second SDK timeout, one retry, safe error mapping, an 8-second cooldown, and a 12-request-per-hour per-user limit.
- Limited the model payload to redacted request text, locale, timezone, and a server-generated current date. Email addresses, URLs, and long numeric strings are filtered before model access.
- Added a visible **AI draft — review required** state with editable intent, type, route, date/time, count, budget, package details, preferences, summary, missing information, and clarification.
- Ensured confirmation starts search only; it does not create a trip, booking, or persistent record.
- Added deterministic ranking of real Firestore trips with transparent reasons for route, time, availability, price, and preferences.
- Added explicit empty, retry, and manual-search fallbacks; no synthetic trips are fabricated.
- Connected results to the existing trip details → verification → transactional booking → participant chat path.
- Added Copilot schema, safety, Arabic, throttling, UI confirmation, ranking, and empty-result tests.

### Stage 3/4 — production hardening and judge package

- Removed the redundant nested Flutter starter and deleted unused payment, wallet, tracking, AI-verification, map, and broken trip-creation prototype code from the submission surface.
- Added server-maintained minimal `public_profiles` and `public_trips` projections so marketplace/chat screens do not expose private users, exact coordinates, passenger IDs, package photos, descriptions, or arbitrary metadata.
- Tightened user-profile and chat rules with allowlisted fields, deterministic participants, bounded content, immutable sender identity, server-issued booking/request conversation authorization, and denial of client-controlled trust/admin data.
- Hardened verification uploads with exact Firebase object paths plus server-side content-type/size validation; Firestore no longer stores public token URLs and reviewed raw objects are deleted.
- Corrected request-versus-offer behavior, package capacity/price matching, stale/unavailable trip exclusion, Arabic city normalization, and safe retry/error states.
- Added real callable integration coverage against Auth, Functions, and Firestore emulators; this caught and fixed a final-seat idempotency bug before release.
- Added guarded judge-data seeding that requires the confirmed `fitareeaee` project and existing dedicated Auth UIDs, and never stores account passwords.
- Added the MIT license, judge-ready README, test matrix, privacy/safety notes, Devpost copy, 2:40 demo script, judge instructions, and final checklist.

## Before and after

| Area | Before Build Week | Build Week extension |
| --- | --- | --- |
| Request entry | Rigid marketplace forms and manual browsing | English/Arabic natural-language ride or package planning |
| AI | Unused OpenRouter/AI-verification prototype | Official server-side OpenAI Responses API with GPT-5.6 |
| Model output | No contest-facing structured workflow | Strictly structured, validated, editable draft |
| User control | Prototype actions could write directly | AI creates a draft only; user must review and confirm |
| Matching | Existing trip browsing | Deterministic ranking with visible route/time/seat/price/preference reasons |
| Empty data | Prototype behavior varied | Never fabricates trips; explicit empty state and manual fallback |
| Booking | Client-side and non-transactional | Authenticated server transaction with authorization and inventory checks |
| Verification | Primarily client/UI protected | Server-controlled manual review and restricted rules |
| Data access | Broad/inconsistent prototype rules | Default-deny Firestore and owner/participant-scoped access |
| Delivery evidence | Older prototype history | Dated baseline, staged commits/tags, tests, APK hashes, and judge docs |

## Latest locally verified checkpoint

The Stage 2 feature commit is `200ead32a1e075f28a32d117c6c8ee7113ddd212`; its passing evidence commit and `build-week-stage2-local` tag point to `3ddeaae13ce4852d1a8744cd8e7204e0fcb8bec9`. The hardened Stage 3 local tag points to `31deb8c8dc132f1768e19b55b3676fa712865678`.

- Flutter format gate: 119 files, 0 changes
- Flutter analysis: no issues
- Flutter full-suite result: 16/16 passed (focused Copilot widget tests pass 3/3)
- Functions contracts: 16/16 passed
- Firestore/Storage rules contracts: 7/7 passed
- Real callable Auth/Functions/Firestore emulator integration: 3/3 passed
- Functions TypeScript build: passed
- Universal debug APK: rebuilt from the tagged source; 154,897,342 bytes
- Universal APK SHA-256: `E89FC8547EEFC4366ABC1ACF9098ECCCD0220742999D2035721D498CF0C187D8`
- Same-source x86_64 APK: clean-installed and launched to Login on Android API 36.1; no fatal logs

## Not yet claimed

At the time this document was drafted, the OpenAI managed secret and live Functions/rules deployment were pending. A live GPT-5.6 call, credentialed end-to-end Android flow, public GitHub/APK URL, downloaded-artifact test, signed release, and physical-phone test are not claimed as complete. See the submission checklist for the release gate.
