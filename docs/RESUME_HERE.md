# Resume Here

Last updated: 2026-07-20 13:13 CDT / 2026-07-20 11:13 PDT

## Current objective

Publish, anonymously redownload, and emulator-test the fully passing v1.0.14
artifact, then install those exact bytes on the owner's reconnected phone to finish
the remaining technical gate. Finish the video, `/feedback`, legal review, and
owner-performed Devpost submission. Do not replace the payment gate with simulated
money.

## Source and GitHub state

- Private workspace: `C:\Users\moaaz\New Project\project_backup\fitareeaee`
- Private branch: `build-week/final`
- Passing private v1.0.14 application source:
  `22d5317f8d900560c9fba6a92d450529aed02bfe` (tree
  `bcfb92a99879d02cd6340b931a0b983ed71906d1`).
- Private v1.0.14 tag and sanitized publication are pending the final history scan;
  v1.0.13 remains the public rollback until that completes.
- Sanitized publication clone:
  `C:\Users\moaaz\New Project\project_backup\fitareeaee-copilot-public`
- Public branch: `agent/payment-gated-chat-trip-support`
- Public v1.0.13 source is
  `ffb5929094b4d48e9991499f65839f75c4479125`; all 351 tracked paths match the
  private application source.
- Draft PR #1 is open, draft, and unmerged:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/pull/1`
- PR #1 is open, draft, unmerged, and updated for v1.0.13 at the public source SHA.
- Public v1.0.13 is the latest prerelease; the branch/tag were pushed without force.
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
- Contact Support uses the deployed GPT-5.6 backend first and supports
  explicit/automatic staff escalation.

## Deployed Firebase state

- Confirmed project: `fitareeaee`.
- Booking, matching, chat, support, verification, lifecycle, rating, and projection
  callables remain deployed. The latest narrow deployment updated only `createTrip`,
  `createBooking`, and `proposeForTripRequest` after their tests passed.
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
- Flutter tests: 47/47.
- Functions TypeScript/contracts: 30/30.
- Firestore/Storage rules: 9/9.
- Auth/Firestore/Functions integration: 9/9.
- Universal debug and optimized profile APK builds: PASS.
- Scoped callable deployment to `fitareeaee`: PASS.

## Current APK and emulator evidence

- Local v1.0.14 profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 109,878,725 bytes
- SHA-256: `487BCBB871C009494CE5FD21F79B41DE46FD28DC8744ACB85AB88C7DFA833C6E`
- Version: `1.0.14` / code `20260728`
- API 36 install/authenticated rider login/sign-out/templates/verification smoke:
  PASS; cleared log had no matching Flutter/Firebase/permission/fatal errors.
- Physical v1.0.14 phone result: PENDING because no physical ADB device is connected.
- The v1.0.13 record below remains the public rollback until v1.0.14 publication is
  independently downloaded, hash-matched, and installed.

- Local v1.0.13 profile path: `build/app/outputs/flutter-apk/app-profile.apk`
- Type: optimized universal AOT profile APK, debug-signed for contest sideloading
- Size: 109,583,813 bytes
- SHA-256: `E51D34C5C5B0B0BDBA4F8180D2CCA149A495D03617F4968D2F50A9A304FA39BB`
- Version: `1.0.13` / code `20260727`
- Package/API: `com.fitareeaee.app`, minimum 24, target/compile 36
- API 36 emulator fresh-account and fictional-rider lifecycle smoke: PASS.
- v1.0.13 requires email, phone, approved ID, and approved selfie before a rider can
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
- Physical v1.0.13 phone result: PENDING because only the emulator is connected.
- Public v1.0.13 release:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.13`
- Public v1.0.13 APK:
  `https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.13/app-profile.apk`
- Anonymous re-download: `build/published-download-v113/app-profile.apk`; exact
  109,583,813-byte/hash/byte match. The downloaded copy installed over the
  authenticated fictional rider and reopened paid-confirmed chat with its real
  fixture message and no matched fatal/chat-permission error on API 36.
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
8. Real payment-provider onboarding remains intentionally outside this contest
   checkpoint. Do not represent the fictional paid fixture as a real charge.

## Exact next action

When ADB sees a non-emulator device, install the already downloaded exact public
v1.0.13 bytes and run Home, Copilot, verification, both map fields,
matches/details/payment gate, seeded paid Chat/Past/rating, and driver lifecycle.
Promote only if every phone check passes.
