# Test Matrix

This matrix distinguishes completed local verification from release checks that require credentials, deployment, publication, or a physical device.

Status key: **PASS** = directly observed; **PENDING** = not yet executed; **BLOCKED** = requires an external action or credential.

## Automated verification

| Area | Command / coverage | Current status | Evidence |
| --- | --- | --- | --- |
| Formatting | `dart format --output=none --set-exit-if-changed lib test` | PASS | Release-cleanup revision: 111 files, 0 changes |
| Static analysis | `flutter analyze` | PASS | `No issues found!` |
| Flutter suite | `flutter test` | PASS | Consolidated hardened revision: 18/18 tests |
| Copilot ranking | Best-match order, hard exclusions, request/offer direction, stale trips, package capacity, Arabic city normalization | PASS | Focused ranking coverage |
| Copilot interaction | Draft display, failure retry/manual fallback, explicit confirmation, seat-count handoff | PASS | Three focused tests: two widget tests plus one route/unit test |
| Functions contracts | Booking/cancellation, trip-scoped conversation IDs, public-trip projection, verification, Copilot validation/auth/redaction/Arabic/throttling/diagnostics | PASS | 19/19 tests |
| Functions build | `npm run build` in `functions/` | PASS | TypeScript compiler exit 0 |
| Firestore/Storage rules | Booking/chat/public-profile/verification/rate-limit authorization boundaries | PASS | 7/7 emulator contracts, including exact legacy-message participants, constrained avatar URLs, and owner withdrawal of raw verification uploads |
| Callable integration | Concurrent final-seat booking, idempotent retry, cancellation inventory, unverified rejection | PASS | 3/3 against real Auth/Functions/Firestore emulators |
| Android build | `flutter build apk --debug` | PASS | Universal debug APK rebuilt from application source `15baa23`; version code `20260718` |

## Copilot behavior

| Scenario | Expected result | Current status |
| --- | --- | --- |
| English ride request | Strict ride draft with route, time, count, budget/preferences | PASS — contract/UI tests |
| English package request | Strict package draft with package details | PASS — schema contract tests |
| Arabic request | Arabic accepted and normalized into the same schema | PASS — contract test |
| Missing required information | `missingInformation` and a clarification question; no automatic action | PASS — validation/UI contracts |
| Malformed/unexpected model output | Server rejects it with a safe mapped error | PASS — contract test |
| Email/likely phone in prompt | Contact text redacted before model request | PASS — contract test |
| Unauthenticated request | Callable rejects the request | PASS — contract test |
| Oversized/rapid request | Input/rate limits enforced | PASS — contract test |
| User edits draft | Reviewed values are used for matching | PASS — widget/domain coverage |
| Confirmation before persistence | Confirmation performs deterministic search only | PASS — widget/code contract |
| No matching Firestore trips | Empty state; no fabricated trip | PASS — domain/widget behavior |
| AI/backend failure | Retry plus manual-search fallback | PASS — focused widget test |
| Live GPT-5.6 English/Arabic/package prompts | Real deployed Responses API behavior | PASS — three authenticated cases passed before and after obsolete secret version 1 was destroyed |

## Security and transactional behavior

| Scenario | Expected result | Current status |
| --- | --- | --- |
| Duplicate booking retry | Idempotently returns existing booking; no second inventory mutation | PASS — real callable emulator integration |
| Booking own trip | Rejected server-side | PASS — Functions contract |
| Insufficient seats / inactive trip | Rejected without inventory mutation | PASS — Functions contract |
| Unverified participant | Booking rejected | PASS — Functions contract |
| Valid booking | Booking, seat decrement, and conversation authorization occur atomically | PASS — real callable emulator integration |
| Valid cancellation | Status and inventory update atomically | PASS — real callable emulator integration |
| Client approves verification | Denied | PASS — rules/Functions contracts |
| Non-admin reviews verification | Rejected server-side | PASS — Functions contract |
| Non-participant reads chat | Denied | PASS — rules contract |
| Unsolicited conversation/message | Denied without server-issued booking/request authorization | PASS — rules contract |
| Public marketplace projection | Exact coordinates, passenger IDs, photos, descriptions, arbitrary metadata excluded | PASS — Functions/rules contracts |
| Client reads/writes Copilot throttle data | Denied | PASS — rules contract |
| Payment/wallet/reset prototype used from judge path | No exposed judge navigation/deployable reset/payment callable | PASS — source review; release recheck required |
| Live booking without authentication | Rejected before reading or writing trip data | PASS — deployed callable returned HTTP 401 / `UNAUTHENTICATED` |
| Live chat authorization without authentication | Rejected before creating conversation authorization | PASS — deployed callable returned HTTP 401 / `UNAUTHENTICATED` |

## Deployed Firebase verification

