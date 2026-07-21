# Test Matrix

This matrix distinguishes completed local verification from release checks that require credentials, deployment, publication, or a physical device.

Status key: **PASS** = directly observed; **PENDING** = not yet executed; **BLOCKED** = requires an external action or credential.

## Automated verification

| Area | Command / coverage | Current status | Evidence |
| --- | --- | --- | --- |
| Formatting | `dart format --output=none --set-exit-if-changed lib test` | PASS | v1.0.17 source: 132 files, 0 changes |
| Static analysis | `flutter analyze` | PASS | v1.0.17 source: `No issues found!` |
| Flutter suite | `flutter test` | PASS | v1.0.17 source: 49/49 tests |
| Deterministic ranking | Best-match order, hard exclusions, request/offer direction, stale trips, package capacity, Arabic city normalization | PASS | Focused ranking coverage |
| GPT-5.6 planner interaction | Draft display, failure retry/manual fallback, explicit confirmation, seat-count handoff, account-scoped reusable plans | PASS | Widget, domain, platform, and local-store coverage |
| Functions contracts | Booking/cancellation, owner withdrawal, lifecycle, matching, support, trip-scoped conversations, projections, verification, GPT-5.6 validation/auth/redaction/Arabic/throttling/diagnostics/safety identifier | PASS | Current Functions source: 32/32 tests |
| Functions build | `npm run build` in `functions/` | PASS | TypeScript compiler exit 0 |
| Firestore/Storage rules | Booking/chat/public-profile/verification/rate-limit/support authorization boundaries | PASS | 9/9 emulator contracts, including owner-scoped support tickets and blocked staff impersonation |
| Callable integration | Proposal/payment boundary, idempotency, verification, owner withdrawal, chat, start, completion, rating, and emergency cancellation | PASS | 10/10 against real Auth/Functions/Firestore emulators |
| Android build | `flutter build apk --debug` and `flutter build apk --profile` | PASS | v1.0.17 universal debug and optimized profile builds passed; code `20260731` |

## GPT-5.6 planner behavior

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
| User saves a recurring request | Template remains editable, local, bounded, and isolated by signed-in UID | PASS — store/widget coverage plus authenticated emulator reuse |
| Confirmation before persistence | Confirmation performs deterministic search only | PASS — widget/code contract |
| No matching Firestore trips | Empty state; no fabricated trip | PASS — domain/widget behavior |
| AI/backend failure | Retry plus manual-search fallback | PASS — focused widget test |
| Live GPT-5.6 English/Arabic/package prompts | Real deployed Responses API behavior | PASS — exact public v1.0.13 APK returned strict `gpt-5.6` review drafts for an English ride, 5 kg English package, and Arabic ride on July 20 |
| Live GPT-5.6 driver Offer after final safety update | Authenticated driver receives a review-required Offer draft; no trip or booking is created | PASS — exact v1.0.17 phone build returned a Dallas-to-Austin Offer draft through the deployed callable on July 21 |
| OpenAI end-user safety identifier | Stable per app user, different across users, and raw Firebase UID not transmitted | PASS — 64-character SHA-256 contract plus deployed v1.0.17 live call |
| Account switch and sign-out | Correct Home role after sign-in; Login after sign-out; no stale listener exception | PASS — v1.0.14 API 36 rider/driver regression with cleared-log scan |
| Driver offer discoverability | Driver Home explains the receiving role and verification requirements; rider Home explains that offering needs a separate driver account | PASS — focused tests plus exact-public v1.0.16 phone semantics |
| Generated map label after repick | A generated `Map pin` label follows the newly selected coordinate; semantic/manual place labels are preserved | PASS — focused unit test and physical From/To map selection |
| Owner withdraws an open trip | Owner can withdraw only a pending unpaid trip; unpaid interest closes, paid/confirmed state is rejected, history remains, marketplace entry disappears | PASS — contract, 10/10 integration, scoped live deployment, and v1.0.16 phone UI/live callable |

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
| Firestore rules | PASS | One-time rating lookup rule deployed July 20, 2026 after 9/9 Firestore/Storage emulator contracts passed |
| Storage rules | PASS | Owner/type/delete restrictions redeployed July 19, 2026; emulator contracts pass |
| Required message indexes | PASS | Added without deleting ten legacy indexes; both new indexes report `READY` |
| Transaction/verification/chat callables | PASS | `authorizeBookingConversation` is deployed and `ACTIVE` with the retained hardened callables in `us-central1` |
| Public profile/trip projections | PASS | Gen 2 functions report `ACTIVE` in `europe-west1`; Eventarc source region is `eur3` |
| GPT-5.6 planner callable | PASS | Live function inventory includes internal callable `planTripWithCopilot`; metadata-only checks show managed secret version 2 enabled and version 1 destroyed; fresh authenticated three-prompt matrix passed without reading the key |
| Support/matching/lifecycle callables | PASS | Current live inventory confirms support, proposal selection/withdrawal, trip start/complete/cancel/rating, and conversation authorization Functions are deployed. Exact-public v1.0.13 reopened the fictional payment ticket, rendered the bounded GPT-5.6 answer, showed Human queue escalation, and produced no visible support loading error. |
| Inherited prototype Functions retirement | BLOCKED | Exact 36-function production deletion set requires a fresh owner confirmation because removal can interrupt legacy clients |

