# Resume Here

Last updated: 2026-07-20 00:46 CDT / 2026-07-19 22:46 PDT

## Current objective

Phone-test and promote the published v1.0.7 lifecycle/map/voice/map-compliance prerelease, then
finish owner-required credential rotation, video, `/feedback`, legal review, and
Devpost submission. Do not restart the audit or replace the payment gate with
simulated money.

## Source and GitHub state

- Private workspace: `C:\Users\moaaz\New Project\project_backup\fitareeaee`
- Private branch: `build-week/final`
- Passing private APK source: `96343be`; current private evidence head is the
  latest local `build-week/final` commit shown by `git log -1`
- Sanitized publication clone:
  `C:\Users\moaaz\New Project\project_backup\fitareeaee-copilot-public`
- Public branch: `agent/payment-gated-chat-trip-support`
- Passing sanitized source/tag: `06195d02398c32783fa894f7e1bb5ab1d5fb4daf`
- Current sanitized branch head before the documentation follow-up: `06195d02`
- Private/public APK-source tree: `0da079592d723eb149fbcaf75cb822305a60e54b`
- Draft PR #1 is open and unmerged:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/pull/1`
- Annotated tag `fitareeaee-copilot-v1.0.7` exists locally/remotely and peels to
  `06195d02`. The matching APK is an accurately labeled prerelease; no force push
  was used. v1.0.5 remains the stable rollback.
- Never add a remote to or push the private original repository. Publish only from
  the sanitized clone after a reachable-history secret scan.

## Current product boundary

- Home visibly provides **Plan with AI**, **Request a Trip**, and verification-gated
  **Offer a Ride**.
- Manual Request/Offer uses the full editable ride/package form. Plan with AI remains
  a Home-only assisted entry point and hands an editable draft into the same flow.
- A verified driver can submit a bounded proposal to a rider request. The rider is
  always the paying party; the driver never pays.
- Proposal selection creates only `pending_payment` / `required`. It does not
  decrement seats, confirm the trip, create a conversation, or authorize chat.
- Chat requires a booking that is both `confirmed` and `paid`. No real payment
  provider is configured; use the seeded paid/confirmed fixture for the chat demo.
- Contact Support uses GPT-5.6 first and supports explicit/automatic staff escalation.
- Manual trip creation includes interactive origin/destination map pins. Copilot
  supports English/Arabic speech recognition and read-back assistance.
- Paid confirmed trips can be started/completed by the assigned driver; chat stays
  open while in progress and closes after completion/cancellation; completed trips
  support one immutable server-owned rating per participant.

## Deployed Firebase state

- Confirmed project: `fitareeaee`.
- Newly deployed/updated lifecycle surface: `createBooking`, `cancelBooking`,
  `createTrip`, `startTrip`, `completeTrip`, `cancelTrip`, `submitTripRating`,
  `authorizeBookingConversation`, `authorizeTripConversation`, `syncPublicTrip`,
  and Firestore rules.
- Existing judge-path booking, conversation, trip, support, verification, public
  projection, Firestore rules, Storage rules, and indexes remain deployed.
- `planTripWithCopilot` uses managed `OPENAI_API_KEY`; no key is in Flutter, Git,
  docs, logs, or the APK.
- Fictional judge users/fixtures remain provisioned. Credentials stay only in ignored
  `.judge-credentials.local.json` and must be placed privately in Devpost.
- The inherited prototype Function set remains live pending the owner's explicit
  retirement decision. Never use an unscoped Functions deployment or wildcard delete.
- Keep `DEBUG` empty for Firebase CLI commands.

## Passing gates

- Dart format: 116 files, 0 changes.
- Flutter analysis: 0 issues.
- Flutter tests: 20/20, including permanent actionable OSM attribution.
- Functions TypeScript/contracts: 28/28.
- Firestore/Storage rules: 9/9.
- Auth/Firestore/Functions integration: 7/7. This proves proposal/payment,
  inventory, authorization, chat, start, completion, rating, and emergency
  cancellation boundaries.
- Universal debug and per-ABI debug APK builds: PASS.
- Scoped lifecycle/rules deployment: PASS on `fitareeaee`.

## Current APK and device evidence

- Local v1.0.7 profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 85,260,359 bytes
- SHA-256: `CC8191D87DB2DEF700FC1D537807C8E43AC499727C2C0E1B53AB17D3729DAEC6`
- Version: `1.0.7` / code `20260721`
- API 36 emulator: clean cold launch and exact public-APK reinstall PASS; visible
  Login, top-resumed process, process alive, and 0 matching app fatal/Flutter/
  Firebase/ANR logs. Synthetic ADB credential typing is not counted as an
  authenticated pass; v1.0.6 retains the last authenticated emulator evidence.
- Public v1.0.7 release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.7`
- Public v1.0.7 APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.7/app-profile.apk`
- Public re-download path: `build/published-download-v107/app-profile.apk`; exact
  size/hash match and API 36 reinstall/launch PASS. Physical-phone result remains
  PENDING while the phone is disconnected.

- Local profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Public re-download path: `build/published-download-v105/app-profile.apk`
- Type: universal AOT profile APK, debug-signed for contest sideloading
- Size: 83,378,603 bytes
- SHA-256: `0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`
- Version: `1.0.5` / code `20260719`
- Release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.5`
- Direct APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.5/app-profile.apk`
- GitHub metadata, local build, and public re-download size/hash match exactly.
- API 36 emulator: clean public-APK install and explicit launch PASS; 0 app fatal,
  Flutter-error, or app-ANR matches. Pixel Launcher/System UI has unrelated ANRs.
- Motorola Moto G Play (2024): public APK install/update PASS; cold launch PASS in
  2.587s and 1.391s; authenticated Home, Chat empty state, and Request form visibly
  pass; version correct; 0 app fatal, Flutter-error, or app-ANR matches.
- Two accidental captures containing private notification/message content were
  immediately deleted from phone and workspace and are not retained or tracked.

## Remaining owner-only actions

1. Confirm provider-side revocation of the exposed old OpenAI key and legacy Runtime
   Config email/Stripe test credentials. Never paste replacements into chat.
2. Decide whether the exact inherited Function list in `docs/OWNER_ACTIONS.md` must
   be preserved or retired; no deletion is inferred.
3. Record the final 2:40 demo with fictional data, audio narration, no private data,
   and no unauthorized music; upload it publicly to YouTube.
4. Put dedicated judge credentials only in Devpost's private testing field.
5. Run `/feedback` in this primary thread and paste its Session ID into Devpost.
6. Review eligibility, ownership, privacy, links, and legal attestations, then
   personally perform the final Devpost submit action.

## Exact next action

Reconnect the owner's phone, install the exact public v1.0.7 download, run the final
demo-path smoke and app-specific log scan, then promote the prerelease to stable and
replace the final v1.0.5 Devpost fields. Open `docs/DEMO_SCRIPT.md` and follow
`docs/SUBMISSION_CHECKLIST.md`. Preserve v1.0.5 as the rollback release.