| Check | Current status | Notes |
| --- | --- | --- |
| Confirmed project | PASS | All deployment commands explicitly targeted `fitareeaee` |
| Firestore rules | PASS | Latest constrained-avatar and exact-message-participant rules deployed July 18, 2026; 7/7 emulator contracts pass |
| Storage rules | PASS | Latest owner/type/delete restrictions deployed July 18, 2026; emulator contracts pass |
| Required message indexes | PASS | Added without deleting ten legacy indexes; both new indexes report `READY` |
| Transaction/verification/chat callables | PASS | Six hardened Gen 1 callables report `ACTIVE` in `us-central1`; minimized verification submit/review versions were redeployed successfully |
| Public profile/trip projections | PASS | Gen 2 functions report `ACTIVE` in `europe-west1`; Eventarc source region is `eur3` |
| Copilot callable | PASS | Deployed with managed secret version 2; official Firebase SDK authentication and English ride, English package, and Arabic ride model calls passed after obsolete version 1 was destroyed |
| Inherited prototype Functions retirement | BLOCKED | Exact 36-function production deletion set requires a fresh owner confirmation because removal can interrupt legacy clients |

## Android and release checks

| Check | Current status | Notes |
| --- | --- | --- |
| Clean emulator install | PASS | Universal APK on `sdk_gphone64_x86_64`, API 36.1, `emulator-5554`; exact current package was removed to reclaim storage, then installation succeeded |
| Cold launch to Login | PASS | Login semantics present; no fatal Firebase/Flutter error |
| Credentialed emulator sign-in | BLOCKED | Credentials entered exactly in memory, but the emulator had no IP/DNS egress and Firebase Auth returned a network error; no invalid-credential or app crash occurred |
| Full deployed Home → Copilot → matches → details → verification → booking → chat | PENDING | Judge fixtures and Copilot are deployed; credentialed device run remains |
| Fresh-install end-to-end run #1 | PENDING | Must be recorded after deployment |
| Fresh-install end-to-end run #2 | PENDING | Must be recorded after deployment |
| Physical Android phone install | PENDING | Motorola phone connected by ADB; final release APK test remains |
| Universal judge APK candidate | PASS | Debug build; no safe release-signing configuration is present |
| Final deployed/tagged judge APK | PENDING | Rebuild/tag after live backend verification |
| Public sanitized repository | PASS | Both remote branches exactly match `9f58026`; RC1 and staged evidence tags pushed; original private repository has no remote |
| Published APK download and hash comparison | PENDING | GitHub repository and live Copilot are ready; final Release remains |
| Published APK install | PENDING | Run against the downloaded GitHub Release asset |

Local emulator note: Firebase emulators ran under the host's Node 24 while
`functions/package.json` declares production Node 20. All local builds,
contracts, rules, and integrations passed. The hardened callables and projection
triggers were also successfully built and deployed on the declared Node 20
runtime; Firebase warns that Node 20 is deprecated and must be upgraded after
the contest release.

## Latest recorded local APK

- Build type: universal debug judge candidate
- Path: `build/app/outputs/flutter-apk/app-debug.apk`
- Size: 154,878,330 bytes (147.70 MiB)
- Build timestamp: July 18, 2026 at 20:29:09 CDT / 18:29:09 PDT
- Release-gate source commit: `ba9c3436645195180120c012e286d033b2da21f6` (application code last changed at `15baa237707b3115475b09ca7a586e1c171517a7`)
- Source tag: `fitareeaee-copilot-rc1` after local/public tag creation
- SHA-256: `A35BE070C1D785D85AC26A62797FFDB3581EAE895148E13E078997A431DFC414`
- Universal installation/smoke: PASS after removing the exact older `com.fitareeaee.app` package and clean-installing; Login rendered, the activity was top-resumed, and no fatal Flutter/Android logs matched
- Credentialed attempt: NOT PASSED; exact in-memory entry reached Firebase Auth but the emulator could not reach `8.8.8.8` or resolve `identitytoolkit.googleapis.com`. The app displayed a safe network error and remained responsive. A credential-bearing diagnostic screenshot was immediately deleted from host and emulator.
- APK archive audit: PASS; no `.env`, `google-services.json`, service-account JSON, keystore, OpenAI/OpenRouter/Stripe secret key name, or private-key PEM in the archive; no token-shaped match in the application payload
- APK signature: PASS; Android Signature Scheme v2, one expected Android Debug signer, certificate SHA-256 `DD8994FB11A2ED8066A1DB41052FD186A8D7DC1D3680007DFE6D4ECC16BC5AC3`
- Package metadata: `com.fitareeaee.app`, version `1.0.0` (`20260718`), label `Fitareeaee Copilot`, min API 24, target/compile API 36, ABIs `arm64-v8a`, `armeabi-v7a`, and `x86_64`

This is a local engineering checkpoint, not yet the published judge artifact.

## Release gate

Before submission, rerun and record all mandatory commands on the exact tagged release commit, then complete the blocked Android rows above. Do not convert a pending row to pass based on code inspection alone.