## Android and release checks

| Check | Current status | Notes |
| --- | --- | --- |
| Clean emulator install | PASS | Universal APK on `sdk_gphone64_x86_64`, API 36.1, `emulator-5554`; exact current package was removed to reclaim storage, then installation succeeded |
| Cold launch to Login | PASS | Login semantics present; no fatal Firebase/Flutter error |
| Credentialed v1.0.8 UI sign-in | PASS | Exact fresh-installed profile APK signed in with the fictional rider and rendered Home; the same credentials passed direct Firebase Auth verification without being printed. |
| v1.0.8 manual map creation | PASS | Request a Trip opened the full form and interactive OpenStreetMap origin picker with actionable attribution and location confirmation. |
| v1.0.8 voice recognition | PASS | Runtime microphone permission rendered; Android `RecognitionService#onStartListening`, online recognizer, and audio input opened with `en-US`. The silent emulator produced no transcript, as expected. |
| v1.0.8 payment boundary | PASS | Review and Pay showed verified identity; booking creation yielded `Payment required - not confirmed`, kept seats at 3/3, and kept chat locked. |
| v1.0.8 paid chat | PASS | Seeded paid/confirmed conversation loaded without `FirebaseFailure`; a new smoke message rendered through the realtime stream. |
| v1.0.8 completed/rating path | PASS | Past showed the completed booking; details removed Book Trip, stated chat closed, and opened the one-time Rate Your Trip screen. |
| v1.0.9 owned-trip labels | PASS | Exact candidate driver UI labels the active booking `Confirmed` and the past trip `Completed`; neither is falsely labeled `Full`. Assigned-driver start/chat/emergency actions remain visible. |
| v1.0.9 Settings and Payments | PASS | Exact public rider UI exposes unified Support, English/Arabic preferences, USD currency, notification/location disclosures, disabled real-card/escrow collection, rider-pay/driver-receive activity, and the driver-priority metric only after 50 completed rides/deliveries. |
| Full deployed Home → Copilot → matches → details → verification → booking → chat | PASS | On the Motorola phone, a live GPT-5.6 draft produced one transparent live match and handed off to Trip Details then enabled confirmed Chat. In the same fictional session, the server-authoritative booking transaction opened an authorized conversation and a sent message rendered through the realtime stream. The judge account's prior verification state was already satisfied; no real payment is claimed. |
| Fresh-install end-to-end run #1 | INTERRUPTED | Public v1.0.3 local data clear/reinstall, 3.706 s cold launch, private fictional sign-in, Home, live GPT-5.6 draft, one match, and Trip Details all passed. The phone disconnected before the final booking confirmation tap. |
| Fresh-install end-to-end run #2 | PASS (emulator) | Exact anonymously downloaded public v1.0.9 profile APK clean install, fictional rider sign-in, manual map pin/attribution, voice service/audio startup, payment gate, paid Chat, completed-only Past, and rating entry passed. Physical-phone repetition remains pending. |
| Physical Android phone install | PASS (v1.0.17) | Exact public v1.0.17 installed on Moto G Play (2024), reported version `1.0.17` / code `20260731`, cold-launched in 2.803 seconds, retained the fictional driver, rendered Home/Offer, exposed the Codex/GPT-5.6 disclosure, and returned a live review-required Offer draft. Zero matched app fatal/Flutter/FirebaseFailure/unhandled/ANR errors appeared. Exact-public v1.0.16 retains the unchanged map/withdrawal/chat/Past lifecycle evidence. |
| Universal judge APK candidate | PASS | AOT profile build, debug-signed for sideloading; no safe private release-signing configuration is present |
| Tagged judge APK candidate | PASS (prerelease) | v1.0.17 private source `ddddea24124eb1b2f83e27eafd108533728c0a7c` is tree-identical to sanitized/tagged source `05b2e2c998ddf67a3a61130c0982573f283bbb3d`; the public prerelease and exact asset are available. |
| Public sanitized repository | PASS | Draft PR branch and v1.0.17 tag were pushed without force; the tag peels to `05b2e2c9`. A 128-revision/2,886-object-path reachable-history scan found 0 forbidden private config/credential paths, 0 high-signal secret-hit files, and 0 rewrite refs. The original private repository still has no remote. |
| Published APK download and hash comparison | PASS | Public v1.0.17 asset downloaded anonymously; 85,703,335 bytes and SHA-256 `5C7AA44027BEFA3CF097ABB0E57503799EEEC6370BFABC01070A572A5FC6AC9B` exactly match local and GitHub's digest. |
| Published APK install | PASS (physical phone) | Exact downloaded v1.0.17 asset update-installed on the Moto G Play. Version `1.0.17` / code `20260731`, minimum API 24, and target API 36 were confirmed. Driver Home/Offer, live GPT-5.6 draft, disclosure, and zero matched app errors passed. |

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

