# Resume Here

Last updated: 2026-07-21 02:23 CDT / 2026-07-21 00:23 PDT

## Current objective

Preserve the fully passing, published, and phone-tested v1.0.16 candidate. The only
submission-critical work left is owner-performed video recording/upload, `/feedback`,
private judge-credential placement, legal review, and final Devpost submission. Do
not replace the payment gate with simulated money or mutate the seeded demo lifecycle.

## Source and GitHub state

- Private workspace: `C:\Users\moaaz\New Project\project_backup\fitareeaee`
- Private branch: `build-week/final`
- Passing private v1.0.16 application source:
  `8a1321377fab99676d6d02294c054b1dd9ad692b` (tree
  `4eae30a3d3f7d98173b55e6d4798023265144932`).
- Private/public annotated v1.0.16 tags peel to tree-identical application source;
  the sanitized source is `a827e555f789f0913eb93c0ac34160f6b85d9218`. Use the
  tracked remote branch head for later documentation-only checkpoints; never retag
  the application source to a docs commit.
- Sanitized publication clone:
  `C:\Users\moaaz\New Project\project_backup\fitareeaee-copilot-public`
- Public branch: `agent/payment-gated-chat-trip-support`
- Public v1.0.16 source is
  `a827e555f789f0913eb93c0ac34160f6b85d9218`; its tree exactly matches the
  private v1.0.16 application source.
- Draft PR #1 is open, draft, and unmerged:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/pull/1`
- PR #1 is open, draft, unmerged, cleanly mergeable, and updated for v1.0.16.
- Public v1.0.16 is the latest prerelease; the branch/tag were pushed without force.
- GitHub CLI 2.96.0 is installed and authenticated through the Windows keyring.
- Never add a remote to or push the private original repository. Publish only from
  the sanitized clone after a reachable-history secret scan and tree comparison.

## Current product boundary

- Copilot now includes bounded editable **Saved trip plans** stored locally per
  signed-in UID. Templates contain only a name and request text; they never contain
  payment, booking, verification, identity, contact, or chat data.
- Verification progress distinguishes requirements submitted from requirements
  approved. Account switching uses one stable auth-aware router and screen-scoped
  data providers; the v1.0.14 rider login/sign-out cleared-log regression passes.

- Home provides a circular **Plan with AI** action. Its bottom creation destination
  is **Request** for rider/sender accounts or verification-gated **Offer** for
  driver/courier accounts; there is no duplicate Home request card.
- Home now explicitly labels the signed-in path: riders/senders request and pay;
  drivers/couriers offer and receive payment after driver/vehicle verification.
- Manual Request/Offer uses a full editable ride/package form with interactive
  OpenStreetMap origin/destination pins and visible attribution.
- Re-picking a generated map point refreshes its coordinate label while preserving
  semantic Copilot or manually entered place names.
- Owners can withdraw a still-open unpaid request/offer through a transactional
  callable. Paid/confirmed trips are rejected into cancellation/admin review; the
  withdrawn trip remains as Cancelled history and leaves Available Trips.
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
- Contact Support uses the deployed GPT-5.6 backend first and supports
  explicit/automatic staff escalation.

## Deployed Firebase state

- Confirmed project: `fitareeaee`.
- Booking, matching, chat, support, verification, lifecycle, rating, and projection
  callables remain deployed. The latest narrow deployment updated only `createTrip`,
  `createBooking`, and `proposeForTripRequest` after their tests passed; the final
  scoped deployment added only `withdrawTrip` after 10/10 lifecycle integration.
- Live `planTripWithCopilot` is deployed. Metadata-only verification shows managed
  `OPENAI_API_KEY` version 2 enabled and version 1 destroyed. Exact-public v1.0.13
  returned strict English ride, English package, and Arabic ride review drafts; no
  key is in Flutter, Git, docs, logs, or the APK and no key value was read.
