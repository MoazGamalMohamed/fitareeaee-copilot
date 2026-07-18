# Test Matrix

This matrix distinguishes completed local verification from release checks that require credentials, deployment, publication, or a physical device.

Status key: **PASS** = directly observed; **PENDING** = not yet executed; **BLOCKED** = requires an external action or credential.

## Automated verification

| Area | Command / coverage | Current status | Evidence |
| --- | --- | --- | --- |
| Formatting | `dart format --output=none --set-exit-if-changed lib test` | PASS | Stage 3/4 hardened revision: 119 files, 0 changes |
| Static analysis | `flutter analyze` | PASS | `No issues found!` |
| Flutter suite | `flutter test` | PASS | Hardened revision: 16/16 tests |
| Copilot ranking | Best-match order, hard exclusions, request/offer direction, stale trips, package capacity, Arabic city normalization | PASS | Focused ranking coverage |
| Copilot interaction | Draft display, failure retry/manual fallback, explicit confirmation, seat-count handoff | PASS | Focused widget tests: 3/3 |
| Functions contracts | Booking, conversation IDs, public-trip projection, verification, Copilot validation/auth/redaction/Arabic/throttling | PASS | 16/16 tests |
| Functions build | `npm run build` in `functions/` | PASS | TypeScript compiler exit 0 |
| Firestore/Storage rules | Booking/chat/public-profile/verification/rate-limit authorization boundaries | PASS | 7/7 emulator contracts |
| Callable integration | Concurrent final-seat booking, idempotent retry, cancellation inventory, unverified rejection | PASS | 3/3 against real Auth/Functions/Firestore emulators |
| Android build | `flutter build apk --debug` | PASS | Universal debug APK built |

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
| AI/backend failure | Retry plus manual-search fallback | PASS — UI path/code inspection |
| Live GPT-5.6 English/Arabic/package prompts | Real deployed Responses API behavior | BLOCKED — managed key/deployment pending |

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

## Android and release checks

| Check | Current status | Notes |
| --- | --- | --- |
| Clean emulator install | PASS | x86_64 APK on `sdk_gphone64_x86_64`, API 36.1, `emulator-5554`; universal APK exceeded this emulator's remaining storage |
| Cold launch to Login | PASS | Login semantics present; no fatal Firebase/Flutter error |
| Credentialed emulator sign-in | BLOCKED | Judge/test account not supplied yet |
| Full deployed Home → Copilot → matches → details → verification → booking → chat | BLOCKED | Requires deployment, test accounts, and seeded/live trips |
| Fresh-install end-to-end run #1 | PENDING | Must be recorded after deployment |
| Fresh-install end-to-end run #2 | PENDING | Must be recorded after deployment |
| Physical Android phone install | BLOCKED | No phone connected/owner interaction required |
| Universal judge APK candidate | PASS | Debug build; no safe release-signing configuration is present |
| Final deployed/tagged judge APK | PENDING | Rebuild/tag after live backend verification |
| Published APK download and hash comparison | BLOCKED | Stable public URL not created yet |
| Published APK install | BLOCKED | Stable public URL not created yet |

Local emulator note: Firebase emulators ran under the host's Node 24 while
`functions/package.json` declares production Node 20. All local builds,
contracts, rules, and integrations passed; deployment/CI on Node 20 remains the
exact-runtime release check.

## Latest recorded local APK

- Build type: universal debug judge candidate
- Path: `build/app/outputs/flutter-apk/app-debug.apk`
- Size: 156,206,220 bytes (148.97 MiB)
- Build timestamp: July 17, 2026 at 23:56:08 CDT
- Source commit: **PENDING — recorded in the append-only checkpoint immediately after commit**
- SHA-256: `CDE5929FF44A622C930F31FBC8DDBA7075B6D805A70F57C1FAFCBDEE2D72E985`
- Universal installation: not counted on the low-storage emulator (`INSTALL_FAILED_INSUFFICIENT_STORAGE`)
- Same-source x86_64 APK: 71,652,880 bytes; SHA-256 `303CE8EF1D579BF51BBDC7C21E29F6823268BEAC7C7CA422837583083BA58B1E`
- x86_64 installation/smoke: PASS after clean uninstall/install; Fitareeaee Login semantics present, process alive, and no fatal Android/Flutter logs

This is a local engineering checkpoint, not yet the published judge artifact.

## Release gate

Before submission, rerun and record all mandatory commands on the exact tagged release commit, then complete the blocked Android rows above. Do not convert a pending row to pass based on code inspection alone.