## Public v1.0.11 role-path/voice/location prerelease candidate

- Build type: optimized universal AOT profile APK, debug-signed for judge sideloading.
- Private source: `b05c91fd2b6856952a028866ec57a83c57ac116e`.
- Tree-equivalent sanitized/tagged source:
  `4e1439b098c53c41bf9d95b9f82f3a607b0240bc`.
- Path: `build/app/outputs/flutter-apk/app-profile.apk`.
- Size: 109,583,813 bytes.
- SHA-256: `54E60FE42884A8EFB7FAB8C76DA21F9F43D2C4A2BA55A21C6DA3DACFBCC44EDD`.
- Package/version: `com.fitareeaee.app`, `1.0.11` / code `20260725`, minimum API
  24, target API 36.
- Emulator: exact local and anonymously downloaded public bytes installed on
  `emulator-5554` / `sdk_gphone64_x86_64`; authenticated circular Copilot,
  role-specific Request, map, profile suggestions, Settings, Support, microphone
  permission/audio, accurate no-speech recovery, and 0 app-specific fatal matches
  passed.
- Public release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.11`.
- Direct APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.11/app-profile.apk`.
- Physical-phone install and spoken transcription: pending until the owner device
  reconnects; v1.0.5 remains the phone-tested rollback.

## Public v1.0.10 verification/map/action-audit prerelease candidate

- Exact APK source: private `9b92625f20912607d3c7ce32db9902fc76971eae`;
  tree-equivalent sanitized/tagged
  `fe73ad5509ac348f120b025688eee1abd2c009d8`.
- Format/analyze/Flutter: 121 files/0 changed, 0 issues, 30/30.
- Functions/contracts: TypeScript build PASS and 28/28; Firestore/Storage rules 9/9;
  authenticated callable integration 7/7.
- Public profile APK: 85,276,887 bytes; SHA-256
  `F476B31F2097845DAF7159157166F2F940551F6838A9EC75BD493E21F884CE59`;
  package `com.fitareeaee.app`, version `1.0.10` / code `20260724`, min API 24,
  target/compile API 36.
- Anonymous download exactly matched local bytes and GitHub's asset digest. That
  exact downloaded copy installed, cold-launched, and authenticated as the fictional
  rider. Verification Center, origin and destination full-field map launch, all
  Trips tabs, paid-confirmed Chat, safe cancellation confirmation, Settings,
  Support, Payments, Notifications, Copilot examples, and microphone permission
  passed; 0 app-specific fatal/Flutter/FirebaseFailure/ANR matches were found.