- Firestore ruleset `fd6ed8ec-2250-46d8-ac9a-34eed9736f3f` was deployed July 20
  after 9/9 emulator contracts. It permits a participant to check their deterministic
  one-rating document before creation while keeping all rating writes server-only.
- Six explicit fictional judge trips plus active/completed lifecycle fixtures are
  provisioned. Credentials remain only in ignored `.judge-credentials.local.json`
  and must be placed privately in Devpost.
- The inherited prototype Function set remains live pending an explicit owner
  retirement decision. Never use an unscoped Functions deployment or wildcard delete.

## Passing gates

- Dart format: 132 files, 0 changes.
- Flutter analysis: 0 issues.
- Flutter tests: 49/49.
- Functions TypeScript/contracts: 31/31.
- Firestore/Storage rules: 9/9.
- Auth/Firestore/Functions integration: 10/10.
- Universal debug and optimized profile APK builds: PASS.
- Scoped callable deployment to `fitareeaee`: PASS.

## Current APK and emulator evidence

- Local v1.0.16 profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 85,703,283 bytes
- SHA-256: `FBDB24024908450DD8DF2686099A5F6A44A147B66E03B9B5CCDD51C25712415B`
- Version: `1.0.16` / code `20260730`
- Physical phone result: PASS on Moto G Play (2024). Exact public bytes installed,
  cold-launched in 2.794 seconds, retained the fictional driver session, and rendered
  Driver Home, Create an offer, bottom Offer, the complete verified-driver form,
  paid-confirmed conversation, completed-only Past, and rating availability. The
  byte-identical local artifact exercised both interactive map pins, distinct
  refreshed labels, and live owner withdrawal/marketplace removal. Cleared log scans
  found zero matching app errors.

- Current public v1.0.16 profile path: `build/published-download-v116/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 85,703,283 bytes
- SHA-256: `FBDB24024908450DD8DF2686099A5F6A44A147B66E03B9B5CCDD51C25712415B`
- Version: `1.0.16` / code `20260730`
- Package/API: `com.fitareeaee.app`, minimum 24, target/compile 36
- API 36 emulator fresh-account and fictional-rider lifecycle smoke: PASS.
- v1.0.16 requires email, phone, approved ID, and approved selfie before a rider can
  publish; drivers additionally need approved driver licence and vehicle. Verification
  shows four rider checks or six driver checks with real role-specific progress.
- Exact candidate UI passes: circular Home Copilot; rider bottom Request; manual map
  picker; microphone explanation and Android prompt; phone and ID verification entry;
  Settings/Support; potential unpaid match disclosure; paid-confirmed details and real
  participant chat; Payments; completed Past trip; and one-time rating form.
- Final app-specific fatal/Flutter/FirebaseFailure/ANR scan: 0 matches.
- v1.0.9 additionally fixes owned-trip badges: the active trip now says Confirmed
  and the past trip Completed, while driver chat/start/emergency actions remain.
- Confirmed chat log scan: no visible error, `FirebaseFailure`, `typing_status`,
  `PERMISSION_DENIED`, fatal exception, or `E/flutter` match.
- Public v1.0.16 release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.16`
- Public v1.0.16 APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.16/app-profile.apk`
- Anonymous re-download: `build/published-download-v116/app-profile.apk`; exact
  85,703,283-byte/hash/byte match and physical-phone update install/cold launch PASS.

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
7. Real payment-provider onboarding remains intentionally outside this contest
   checkpoint. Do not represent the fictional paid fixture as a real charge.

## Exact next action

Use the installed v1.0.16 driver account for the Offer/map segment and the private
fictional rider account for the GPT-5.6/matches/details/payment-boundary segment.
Preserve the seeded paid-confirmed and completed fixtures for Chat/Past/rating. Record
the 2:40 video, upload it publicly, run `/feedback`, add the private credentials and
Session ID, review every public link/legal attestation, and personally submit Devpost.
