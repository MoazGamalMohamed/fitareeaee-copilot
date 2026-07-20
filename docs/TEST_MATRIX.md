# Test Matrix

This matrix distinguishes completed local verification from release checks that require credentials, deployment, publication, or a physical device.

Status key: **PASS** = directly observed; **PENDING** = not yet executed; **BLOCKED** = requires an external action or credential.

## Automated verification

| Area | Command / coverage | Current status | Evidence |
| --- | --- | --- | --- |
| Formatting | `dart format --output=none --set-exit-if-changed lib test` | PASS | Release-cleanup revision: 111 files, 0 changes |
| Static analysis | `flutter analyze` | PASS | `No issues found!` |
| Flutter suite | `flutter test` | PASS | Final phone-fixed revision: 19/19 tests |
| Copilot ranking | Best-match order, hard exclusions, request/offer direction, stale trips, package capacity, Arabic city normalization | PASS | Focused ranking coverage |
| Copilot interaction | Draft display, failure retry/manual fallback, explicit confirmation, seat-count handoff | PASS | Three focused tests: two widget tests plus one route/unit test |
| Functions contracts | Booking/cancellation, trip-scoped conversation IDs, public-trip projection, verification, Copilot validation/auth/redaction/Arabic/throttling/diagnostics | PASS | 19/19 tests |
| Functions build | `npm run build` in `functions/` | PASS | TypeScript compiler exit 0 |
| Firestore/Storage rules | Booking/chat/public-profile/verification/rate-limit/support authorization boundaries | PASS | 8/8 emulator contracts, including owner-scoped support tickets and blocked staff impersonation |
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
| Firestore rules | PASS | Support-ticket and confirmed-chat rules deployed July 19, 2026; 8/8 emulator contracts pass |
| Storage rules | PASS | Owner/type/delete restrictions redeployed July 19, 2026; emulator contracts pass |
| Required message indexes | PASS | Added without deleting ten legacy indexes; both new indexes report `READY` |
| Transaction/verification/chat callables | PASS | `authorizeBookingConversation` is deployed and `ACTIVE` with the retained hardened callables in `us-central1` |
| Public profile/trip projections | PASS | Gen 2 functions report `ACTIVE` in `europe-west1`; Eventarc source region is `eur3` |
| Copilot callable | PASS | Deployed with managed secret version 2; official Firebase SDK authentication and English ride, English package, and Arabic ride model calls passed after obsolete version 1 was destroyed |
| Inherited prototype Functions retirement | BLOCKED | Exact 36-function production deletion set requires a fresh owner confirmation because removal can interrupt legacy clients |

## Android and release checks

| Check | Current status | Notes |
| --- | --- | --- |
| Clean emulator install | PASS | Universal APK on `sdk_gphone64_x86_64`, API 36.1, `emulator-5554`; exact current package was removed to reclaim storage, then installation succeeded |
| Cold launch to Login | PASS | Login semantics present; no fatal Firebase/Flutter error |
| Credentialed emulator sign-in | BLOCKED | Credentials entered exactly in memory, but the emulator had no IP/DNS egress and Firebase Auth returned a network error; no invalid-credential or app crash occurred |
| Full deployed Home → Copilot → matches → details → verification → booking → chat | PASS | On the Motorola phone, a live GPT-5.6 draft produced one transparent live match and handed off to Trip Details then enabled confirmed Chat. In the same fictional session, the server-authoritative booking transaction opened an authorized conversation and a sent message rendered through the realtime stream. The judge account's prior verification state was already satisfied; no real payment is claimed. |
| Fresh-install end-to-end run #1 | INTERRUPTED | Public v1.0.3 local data clear/reinstall, 3.706 s cold launch, private fictional sign-in, Home, live GPT-5.6 draft, one match, and Trip Details all passed. The phone disconnected before the final booking confirmation tap. |
| Fresh-install end-to-end run #2 | PENDING | Must be recorded after deployment |
| Physical Android phone install | PASS | Exact public v1.0.5 candidate installed on Moto G Play (2024), cold-launched in 2.587s and 1.391s, rendered Home/Chat/manual Request, and produced zero app fatal/Flutter/ANR matches |
| Universal judge APK candidate | PASS | AOT profile build, debug-signed for sideloading; no safe private release-signing configuration is present |
| Final deployed/tagged judge APK | PASS | Tag `fitareeaee-copilot-v1.0.5`; private source `4630703`, sanitized source `6d67f306`, identical source tree verified |
| Public sanitized repository | PASS | Draft PR branch resolves to sanitized source `6d67f306`; v1.0.5 peels exactly to that source; original private repository has no remote |
| Published APK download and hash comparison | PASS | Public v1.0.5 asset downloaded; 83,378,603 bytes and SHA-256 exactly match the phone-tested local artifact |
| Published APK install | PASS | Exact downloaded v1.0.5 asset clean-installed/launched on emulator and installed/cold-launched on Motorola; Chat empty state rendered without the prior error |

