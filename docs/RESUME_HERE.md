# Resume Here

Last updated: 2026-07-19 22:56 CDT / 2026-07-19 20:56 PDT

## Current objective

Publish and phone-test the locally passing v1.0.6 lifecycle/map/voice checkpoint,
then finish owner-required credential rotation, video, `/feedback`, legal review,
and Devpost submission. Do not restart the audit or replace the payment gate with
simulated money.

## Source and GitHub state

- Private workspace: `C:\Users\moaaz\New Project\project_backup\fitareeaee`
- Private branch: `build-week/final`
- Passing private source: `47f49ce` (documentation follow-up commit may be newer)
- Sanitized publication clone:
  `C:\Users\moaaz\New Project\project_backup\fitareeaee-copilot-public`
- Public branch: `agent/payment-gated-chat-trip-support`
- Passing sanitized source: `6d67f306203886d3d1623f9966f36764589b9cfb`
- Private/public tree: `eb32120d74af47cc0e604729055b4e67d92f2aa9`
- Draft PR #1 is open and unmerged:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/pull/1`
- Annotated tag `fitareeaee-copilot-v1.0.5` exists locally/remotely and peels to
  `6d67f306`. No force push was used.
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

- Dart format: 115 files, 0 changes.
- Flutter analysis: 0 issues.
- Flutter tests: 19/19.
- Functions TypeScript/contracts: 28/28.
- Firestore/Storage rules: 9/9.
- Auth/Firestore/Functions integration: 7/7. This proves proposal/payment,
  inventory, authorization, chat, start, completion, rating, and emergency
  cancellation boundaries.
- Universal debug and per-ABI debug APK builds: PASS.
- Scoped lifecycle/rules deployment: PASS on `fitareeaee`.

## Current APK and device evidence

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

Install/authenticate GitHub CLI so `github:yeet` can publish the sanitized v1.0.6
checkpoint. Download/hash-test the published artifact, install it on the connected
phone, run the final demo-path smoke, then open `docs/DEMO_SCRIPT.md` and follow
`docs/SUBMISSION_CHECKLIST.md`. Preserve v1.0.5 as the rollback release.
