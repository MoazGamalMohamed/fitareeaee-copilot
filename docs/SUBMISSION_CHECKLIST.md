# Submission Checklist

Official deadline: **July 21, 2026 at 5:00 PM Pacific / 7:00 PM Central**. Internal target: **3:00 PM Central**.

Authoritative live pages: [Official Rules](https://openai.devpost.com/rules),
[FAQ](https://openai.devpost.com/details/faqs), and
[Updates](https://openai.devpost.com/updates).

Status key: `[x]` verified, `[ ]` still required. Do not check an item based only on intent.

## Eligibility and evidence

- [x] Track selected: **Apps for Your Life**.
- [x] Product name selected: **Fitareeaee Copilot — trusted, natural-language ride and package matching**.
- [x] Pre-existing application baseline explicitly documented.
- [x] Baseline commit/tag preserved and not claimed as Build Week work.
- [x] Meaningful Build Week extension described separately.
- [x] Append-only progress evidence maintained.
- [ ] Owner confirms personal/team eligibility and accepts the official rules.
- [x] Re-check live official rules, FAQ, resources, and updates on July 19: deadline,
  public YouTube/audio, Codex explanation, GPT-5.6 evidence, repository/test access,
  pre-existing-work disclosure, and `/feedback` requirements remain unchanged.
- [x] Re-check live official rules and FAQ on July 20: July 21 5:00 PM Pacific
  deadline, meaningful-extension evidence, English submission, public YouTube video
  at or under three minutes with voiceover, public/licensed repository, free judge
  access through the August 5 judging period, Codex/GPT-5.6 explanation, and primary
  `/feedback` Session ID remain required.
- [ ] Re-check official rules and Devpost updates on submission day.
- [ ] Run `/feedback` in the primary Codex build thread and paste the Session ID into Devpost.

## Product and backend

- [x] Home exposes **Plan with AI**.
- [x] English/Arabic ride and package requests supported in code.
- [x] Official OpenAI server SDK, Responses API, and `gpt-5.6` configured server-side.
- [x] Strict structured output plus independent server validation.
- [x] Editable, disclosed AI draft; confirmation required before search.
- [x] Deterministic matching with transparent reasons and no fabricated trips.
- [x] Authenticated transactional booking and server-controlled verification.
- [x] Default-deny Firestore/Storage rules and participant-only chat contracts.
- [x] Simulated financial/reset/AI-verification prototypes excluded from the submitted source and judge navigation.
- [ ] Retire the inherited live prototype Functions after owner confirms the exact production deletion set.
- [ ] Owner confirms provider-side revocation of the key exposed in the build conversation. A different valid key is privately installed as managed version 2; obsolete managed version 1 is destroyed.
- [x] Deploy only to confirmed Firebase project `fitareeaee`.
- [x] Deploy hardened booking, verification, chat, and public-projection Functions.
- [x] Deploy Firestore and Storage rules.
- [x] Add required Firestore indexes without deleting legacy indexes; verify both new indexes are `READY`.
- [x] Deploy `planTripWithCopilot` with managed OpenAI secret version 2.
- [x] Run capped live GPT-5.6 tests for English ride, package, and Arabic requests, including a post-retirement rerun.
- [x] Confirm OpenAI test spend remains below USD $5.
- [x] Create dedicated fictional judge accounts and fixed August 10 demo trips; keep passwords out of Git.
- [ ] Verify backend/test access remains free and available through judging.

## Verification gates

- [x] Stage 2 formatting gate passed: 148 files, 0 changes.
- [x] Stage 2 `flutter analyze` passed with no issues.
- [x] Stage 2 Flutter tests passed: 11/11.
- [x] Stage 2 Functions contracts passed: 13/13.
- [x] Stage 2 rules contracts passed: 6/6.
- [x] Stage 2 Functions build passed.
- [x] Stage 2 universal debug APK built and clean-installed on API 36.1 emulator.
- [x] Stage 3/4 formatter passed: 119 files, 0 changes.
- [x] Stage 3/4 `flutter analyze` passed with no issues.
- [x] Stage 3/4 Flutter tests passed: 16/16.
- [x] Stage 3/4 Functions contracts passed: 16/16.
- [x] Stage 3/4 rules contracts passed: 7/7.
- [x] Stage 3/4 real callable emulator integration passed: 3/3.
- [x] Stage 3/4 Functions build and universal debug APK build passed from tagged commit `31deb8c`.
- [x] Same-source x86_64 APK clean-installed and reached Login on API 36.1 with no fatal logs.
- [x] Deployment checkpoint gate passed on `28117b9`: format 119/0, analysis clean, Flutter 16/16, Functions 16/16, rules 7/7, integration 3/3, APK build/install/launch PASS.
- [x] Final prototype-residue cleanup gate passed on `289209b`: format 117/0, analysis clean, Flutter 16/16, Functions 16/16, rules 7/7, APK build/install/launch PASS.
- [x] Consolidated security gate passed on `85d73f0`: format 118/0, analysis clean, Flutter 18/18, Functions 16/16, rules 7/7, callable integration 3/3, scoped deploy/live unauthenticated probes, APK build/install/Login smoke PASS.
- [x] Unreachable-stub cleanup gate passed on `9b591e0`: format 111/0, analysis clean, Flutter 18/18, Functions 16/16, rules 7/7, callable integration 3/3, APK build/install/Login smoke PASS.
- [x] Judge-path hardening gate passed on `15baa23`: format 111/0, analysis clean, Flutter 18/18, Functions 18/18, rules 7/7, callable integration 3/3, universal APK clean-install/Login smoke PASS with version code `20260718`.
- [x] Third-party package/asset/data/music authorization checklist added; final screenshots/video still require owner review.
- [x] Rerun the complete mandatory gate on release-gate checkpoint `ba9c343`: format 111/0, analysis clean, Flutter 18/18, Functions 18/18, rules 7/7, callable integration 3/3, APK build/clean-install/Login smoke PASS.
- [x] Final release gate passed on private `837c11d` / sanitized `8e572ae`: format 111/0, analysis clean, Flutter 18/18, focused Copilot 10/10, Functions 19/19, rules 7/7, callable integration 3/3, APK build and public-download emulator smoke PASS.
- [x] Phone-found notification fix gate passed on private `c5b6736` / sanitized `865a5e8`: format 112/0, analysis clean, Flutter 19/19, Functions 19/19, rules 7/7, callable integration 3/3, APK/public-download emulator and phone smoke PASS.
- [x] July 19 judge-path gate passed locally: format 113/0, analysis clean, Flutter 19/19, Functions 19/19, rules 8/8, compact APK build, emulator clean-install, and exact-candidate Motorola install/cold-launch PASS.
- [ ] Complete two credentialed fresh-install end-to-end runs.
- [x] Install and smoke-test the downloaded public v1.0.1 APK on the owner's Motorola phone, including cold launch and the notification regression.
- [x] Install the superseding Copilot auto-reveal build on the Motorola phone; Home, Copilot/voice guidance, Settings, and Past Trips rendered and no crash output appeared.
- [x] Run a deliberate live GPT request, visibly confirm the structured review and transparent match, continue to details/confirmed chat, and separately verify the transactional booking plus realtime fictional message path on the Motorola phone.
- [x] Record remaining known limitations without minimizing them.

## Repository and release

- [x] Create public sanitized GitHub repository `MoazGamalMohamed/fitareeaee-copilot`.
- [x] Ensure old history containing tracked `.env` is not published; use only the separately sanitized publication clone.
- [x] Add an open-source license and complete judge-ready README.
- [x] Confirm sanitized publication clone contains no API keys, `.env`, service accounts, keystores, passwords, or private data.
- [x] Push passing sanitized `main`, `build-week/final`, and evidence/RC1 tags; no force-push.
- [x] Record draft PR as not applicable because sanitized `main` and `build-week/final` intentionally contain the same passing history.
- [x] No safe private release signing exists; label the universal judge APK clearly as debug-signed.
- [x] Record the latest local APK path, type, size, timestamp, commit, SHA-256, and tested emulator.
- [x] Add a current Google Play readiness audit; the contest APK remains sideload-only and debug-signed.
- [x] Tag the exact local APK source commit as `build-week-stage3-local`.
- [x] Publish APK at a stable GitHub Release/direct URL.
- [x] Download the APK from the public judge URL.
- [x] Confirm downloaded SHA-256 matches the release record.
- [x] Install and smoke-test the downloaded copy on the API 36.1 emulator.
- [x] Confirm remote `main` and `build-week/final` contain sanitized release source `865a5e8` plus final evidence; superseding v1.0.1 tag points exactly to the release source.
- [x] Push sanitized v1.0.2 source `5ad4b94` to `main` and `build-week/final`; tag and publish `fitareeaee-copilot-v1.0.2` without force.
- [x] Download the public v1.0.2 APK, confirm 154,994,394 bytes and exact SHA-256 match, then install/cold-launch that downloaded copy on the Motorola phone.
- [x] Fix the phone-observed Chat-list Firestore query, pass the 8/8 emulator rule contract, deploy only the tested Firestore rules, and verify the authenticated Chat empty state on the Motorola phone.
- [x] Push sanitized v1.0.3 source `c42bc3f` to `main` and `build-week/final`; tag and publish `fitareeaee-copilot-v1.0.3` without force.
- [x] Download the public v1.0.3 APK, confirm 154,995,438 bytes and exact SHA-256 match, install/cold-launch it on the Motorola phone, and recheck Chat plus AndroidRuntime/Flutter error output.
- [x] Anonymous HTTP checks return 200 for the public repository, v1.0.3 release page,
  and redirected direct APK asset.
- [x] Fix remaining chat, pre-payment confirmation, unified GPT-5.6 support, and
  manual request/offer creation defects; pass local, rules, and transactional gates;
  deploy only the scoped backend/rule changes to `fitareeaee` (`a27c2d9`).
- [x] Supersede the v1.0.4 corrective candidate with the fully tested v1.0.5
  source/artifact, redownload it, compare its hash, and install that exact download.
- [x] Publish the sanitized v1.0.4 source branch, draft PR, immutable tag, and
  pre-release APK; redownload and verify the exact 83,181,715-byte SHA-256 match.
- [x] Clean-install the public v1.0.4 download on the emulator and visibly confirm
  Fitareeaee Login/top-resumed/process-alive with zero app-specific fatal log matches.
- [x] Publish v1.0.5 source to draft PR #1, push the annotated source tag, and
  publish the 83,378,603-byte profile APK as the latest stable judge release.
- [x] Redownload v1.0.5 from GitHub and verify SHA-256
  `0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`.
- [x] Install the exact public v1.0.5 APK on the Motorola phone; cold launch,
  authenticated Home, Chat empty state, manual Request form, and crash-log scan pass.
- [x] Build and emulator-test the v1.0.6 lifecycle/map/voice profile candidate;
  verify package/version/API metadata and its expected debug signature.
- [x] Publish sanitized v1.0.6 source/tag/prerelease APK; anonymously redownload,
  hash-match, clean-install, and cold-launch it on API 36.
- [x] Publish the v1.0.7 attribution-compliant source/tag/prerelease APK;
  anonymously redownload and exactly match 85,260,359 bytes and SHA-256
  `CC8191D87DB2DEF700FC1D537807C8E43AC499727C2C0E1B53AB17D3729DAEC6`.
- [x] Reinstall and cold-launch that public v1.0.7 download on API 36; verify
  version `1.0.7` / code `20260721`, top-resumed process, and 0 app-specific
  fatal/Flutter/Firebase/ANR matches.
- [x] Publish v1.0.8 source/tag/prerelease; anonymously redownload and exactly
  match 109,174,213 bytes and SHA-256
  `333174AAFC5CC1BC12060FCB41F3A1372F51F5453C50792650AFF9A9721C2B18`.
- [x] Fresh-install and authenticate that exact public v1.0.8 download on API 36;
  verify Home, paid chat, Past, version `1.0.8` / code `20260722`, and 0
  app-specific fatal/Flutter/Firebase/ANR matches.
- [x] Publish v1.0.9 source/tag/prerelease; anonymously redownload and byte-match
  85,276,819 bytes and SHA-256
  `95B172EE6003D9A35D407033A8E88D272859A6147FA9AD1E30D647B43E0047C1`.
- [x] Install that exact public v1.0.9 download on API 36; verify version
  `1.0.9` / code `20260723`, Confirmed and Completed owned-trip labels, paid
  driver lifecycle controls, confirmed chat, and 0 app-specific
  fatal/Flutter/FirebaseFailure/ANR matches.
- [ ] Install that exact public v1.0.9 download on the owner's reconnected phone,
  run the final demo-path smoke, then promote it from prerelease to stable.

## Devpost materials

- [x] English title, tagline, description, technologies, architecture, Codex/GPT explanation, limitations, and captions drafted.
- [x] Judge testing instructions drafted.
- [x] Privacy and safety notes drafted.
- [x] Test matrix drafted with pending work clearly marked.
- [x] 2:40 demo script drafted.
- [x] Replace APK/repository/tag/hash fields with final verified values; video, Session ID, and private credential placement remain owner-only pending fields.
- [x] Add final branch-specific repository URL so judges reach the unmerged v1.0.9
  source directly; do not rely on the older default `main` branch.
- [x] Add final stable APK URL and SHA-256.
- [x] Preview the repository, release, APK, and English judge copy without relying on
  repository authentication. The still-missing YouTube/Devpost fields remain below.
- [ ] Add judge credentials privately in the allowed Devpost testing field; never in the public repository/video.
- [x] Capture and visually inspect final screenshots from the exact public v1.0.9
  APK using fictional data and no credentials, real identity data, or private
  notifications; add an editable architecture graphic.
- [x] Audit repository packages and fictional fixture data; retain package notices
  and permanent linked OpenStreetMap attribution.
- [ ] Owner confirms authorization for launcher artwork and audits final screenshots
  and video/audio; no copyrighted music, private data, credentials, or real identity
  documents.
- [ ] Record video from final deployed build with audible narration and no copyrighted music.
- [ ] Verify YouTube video is public, under three minutes, and playable while signed out.
- [ ] Add YouTube URL.
- [ ] Add primary Codex `/feedback` Session ID.
- [ ] Preview every link and all English copy while signed out.

## Final manual submission

- [ ] Owner reviews all legal/eligibility statements.
- [ ] Owner performs the final legally binding Devpost submission action.
- [ ] Submit by the internal 3:00 PM Central target.
- [ ] Save a screenshot/PDF/text copy of the final submission page.
- [ ] Record submission time, final commit/tag, APK hash, and video URL in the append-only progress log.

## Current external blockers

Exact owner steps and the inherited Function set are recorded in
[`OWNER_ACTIONS.md`](OWNER_ACTIONS.md).

1. Owner confirms provider-side revocation of the exposed old OpenAI key; managed version 2 is deployed and passing.
2. Owner provides a fresh explicit confirmation before deletion of the exact inherited 36-function set, or elects to preserve it, and urgently rotates the legacy Stripe test/email credentials exposed by Firebase CLI diagnostic output.
3. Exact-public v1.0.9 phone install/smoke, YouTube upload, `/feedback`, private
   credential placement, legal confirmation, and final Devpost submit action.