Local emulator note: Firebase emulators ran under the host's Node 24 while
`functions/package.json` declares production Node 20. All local builds,
contracts, rules, and integrations passed. The hardened callables and projection
triggers were also successfully built and deployed on the declared Node 20
runtime; Firebase warns that Node 20 is deprecated and must be upgraded after
the contest release.

## Historical v1.0.1 published APK

- Build type: universal debug-signed judge APK
- Path: `build/app/outputs/flutter-apk/app-debug.apk`
- Size: 154,878,330 bytes (147.70 MiB)
- Build timestamp: July 18, 2026 at 22:46:23 CDT / 20:46:23 PDT
- Release-gate source commit: private `c5b67364835aa32a59f6e40e7b2055c6aed8d5d0`; sanitized `865a5e8a6d6e581fbcd781e5a4ba936529406609`
- Source tag: `fitareeaee-copilot-v1.0.1`
- SHA-256: `468E3407683A96C1C471BC62E23320221934613DEDAAAA818AF71C532F3B709D`
- Public URL: `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.1/app-debug.apk`
- Universal installation/smoke: PASS after downloading the public asset, verifying its exact hash, removing only the emulator's older `com.fitareeaee.app` package/data, and clean-installing; Login rendered, the activity was top-resumed, and no fatal Flutter/Android logs matched
- Physical installation/smoke: PASS on `moto g play - 2024`; public v1.0.1 cold-launched, the legacy `tripCancellation` record rendered without a raw error, and Plan with AI was visible. A later audit found that the claimed reviewable-draft observation was a false-positive match against static disclosure text. Authenticated phone calls did reach the deployed Function and return HTTP 200, and the local superseding build now auto-reveals the result; visible confirmation on an idle phone remains pending.
- Credentialed attempt: NOT PASSED; exact in-memory entry reached Firebase Auth but the emulator could not reach `8.8.8.8` or resolve `identitytoolkit.googleapis.com`. The app displayed a safe network error and remained responsive. A credential-bearing diagnostic screenshot was immediately deleted from host and emulator.
- APK archive audit: PASS; no `.env`, `google-services.json`, service-account JSON, keystore, OpenAI/OpenRouter/Stripe secret key name, or private-key PEM in the archive; no token-shaped match in the application payload
- APK signature: PASS; Android Signature Scheme v2, one expected Android Debug signer, certificate SHA-256 `DD8994FB11A2ED8066A1DB41052FD186A8D7DC1D3680007DFE6D4ECC16BC5AC3`
- Package metadata: `com.fitareeaee.app`, version `1.0.0` (`20260718`), label `Fitareeaee Copilot`, min API 24, target/compile API 36, ABIs `arm64-v8a`, `armeabi-v7a`, and `x86_64`

This is the published judge artifact. It is intentionally debug-signed for
contest sideloading because no safe private release-signing configuration was
available.

## Historical v1.0.2 published APK

