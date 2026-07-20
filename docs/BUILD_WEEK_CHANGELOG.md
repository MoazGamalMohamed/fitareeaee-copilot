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
- Removed simulated-money controls from the submitted experience; added English/Arabic and currency display preferences while keeping the demonstrated shell in English and avoiding any claim of live currency conversion.
- Added the MIT license, judge-ready README, test matrix, privacy/safety notes, Devpost copy, 2:40 demo script, judge instructions, and final checklist.
- Added server-authoritative driver proposals for rider trip requests. A manually
  verified driver can quote within the rider's budget; direct contact details are
  redacted, the rider selects the proposal, and the booking remains pending payment.
- Enforced that drivers never pay, seats do not change, and direct chat does not open
  until a trusted server marks the selected booking both paid and confirmed.
- Restored visible manual Request a Trip and verification-gated Offer a Ride paths,
  while keeping Plan with AI as a Home-only assisted entry point.

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

### v1.0.6 trip lifecycle, map, and accessibility extension

- Added real origin/destination map pin selection to manual request and verified
  driver-offer creation.
- Added English/Arabic speech-to-text planning with explicit microphone permission
  and a visible listening state.
- Added server-authoritative paid-trip start, completion, emergency cancellation,
  urgent admin refund review, closed-after-trip chat, and one-time ratings.
- Corrected Past Trips to show completed owned trips and participant bookings.
- Aligned FlutterFire native/Dart channel versions, fixing the Android Firebase
  bootstrap failure found during fresh emulator installation.
- Passed 19 Flutter tests, 28 Functions contracts, 9 authorization contracts, and
  7 full callable lifecycle integrations; deployed the scoped backend/rules to
  `fitareeaee`.

The local passing source is `47f49ce`. Publication is pending only because the
required GitHub CLI is unavailable in the current environment; v1.0.5 remains the
published rollback artifact until v1.0.6 is sanitized, pushed, downloaded, and
device-tested.

The optimized local v1.0.6 judge APK is 85,293,151 bytes with SHA-256
`39557F17E593F51620249DA5E1E218463B1EAA237BB0C170FB2F2FB2013F12F0`.
It clean-installed, cold-launched, authenticated, and rendered all three Home entry
actions on the API 36 emulator without matching application-fatal logs.

The current APK source is private
`4630703b5a69e151d07d6e6c9683deced6298302`; its tree-equivalent sanitized
public source is `6d67f306203886d3d1623f9966f36764589b9cfb`, tagged
`fitareeaee-copilot-v1.0.5`. The shared source tree is
`eb32120d74af47cc0e604729055b4e67d92f2aa9`.

- Flutter format gate: 113 files, 0 changes
- Flutter analysis: no issues
- Flutter full-suite result: 19/19 passed, including legacy notification compatibility
- Focused Copilot tests: 10/10 passed
- Functions contracts: 27/27 passed
- Firestore/Storage rules contracts: 8/8 passed
- Real callable Auth/Functions/Firestore emulator integration: 5/5 passed
- Functions TypeScript build: passed
- Universal profile APK: rebuilt from v1.0.5 source; 83,378,603 bytes; Android version `1.0.5` / code `20260719`
- Release-gate source checkpoint: private `4630703`; sanitized `6d67f306`
- Universal APK SHA-256: `0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`
- Universal APK: published, redownloaded, hash-matched, installed/cold-launched on a Motorola phone; authenticated Home, payment-gated Chat empty state, and manual trip request form PASS
- Hardened booking, cancellation, verification, trip-scoped chat, projection callables, Firestore rules, Storage rules, and required indexes: deployed and verified on the confirmed `fitareeaee` project

## Live release status

The authenticated Copilot callable is deployed to the confirmed `fitareeaee`
project and uses managed `OPENAI_API_KEY` version 2. Its capped live matrix passed
for an English ride, an English package, and an Arabic ride request both before
and after obsolete secret version 1 was destroyed. The public sanitized GitHub
repository and superseding v1.0.5 APK Release are available. GitHub asset metadata
and a fresh public download exactly match the recorded size and SHA-256.
Physical-phone testing passed v1.0.5 install, cold launch, authenticated Home,
payment-gated Chat empty state, manual trip creation, and app-specific crash logs.
The earlier live reviewable Copilot draft, transparent matching, details,
server-authoritative fictional booking, confirmed Chat, and realtime message
evidence remains recorded against the source-compatible judge fixtures.

### v1.0.7 map attribution and release-compliance correction

- Replaced toggle-hidden map credit with a permanently visible clickable
  `© OpenStreetMap contributors` attribution linked to the ODbL/copyright page.
- Verified the required standard tile URL, stable package User-Agent,
  HTTP-header-aware native cache, and absence of prefetch/offline behavior against
  the live OSM Foundation tile policy.
- Added a focused widget test proving the permanent attribution is present and
  actionable; the complete Flutter suite now passes 20/20.
- Added third-party dependency, map-data, tile-service, and submission-media
  notices, including the production limitation of the best-effort community tile
  service.
- Added an explicit owner-only judge-password rotation mode that preserves
  existing fictional bookings and fixtures.

The exact APK source is private `96343be` and tree-equivalent sanitized/tagged
`06195d02398c32783fa894f7e1bb5ab1d5fb4daf`. The public v1.0.7 prerelease APK is
85,260,359 bytes with SHA-256
`CC8191D87DB2DEF700FC1D537807C8E43AC499727C2C0E1B53AB17D3729DAEC6`.
Its anonymous public redownload matched exactly and passed reinstall, version,
top-resumed process, and zero app-specific fatal/error-log checks on API 36.
Physical-phone verification remains pending; v1.0.5 remains the stable rollback.

### v1.0.8 speech, verification, and completed-lifecycle correction

- Declared Android `RecognitionService` discovery and added Auto/English/Arabic
  recognition selection; API 36 permission, online recognition, and microphone
  startup were directly observed.
- Made legacy verification summaries tolerate missing audit timestamps and added
  regression coverage plus complete new judge fixtures.
- Added explicitly fictional paid/confirmed and completed lifecycle fixtures so
  judges can see authorized private chat, completed-only Past, closed completed
  chat, and one-time ratings without claiming a real payment processor.
- Removed booking actions from completed/departed trips and deployed the passing
  participant-owned rating-existence read rule.
- Final gates: format 118/0, analyzer 0, Flutter 23/23, Functions 28/28, rules 9/9,
  and existing callable integration 7/7.

The exact APK source is private `3817ed5` and tree-equivalent sanitized/tagged
`54b1654c`. The public v1.0.8 prerelease APK is 109,174,213 bytes with SHA-256
`333174AAFC5CC1BC12060FCB41F3A1372F51F5453C50792650AFF9A9721C2B18`.
Its anonymous public redownload matched exactly and passed fresh installation,
authentication, paid Chat, completed Past, and zero app-specific fatal/error-log
checks on API 36. Physical-phone verification remains pending.