- Public release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.10`.
- Direct APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.10/app-profile.apk`.
- Physical phone: PENDING while disconnected. Stable v1.0.5 remains the rollback.

## Public v1.0.9 truthful-status prerelease candidate

- Exact APK source: private `ab792130938601370f5ccf87ef4af3ff0290076e`;
  tree-equivalent sanitized/tagged
  `ef2eecb7cdc9a0e446c7a15d0d72b335820ffd56`.
- Format/analyze/Flutter: 119 files/0 changed, 0 issues, 25/25.
- Functions/contracts: TypeScript build PASS and 28/28. Rules and callable source
  were unchanged from the passing deployed 9/9 and 7/7 checkpoints.
- Public profile APK: 85,276,819 bytes; SHA-256
  `95B172EE6003D9A35D407033A8E88D272859A6147FA9AD1E30D647B43E0047C1`;
  package `com.fitareeaee.app`, version `1.0.9` / code `20260723`, min API 24,
  target/compile API 36, APK Signature Scheme v2, one expected Android Debug
  signer certificate SHA-256
  `DD8994FB11A2ED8066A1DB41052FD186A8D7DC1D3680007DFE6D4ECC16BC5AC3`.
- Anonymous download exactly matched local bytes and GitHub's asset digest. That
  exact downloaded copy clean-installed and authenticated as the fictional rider;
  Home/manual map, speech-service/audio startup, payment lock with seats unchanged,
  paid Chat, completed Past, and rating entry passed. A separate authenticated
  driver update rendered Confirmed and Completed instead of false Full;
  the active details exposed paid/confirmed Chat, driver start, and emergency-admin
  cancellation; the confirmed conversation loaded; 0 app-specific fatal/Flutter/
  FirebaseFailure/ANR matches were found.
- Public release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.9`.
- Direct APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.9/app-profile.apk`.
- Physical phone: PENDING while disconnected. Stable v1.0.5 remains the rollback.

## Public v1.0.8 voice/verification/lifecycle prerelease candidate

- Exact APK source: private `3817ed587bc141856c7c20eed126aa8c5508091e`;
  tree-equivalent sanitized/tagged
  `54b1654cf42d716d47d56b1e649da139d6f9b097`; shared tree
  `a70f617ef8a780664e1802fb23141c14fc3c6ac0`.
- Format/analyze/Flutter: 118 files/0 changed, 0 issues, 23/23.
- Functions/contracts/rules/integration: TypeScript build PASS, 28/28, 9/9,
  and 7/7 respectively.
- Profile APK: 109,174,213 bytes; SHA-256
  `333174AAFC5CC1BC12060FCB41F3A1372F51F5453C50792650AFF9A9721C2B18`;
  package `com.fitareeaee.app`, version `1.0.8` / code `20260722`, min API 24,
  target/compile API 36, APK Signature Scheme v2, one expected Android Debug
  signer certificate SHA-256
  `DD8994FB11A2ED8066A1DB41052FD186A8D7DC1D3680007DFE6D4ECC16BC5AC3`.
- Anonymous public download exactly matched local size/hash. The exact downloaded
  bytes fresh-installed and authenticated on API 36; Home, paid Chat, and completed
  Past rendered with zero app-specific fatal/Flutter/Firebase/ANR matches.
- The preceding local exact-binary flow also passed manual map selection, Android
  recognition-service/audio startup, verified identity, payment-required/not-
  confirmed booking with seats unchanged, closed completed chat, and rating entry.
- Physical phone: PENDING while disconnected. Stable v1.0.5 remains the rollback.

## Public v1.0.7 map-compliant prerelease candidate

- Exact APK source: private `96343be`; tree-equivalent sanitized/tagged
  `06195d02398c32783fa894f7e1bb5ab1d5fb4daf`; shared tree
  `0da079592d723eb149fbcaf75cb822305a60e54b`.