- Build type: universal debug-signed Android judge APK
- Path: `build/app/outputs/flutter-apk/app-debug.apk`
- Size: 154,994,394 bytes (147.81 MiB)
- Build timestamp: July 19, 2026 at 12:52:51 CDT / 10:52:51 PDT
- SHA-256: `77B2DEB5C5C482B741911C12BA8593E755EE6DC8EA892D76AA7682167F8C0D8B`
- Motorola Moto G Play (2024): install PASS; cold launch PASS in 3.684 seconds;
  no AndroidRuntime or Flutter crash output
- API 36 emulator: clean install PASS; activity launch timed out waiting for the
  fully drawn signal, but the process remained alive and Login rendered in the
  preceding same-source smoke
- Sanitized source/tag: `5ad4b94` / `fitareeaee-copilot-v1.0.2`
- Public URL:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.2/app-debug.apk`
- Publication verification: PASS; the GitHub asset was downloaded to
  `build/published-download-v102/app-debug.apk`, size and SHA-256 matched exactly,
  and that downloaded copy installed and cold-launched on the Motorola phone in
  4.035 seconds with no AndroidRuntime or Flutter crash output

## Current v1.0.3 published APK

- Build type: universal debug-signed Android judge APK
- Path: `build/app/outputs/flutter-apk/app-debug.apk`
- Size: 154,995,438 bytes (147.82 MiB)
- Build timestamp: July 19, 2026 at 13:51:01 CDT / 11:51:01 PDT
- SHA-256: `543B2FE7FFFEF43C831039A3A5557D005489BF7A451E3C3566B42A487AFD4EC0`
- Private/sanitized source: `832a543cd94c4f5a2a8c17163e73113da85aba24` /
  `c42bc3f4c04d960b8ab09804b90c1a3d4ef50e43`
- Source tag: `fitareeaee-copilot-v1.0.3` (peels to `c42bc3f`)
- Public URL:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.3/app-debug.apk`
- Publication verification: PASS; GitHub asset digest, downloaded file, and local file
  all equal the SHA-256 above and are exactly 154,995,438 bytes
- Motorola Moto G Play (2024): downloaded asset install PASS; cold launch status `ok`
  in 3.693 seconds; authenticated Chat rendered `No conversations yet`; neither the
  former loading error nor `FirebaseFailure` appeared; AndroidRuntime/Flutter
  error-focused output was empty

## Current v1.0.4 local candidate

- Release source: private `a27c2d933043353ccc07c2434f99b1276f3904c2`.
- Flutter gate: format 114/0 changed, analysis clean, tests 19/19.
- Backend gate: TypeScript build PASS, contracts 25/25, rules 8/8, transactional
  booking/chat integration 4/4.
- Firebase deploy: PASS to the confirmed `fitareeaee` project for the eight scoped
  booking/chat/trip/support callables and Firestore rules/indexes.
- Debug APK: 155,021,938 bytes; SHA-256
  `E7A56969186D2401848E3B375909D8FC40BC7BE685861624C4166253964CECFC`.
- Optimized profile APK: 83,181,715 bytes; SHA-256
  `BE4D0FBDD04C023994C0DB228D834552FCB01CFB011E1DC6C898C8EEE5089CE6`.
- API 36 emulator: debug clean install and initial Login/top-resumed/no-fatal-log
  smoke PASS. A subsequent heavy automation run caused an emulator ANR; after an AOT
  profile install, Android failed to attach the app process and the emulator later
  remained in boot animation. The optimized candidate therefore still requires a
  fresh healthy-device smoke test.
- Physical phone: BLOCKED for this candidate because `adb devices -l` enumerated only
  `emulator-5554`. Do not infer a v1.0.4 phone pass from the older v1.0.3 evidence.
- Sanitized publication: source `d81c4b23`, evidence/tag `ad351f3a`, draft PR #1,
  annotated tag `fitareeaee-copilot-v1.0.4`, and an accurately labeled pre-release.
