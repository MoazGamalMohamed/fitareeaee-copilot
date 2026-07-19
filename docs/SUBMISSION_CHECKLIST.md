# Submission Checklist

Official deadline: **July 21, 2026 at 5:00 PM Pacific / 7:00 PM Central**. Internal target: **3:00 PM Central**.

Status key: `[x]` verified, `[ ]` still required. Do not check an item based only on intent.

## Eligibility and evidence

- [x] Track selected: **Apps for Your Life**.
- [x] Product name selected: **Fitareeaee Copilot — trusted, natural-language ride and package matching**.
- [x] Pre-existing application baseline explicitly documented.
- [x] Baseline commit/tag preserved and not claimed as Build Week work.
- [x] Meaningful Build Week extension described separately.
- [x] Append-only progress evidence maintained.
- [ ] Owner confirms personal/team eligibility and accepts the official rules.
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
- [ ] Complete two credentialed fresh-install end-to-end runs.
- [ ] Install and smoke-test on the owner's physical Android phone; current attempt is blocked by the differently signed older package and requires approval to delete its local app data.
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
- [x] Tag the exact local APK source commit as `build-week-stage3-local`.
- [x] Publish APK at a stable GitHub Release/direct URL.
- [x] Download the APK from the public judge URL.
- [x] Confirm downloaded SHA-256 matches the release record.
- [x] Install and smoke-test the downloaded copy on the API 36.1 emulator.
- [x] Confirm remote `main` and `build-week/final` exactly match sanitized `8e572ae`; final tag points to that commit.

## Devpost materials

- [x] English title, tagline, description, technologies, architecture, Codex/GPT explanation, limitations, and captions drafted.
- [x] Judge testing instructions drafted.
- [x] Privacy and safety notes drafted.
- [x] Test matrix drafted with pending work clearly marked.
- [x] 2:40 demo script drafted.
- [x] Replace APK/repository/tag/hash fields with final verified values; video, Session ID, and private credential placement remain owner-only pending fields.
- [x] Add final repository URL.
- [x] Add final stable APK URL and SHA-256.
- [ ] Add judge credentials privately in the allowed Devpost testing field; never in the public repository/video.
- [ ] Capture final screenshots with fictional data and no PII.
- [ ] Audit final screenshots, icons/assets, packages, fixture data, and video/audio for ownership or authorized licenses; retain attribution where required.
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
3. Physical Android phone interaction, YouTube upload, `/feedback`, legal confirmation, and final Devpost submit action.