- Format/analyze/Flutter: 116 files/0 changed, 0 issues, 20/20. The new focused
  test proves OpenStreetMap attribution is permanently visible and actionable.
- Functions/contracts/rules: TypeScript build PASS, 28/28 implementation
  contracts, and 9/9 Firestore/Storage emulator authorization contracts.
- Android builds: universal debug and optimized universal profile PASS.
- Profile APK: 85,260,359 bytes; SHA-256
  `CC8191D87DB2DEF700FC1D537807C8E43AC499727C2C0E1B53AB17D3729DAEC6`;
  package `com.fitareeaee.app`, version `1.0.7` / code `20260721`, min API 24,
  target/compile API 36, APK Signature Scheme v2, one expected Android Debug
  signer certificate SHA-256
  `DD8994FB11A2ED8066A1DB41052FD186A8D7DC1D3680007DFE6D4ECC16BC5AC3`.
- Public release: `fitareeaee-copilot-v1.0.7` prerelease. Anonymous download
  exactly matched the local size/hash and passed API 36 reinstall, version,
  top-resumed process, process-alive, and 0 app-specific fatal/Flutter/Firebase/
  ANR log checks.
- A clean API 36 cold launch reached the visible Login screen in 16.475 seconds.
  Long synthetic ADB character injection was abandoned after it mangled test
  input and triggered an emulator not-responding dialog; it is not used as an
  authenticated v1.0.7 pass. The test app data and credential-bearing captures
  were deleted and the fictional judge passwords were rotated afterward.
- Physical phone and normal-keyboard authenticated demo path: PENDING while the
  phone is disconnected. Existing v1.0.5 phone and v1.0.6 authenticated-emulator
  evidence is not relabeled as v1.0.7.

## Public v1.0.6 lifecycle/map/voice prerelease candidate

- Source: private `47f49ce`; tree-equivalent sanitized/tagged `9194066a`.
- Format/analyze/Flutter: 115 files/0 changed, 0 issues, 19/19.
- Functions/rules/integration: 28/28, 9/9, 7/7.
- Authenticated emulator UI: Home role actions, manual request form, interactive map
  pin return, speech permission/live listening, Trips role chooser, driver gate, and
  completed-only Past state PASS.
- Final universal APK: 194,300,168 bytes; SHA-256
  `9DB36ED8D8A18684D50BA316AA2B5AC433929D1D89B33BCE50EDEDBDF1024EF3`.
- Optimized universal profile judge candidate: 85,293,151 bytes; SHA-256
  `39557F17E593F51620249DA5E1E218463B1EAA237BB0C170FB2F2FB2013F12F0`;
  clean install, cold launch, fictional judge authentication, and Home role-action
  smoke PASS on API 36.
- APK metadata/signature: PASS; package `com.fitareeaee.app`, version `1.0.6`
  (`20260720`), min API 24, target/compile API 36, Android Signature Scheme v2,
  and the expected single Android Debug signer certificate SHA-256
  `DD8994FB11A2ED8066A1DB41052FD186A8D7DC1D3680007DFE6D4ECC16BC5AC3`.
- Exact final x86_64 split: clean install and explicit cold-launch retry PASS;
  Login/Welcome rendered, process alive, no matching app fatal/Flutter/bootstrap/ANR
  logs. Universal emulator install was blocked only by emulator free space.
- Physical phone: NOT RETESTED for v1.0.6; user reserved/disconnected it during this
  checkpoint. Existing v1.0.5 phone evidence must not be relabeled as v1.0.6.
- Publication: PASS as an accurately labeled prerelease. Sanitized branch head
  `455a8706`, draft PR #1, annotated tag `fitareeaee-copilot-v1.0.6` (peels to
  `9194066a`), and the 85,293,151-byte APK are public without force-push.
- Public-download verification: PASS. Anonymous download to
  `build/published-download-v106/app-profile.apk` exactly matched SHA-256
  `39557F17E593F51620249DA5E1E218463B1EAA237BB0C170FB2F2FB2013F12F0`;
  clean API 36 install/cold launch reached visible Login/Welcome, version
  `1.0.6` / code `20260720`, top-resumed process, and 0 app-specific fatal/error
  matches. Stable public v1.0.5 remains intact pending the phone gate.

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
