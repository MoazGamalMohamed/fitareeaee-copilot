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
- [x] Simulated financial/reset/AI-verification prototypes excluded from the judge path/deployable Functions.
- [ ] Owner sets `OPENAI_API_KEY` as a managed Firebase secret without sharing or committing it.
- [ ] Deploy only to confirmed Firebase project `fitareeaee`.
- [ ] Deploy Functions, Firestore rules/indexes, and Storage rules.
- [ ] Run capped live GPT-5.6 tests for English ride, package, and Arabic requests.
- [ ] Confirm OpenAI test spend remains below USD $5.
- [ ] Create dedicated judge accounts and seeded demo trips; keep passwords out of Git.
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
- [x] Third-party package/asset/data/music authorization checklist added; final screenshots/video still require owner review.
- [ ] Rerun the complete mandatory gate on the exact final release commit.
- [ ] Complete two credentialed fresh-install end-to-end runs.
- [ ] Install and smoke-test on the owner's physical Android phone.
- [ ] Record any remaining known limitation without minimizing it.

## Repository and release

- [ ] Create/configure sanitized GitHub repository `fitareeaee-copilot`.
- [ ] Ensure old history containing tracked `.env` is not published.
- [x] Add an open-source license and complete judge-ready README.
- [ ] Confirm repository contains no API keys, `.env`, service accounts, keystores, passwords, or private data.
- [ ] Push passing stage commits/tags; no force-push.
- [ ] Open/update draft PR if appropriate; do not merge without owner confirmation.
- [ ] Build signed universal release APK if safe signing exists; otherwise label the judge debug APK clearly.
- [x] Record the latest local APK path, type, size, timestamp, commit, SHA-256, and tested emulator.
- [x] Tag the exact local APK source commit as `build-week-stage3-local`.
- [ ] Publish APK at a stable GitHub Release/direct URL.
- [ ] Download the APK from the public judge URL.
- [ ] Confirm downloaded SHA-256 matches the release record.
- [ ] Install and smoke-test the downloaded copy.
- [ ] Confirm local and remote commits/tags match.

## Devpost materials

- [x] English title, tagline, description, technologies, architecture, Codex/GPT explanation, limitations, and captions drafted.
- [x] Judge testing instructions drafted.
- [x] Privacy and safety notes drafted.
- [x] Test matrix drafted with pending work clearly marked.
- [x] 2:40 demo script drafted.
- [ ] Replace all pending links/build metadata with final verified values.
- [ ] Add final repository URL.
- [ ] Add final stable APK URL and SHA-256.
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

1. Managed OpenAI key setup and live Firebase deployment.
2. Dedicated test credentials and seeded/live judge data.
3. Sanitized GitHub remote/publication tooling.
4. Physical Android phone interaction.
5. YouTube upload, `/feedback`, legal confirmation, and final Devpost submit action.
