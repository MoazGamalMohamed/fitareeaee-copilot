# Resume Here

Last updated: 2026-07-20 02:54 CDT / 2026-07-20 00:54 PDT

## Current objective

Publish the passing v1.0.8 candidate through the sanitized GitHub clone, verify the
anonymous public download on the emulator, then install and smoke that exact public
APK on the owner's reconnected phone. Finish the video, `/feedback`, legal review,
and owner-performed Devpost submission. Do not replace the payment gate with
simulated money.

## Source and GitHub state

- Private workspace: `C:\Users\moaaz\New Project\project_backup\fitareeaee`
- Private branch: `build-week/final`
- Passing private application source: `3817ed587bc141856c7c20eed126aa8c5508091e`
- Sanitized publication clone:
  `C:\Users\moaaz\New Project\project_backup\fitareeaee-copilot-public`
- Public branch: `agent/payment-gated-chat-trip-support`
- Current public v1.0.7 branch before the pending replay: `2929cb6a`.
- Draft PR #1 is open, draft, and unmerged:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/pull/1`
- Public v1.0.7 remains the current prerelease. v1.0.8 has not yet been tagged or
  uploaded at this checkpoint.
- Never add a remote to or push the private original repository. Publish only from
  the sanitized clone after a reachable-history secret scan and tree comparison.

## Current product boundary

- Home provides **Plan with AI**, **Request a Trip**, and verification-gated
  **Offer a Ride**.
- Manual Request/Offer uses a full editable ride/package form with interactive
  OpenStreetMap origin/destination pins and visible attribution.
- Copilot accepts English/Arabic text, offers Auto/English/Arabic speech recognition,
  reads drafts aloud, and hands confirmed drafts into deterministic live matching.
- Rider/sender is always the paying side; driver/courier is always the receiving
  side. Proposal selection or booking creates only `pending_payment` / `required`.
- Seats and private user chat stay locked until the server sees both `confirmed` and
  `paid`. There is no real payment provider in the contest build.
- A clearly labeled fictional paid/confirmed fixture demonstrates active private
  chat. A completed fixture demonstrates Past, closed chat, and one immutable rating.
- Contact Support uses GPT-5.6 first and supports explicit/automatic staff escalation.

## Deployed Firebase state

- Confirmed project: `fitareeaee`.
- All submitted booking, matching, chat, support, verification, lifecycle, rating,
  projection, and Copilot callables remain deployed.
- `planTripWithCopilot` uses managed `OPENAI_API_KEY` version 2; obsolete version 1
  is destroyed. No key is in Flutter, Git, docs, logs, or the APK.
- Firestore ruleset `fd6ed8ec-2250-46d8-ac9a-34eed9736f3f` was deployed July 20
  after 9/9 emulator contracts. It permits a participant to check their deterministic
  one-rating document before creation while keeping all rating writes server-only.
- Six explicit fictional judge trips plus active/completed lifecycle fixtures are
  provisioned. Credentials remain only in ignored `.judge-credentials.local.json`
  and must be placed privately in Devpost.
- The inherited prototype Function set remains live pending an explicit owner
  retirement decision. Never use an unscoped Functions deployment or wildcard delete.

## Passing gates

- Dart format: 118 files, 0 changes.
- Flutter analysis: 0 issues.
- Flutter tests: 23/23.
- Functions TypeScript/contracts: 28/28.
- Firestore/Storage rules: 9/9.
- Auth/Firestore/Functions integration: 7/7.
- Universal debug and optimized profile APK builds: PASS.
- Scoped Firestore-rule deployment to `fitareeaee`: PASS.

## Current APK and emulator evidence

- Local v1.0.8 profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 109,174,213 bytes
- SHA-256: `333174AAFC5CC1BC12060FCB41F3A1372F51F5453C50792650AFF9A9721C2B18`
- Version: `1.0.8` / code `20260722`
- Package/API: `com.fitareeaee.app`, minimum 24, target/compile 36
- API 36 emulator fresh install and fictional sign-in: PASS.
- Exact candidate UI passes: Home actions; manual map picker; speech permission and
  recognition-service/audio startup; paid chat load/send; Past completed trip;
  completed details without Book Trip; rating entry; Verified identity; and
  `Payment required - not confirmed` with seats unchanged and chat locked.
- Final app-specific fatal/Flutter/FirebaseFailure/ANR scan: 0 matches.
- Physical v1.0.8 phone result: PENDING because the owner disconnected the phone.
- Current public fallback:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.7`
- Phone-tested rollback remains public v1.0.5.

## Remaining owner-only actions

1. Reconnect/unlock the phone and approve USB debugging if Android asks.
2. Confirm provider-side revocation of the exposed old OpenAI key and legacy Runtime
   Config email/Stripe test credentials. Never paste replacements into chat.
3. Decide whether the exact inherited Function list in `docs/OWNER_ACTIONS.md` must
   be preserved or retired; no deletion is inferred.
4. Record the final 2:40 demo with fictional data, audio narration, no private data,
   and no unauthorized music; upload it publicly to YouTube.
5. Put dedicated judge credentials only in Devpost's private testing field.
6. Run `/feedback` in this primary thread and paste its Session ID into Devpost.
7. Review eligibility, ownership, privacy, links, and legal attestations, then
   personally perform the final Devpost submit action.

## Exact next action

Replay `3817ed5` plus this documentation checkpoint into the sanitized clone, scan
all reachable history, verify private/public tree equality, push without force,
create `fitareeaee-copilot-v1.0.8`, upload the exact APK, anonymously re-download it,
compare SHA-256, and fresh-install that public copy on the emulator. When the phone
returns, install the same downloaded bytes and run the final demo-path/log smoke.
