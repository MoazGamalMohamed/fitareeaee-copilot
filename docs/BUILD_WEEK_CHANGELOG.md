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
- Provisioned two dedicated fictional judge accounts and fixed August 10, 2026 ride/package fixtures; credentials remain only in an ignored, owner-restricted local file.
- Made chat authorization trip-scoped so the same two users receive a clean conversation for each new trip; cancelled-trip chat is readable but rejects new writes.
- Added transactional self-service cancellation that restores seats and closes the associated conversation, while preventing cancellation after departure.
- Corrected confirmed-booking UI state, request/offer labels, pet/smoking visibility, booked-match loading, and safe user-facing error mapping.
- Constrained avatar and verification uploads to exact image paths, types, and a 5 MB maximum enforced by Storage rules and Functions.
- Removed local-only settings and simulated-money controls from the submitted experience; the contest build explicitly uses English and USD while accepting Arabic Copilot input.
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

The Stage 2 feature commit is `200ead32a1e075f28a32d117c6c8ee7113ddd212`; its passing evidence commit and `build-week-stage2-local` tag point to `3ddeaae13ce4852d1a8744cd8e7204e0fcb8bec9`. The hardened Stage 3 local tag points to `31deb8c8dc132f1768e19b55b3676fa712865678`. The consolidated security checkpoint source is `85d73f0a8118c32a3dbc0b7a0786f85f86d271ed`; the latest tested application source is `15baa237707b3115475b09ca7a586e1c171517a7`.

- Flutter format gate: 111 files, 0 changes
- Flutter analysis: no issues
- Flutter full-suite result: 18/18 passed (Copilot interaction coverage: two widget tests plus one focused route/unit test; chat notifier coverage: 2/2)
- Functions contracts: 18/18 passed
- Firestore/Storage rules contracts: 7/7 passed
- Real callable Auth/Functions/Firestore emulator integration: 3/3 passed
- Functions TypeScript build: passed
- Universal debug APK: rebuilt from application source `15baa23`; 154,878,330 bytes; Android version code `20260718`
- Release-gate source checkpoint: `ba9c3436645195180120c012e286d033b2da21f6`
- Universal APK SHA-256: `A35BE070C1D785D85AC26A62797FFDB3581EAE895148E13E078997A431DFC414`
- Universal APK: clean-installed and launched to Login on Android API 36.1; no fatal logs
- Hardened booking, cancellation, verification, trip-scoped chat, projection callables, Firestore rules, Storage rules, and required indexes: deployed and verified on the confirmed `fitareeaee` project

## Live release status

The authenticated Copilot callable is deployed to the confirmed `fitareeaee`
project and uses managed `OPENAI_API_KEY` version 2. Its capped live matrix passed
for an English ride, an English package, and an Arabic ride request both before
and after obsolete secret version 1 was destroyed. The public sanitized GitHub
repository is available. APK publication/download verification, the complete
credentialed Android judge path, and physical-phone testing remain release-gate
items until their direct checks are recorded.
