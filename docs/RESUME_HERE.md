# Resume Here

Last updated: 2026-07-20 06:08 CDT / 2026-07-20 04:08 PDT

## Current objective

Publish the passing v1.0.10 verification/map/action-audit checkpoint through the
sanitized clone after GitHub authentication is refreshed, anonymously re-download
and verify it, then install that exact artifact on the owner's reconnected phone.
Finish the video, `/feedback`, legal review, and owner-performed Devpost submission.
Do not replace the payment gate with simulated money.

## Source and GitHub state

- Private workspace: `C:\Users\moaaz\New Project\project_backup\fitareeaee`
- Private branch: `build-week/final`
- Passing private application source: `9b92625f20912607d3c7ce32db9902fc76971eae`
- v1.0.10 evidence is appended in `docs/BUILD_WEEK_PROGRESS.md` but still needs its
  own private evidence commit after this resume update.
- Private v1.0.9 local-evidence commit: `d23cafdc83923e00aa16b678d63e893c11464445`
- Sanitized publication clone:
  `C:\Users\moaaz\New Project\project_backup\fitareeaee-copilot-public`
- Public branch: `agent/payment-gated-chat-trip-support`
- Recorded public v1.0.9 artifact/driver-smoke evidence checkpoint:
  `a064e7aa69757a17d8ebf8341ff74c917d18cfcc`. A later mapping-only tail may
  advance the branch; use `git ls-remote` for the current remote head.
- Draft PR #1 is open, draft, and unmerged:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/pull/1`
- PR #1 head is current and mergeable. Its title/body still say v1.0.8 because the
  connected GitHub integration returned HTTP 403 for metadata and comment writes;
  this does not affect the pushed v1.0.9 source, tag, release, or direct APK. Update
  the PR wording manually only if write access is not restored before submission.
- Public v1.0.9 is still the latest published prerelease at sanitized application
  source `ef2eecb7`. Local v1.0.10 has not yet been represented as public.
- GitHub CLI 2.96.0 is installed at the WinGet user link, but `gh auth status`
  reports the stored token is invalid. The owner must run
  `gh auth refresh -h github.com` before the supported CLI publish/release path.
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

- Dart format: 121 files, 0 changes.
- Flutter analysis: 0 issues.
- Flutter tests: 30/30.
- Functions TypeScript/contracts: 28/28.
- Firestore/Storage rules: 9/9.
- Auth/Firestore/Functions integration: 7/7.
- Universal debug and optimized profile APK builds: PASS.
- Scoped Firestore-rule deployment to `fitareeaee`: PASS.

## Current APK and emulator evidence

- Local v1.0.10 profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 85,276,887 bytes
- SHA-256: `F476B31F2097845DAF7159157166F2F940551F6838A9EC75BD493E21F884CE59`
- Version: `1.0.10` / code `20260724`
- Package/API: `com.fitareeaee.app`, minimum 24, target/compile 36
- API 36 emulator update over the authenticated fictional rider session: PASS.
- v1.0.10 fixes null/wrong-type legacy verification parsing, makes both complete
  From/To fields open the map, removes a dead counterparty Verify button, adds safe
  retry states, and hardens admin verification actions against malformed data and
  duplicate submissions.
- v1.0.10 emulator audit passed Verification Center, From map, To map, all Trips
  tabs, paid-confirmed chat, cancellation confirmation without mutation, Settings,
  Support, Payments, Notifications, Copilot examples, and microphone permission.
- Exact candidate UI passes: Home actions; manual map picker; speech permission and
  recognition-service/audio startup; paid chat load/send; Past completed trip;
  completed details without Book Trip; rating entry; Verified identity; and
  `Payment required - not confirmed` with seats unchanged and chat locked.
- Final app-specific fatal/Flutter/FirebaseFailure/ANR scan: 0 matches.
- v1.0.9 additionally fixes owned-trip badges: the active trip now says Confirmed
  and the past trip Completed, while driver chat/start/emergency actions remain.
- Physical v1.0.10 phone result: PENDING because the owner disconnected the phone.
- Public v1.0.9 release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.9`
- Public v1.0.9 APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.9/app-profile.apk`
- Anonymous re-download: `build/published-download-v109/app-profile.apk`; exact
  85,276,819-byte/hash/byte match. The downloaded copy clean-installed and signed
  in as the fictional rider; Home/manual map, voice service, payment lock, paid Chat,
  Past, rating, and final app-specific log scan passed. A separate driver-session
  update passed My Trips and active lifecycle controls on API 36.
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
8. Refresh GitHub CLI authentication, publish v1.0.10 from the sanitized clone, and
   update draft PR #1's stale title/body if write access is restored.

## Exact next action

First refresh GitHub CLI authentication, synchronize/rescan the sanitized clone,
publish v1.0.10 as a prerelease, and verify an anonymous re-download matches the
local hash. When the phone returns, install those exact public bytes and run Home,
Copilot, verification, both map fields, matches/details/payment-gate, seeded paid
Chat/Past/rating, and driver lifecycle. Promote only if every phone check passes.