- Public download verification: PASS; 83,181,715 bytes and SHA-256
  `BE4D0FBDD04C023994C0DB228D834552FCB01CFB011E1DC6C898C8EEE5089CE6`
  exactly match GitHub's asset metadata and the local candidate.
- Downloaded-copy emulator install: PASS. Fitareeaee Login visibly rendered,
  `MainActivity` was top-resumed, the process remained alive, and the app-specific
  fatal/Flutter/ANR scan was empty. The emulator's Pixel Launcher/System UI produced
  separate ANR dialogs, so a healthy physical-device navigation run remains required
  before promoting the pre-release to final.

## Release gate

Before submission, rerun and record all mandatory commands on the exact tagged release commit, then complete the blocked Android rows above. Do not convert a pending row to pass based on code inspection alone.

## Local v1.0.6 lifecycle/map/voice candidate

- Source: private `47f49ce`.
- Format/analyze/Flutter: 115 files/0 changed, 0 issues, 19/19.
- Functions/rules/integration: 28/28, 9/9, 7/7.
- Authenticated emulator UI: Home role actions, manual request form, interactive map
  pin return, speech permission/live listening, Trips role chooser, driver gate, and
  completed-only Past state PASS.
- Final universal APK: 194,300,168 bytes; SHA-256
  `9DB36ED8D8A18684D50BA316AA2B5AC433929D1D89B33BCE50EDEDBDF1024EF3`.
- Exact final x86_64 split: clean install and explicit cold-launch retry PASS;
  Login/Welcome rendered, process alive, no matching app fatal/Flutter/bootstrap/ANR
  logs. Universal emulator install was blocked only by emulator free space.
- Physical phone: NOT RETESTED for v1.0.6; user reserved/disconnected it during this
  checkpoint. Existing v1.0.5 phone evidence must not be relabeled as v1.0.6.
- Publication: pending because `gh` is missing; stable public v1.0.5 remains intact.

## Superseding v1.0.5 judge candidate

- Source: private `4630703b5a69e151d07d6e6c9683deced6298302`; sanitized
  `6d67f306203886d3d1623f9966f36764589b9cfb`; identical tree
  `eb32120d74af47cc0e604729055b4e67d92f2aa9`.
- Flutter: format 114 files/0 changes, analysis 0 issues, tests 19/19.
- Functions: TypeScript build PASS and contracts 27/27.
- Firestore/Storage authorization rules: 8/8 PASS.
- Auth/Firestore/Functions integration: 5/5 PASS. The new scenario proves a
  verified driver proposal stays `potential`, unauthorized selection fails, rider
  selection creates only `pending_payment` / `required`, inventory is unchanged,
  and chat authorization remains denied.
- Scoped deployment: `proposeForTripRequest`, `selectTripProposal`, and
  `withdrawTripProposal` successfully created in `fitareeaee`; no data/rule/index
  deletion and no billing change.
- Public universal profile APK: 83,378,603 bytes; version `1.0.5` / code
  `20260719`; SHA-256
  `0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`.
- Public redownload: exact size/hash match and clean emulator install PASS.
  Explicit emulator launch reached top-resumed `MainActivity`; process alive;
  0 Fitareeaee fatal, Flutter-error, or app-ANR matches. Pixel Launcher/System UI
  ANRs remain an unrelated emulator fault.
- Motorola Moto G Play (2024): public APK update install PASS; two cold launches
  PASS in 2.587s and 1.391s; authenticated Home visibly showed Plan with AI,
  Request a Trip, and Offer a Ride; Chat rendered the paid-confirmed-only empty
  state without `FirebaseFailure`; Request a Trip opened the complete manual form;
  0 app fatal, Flutter-error, or app-ANR matches.
- Real payment is not configured. New selections correctly stop at pending payment;
  the seeded paid/confirmed fixture is required to demonstrate chat. This boundary
  is a deliberate safety result, not a payment-provider pass.
