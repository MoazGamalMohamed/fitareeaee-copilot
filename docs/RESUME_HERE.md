# Resume Here

Last updated: 2026-07-20 08:30 CDT / 2026-07-20 06:30 PDT

## Current objective

Install the already-published and anonymously verified v1.0.11 artifact on the
owner's reconnected phone and complete the physical release gate.
Finish the video, `/feedback`, legal review, and owner-performed Devpost submission.
Do not replace the payment gate with simulated money.

## Source and GitHub state

- Private workspace: `C:\Users\moaaz\New Project\project_backup\fitareeaee`
- Private branch: `build-week/final`
- Passing private v1.0.11 application source:
  `b05c91fd2b6856952a028866ec57a83c57ac116e`.
- Private annotated tag `fitareeaee-copilot-v1.0.11` peels to that source.
- Sanitized publication clone:
  `C:\Users\moaaz\New Project\project_backup\fitareeaee-copilot-public`
- Public branch: `agent/payment-gated-chat-trip-support`
- Public v1.0.11 source: `4e1439b098c53c41bf9d95b9f82f3a607b0240bc`.
- Public annotated tag `fitareeaee-copilot-v1.0.11` peels to that source.
- Private/public application trees match across all 349 tracked paths.
- Draft PR #1 is open, draft, and unmerged:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/pull/1`
- PR #1 is current, draft, unmerged, and titled for v1.0.11.
- Public v1.0.11 is the latest published prerelease at sanitized application source
  `4e1439b0`.
- GitHub CLI 2.96.0 is installed and authenticated through the Windows keyring.
- Never add a remote to or push the private original repository. Publish only from
  the sanitized clone after a reachable-history secret scan and tree comparison.

## Current product boundary

- Home provides a circular **Plan with AI** action. Its bottom creation destination
  is **Request** for rider/sender accounts or verification-gated **Offer** for
  driver/courier accounts; there is no duplicate Home request card.
- Manual Request/Offer uses a full editable ride/package form with interactive
  OpenStreetMap origin/destination pins and visible attribution.
- Copilot accepts English/Arabic text, offers Auto/English/Arabic speech recognition
  behind an explicit Android consent prompt, stops by three minutes, reads drafts
  aloud, and hands confirmed drafts into deterministic live matching.
- Profile address, city, and country accept editable suggestions or manual text;
  country selection and an interactive OpenStreetMap pin are available.
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

- Dart format: 128 files, 0 changes.
- Flutter analysis: 0 issues.
- Flutter tests: 40/40.
- Functions TypeScript/contracts: 28/28.
- Firestore/Storage rules: 9/9.
- Auth/Firestore/Functions integration: 7/7.
- Universal debug and optimized profile APK builds: PASS.
- Scoped Firestore-rule deployment to `fitareeaee`: PASS.

## Current APK and emulator evidence

- Local v1.0.11 profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 109,583,813 bytes
- SHA-256: `54E60FE42884A8EFB7FAB8C76DA21F9F43D2C4A2BA55A21C6DA3DACFBCC44EDD`
- Version: `1.0.11` / code `20260725`
- Package/API: `com.fitareeaee.app`, minimum 24, target/compile 36
- API 36 emulator update over the authenticated fictional rider session: PASS.
- v1.0.11 separates account creation paths, adds the circular Home Copilot action,
  explicit three-minute microphone flow, accurate no-speech/permission/busy errors,
  assisted profile locations, and persisted Settings feedback.
- Exact candidate UI passes: circular Home Copilot; rider bottom Request; manual map
  picker; microphone explanation, Android prompt, recognition-service/audio startup,
  and accurate silent-emulator recovery; profile Dallas suggestion; Settings language
  toggle; and Support route. The previously passing paid Chat/Past/rating/payment
  boundary remains covered by the unchanged backend/integration suites.
- Final app-specific fatal/Flutter/FirebaseFailure/ANR scan: 0 matches.
- v1.0.9 additionally fixes owned-trip badges: the active trip now says Confirmed
  and the past trip Completed, while driver chat/start/emergency actions remain.
- Physical v1.0.11 phone result: PENDING because only the emulator is connected.
- Public v1.0.11 release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.11`
- Public v1.0.11 APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.11/app-profile.apk`
- Anonymous re-download: `build/published-download-v111/app-profile.apk`; exact
  109,583,813-byte/hash/byte match. The downloaded copy installed and authenticated
  as the fictional rider; Home semantics, package version, and the app-specific fatal
  scan passed on API 36.
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
8. No further GitHub source/release action is needed unless the phone gate passes;
   then promote the existing prerelease without replacing its APK bytes.

## Exact next action

When the phone returns, install the already-downloaded exact public v1.0.11 bytes
and run Home,
Copilot, verification, both map fields, matches/details/payment-gate, seeded paid
Chat/Past/rating, and driver lifecycle. Promote only if every phone check passes.
