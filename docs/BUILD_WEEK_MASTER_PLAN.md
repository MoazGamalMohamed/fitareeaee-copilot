# Fitareeaee OpenAI Build Week Master Plan

Last updated: 2026-07-17 (America/Chicago)

## Contest source of truth

This plan is based on the official rules and submission pages reviewed on July 17, 2026:

- https://openai.devpost.com/rules
- https://openai.devpost.com/
- https://openai.devpost.com/details/faqs
- https://openai.devpost.com/updates/45282-openai-build-week-submissions-are-open-plugin-launch

Deadline: July 21, 2026 at 5:00 PM Pacific / 7:00 PM Central. Target internal submission deadline: July 21 at 3:00 PM Central, leaving a four-hour safety buffer.

The official rules and current Devpost notices always override this plan.

## Eligibility and submission constraints

- Enter one track. Fitareeaee should enter **Apps for Your Life**.
- The project must be built with Codex and GPT-5.6 and must run consistently as demonstrated.
- Fitareeaee existed before the July 13 submission window. Judges evaluate only meaningful work added during the window.
- Clearly distinguish the pre-existing baseline from Build Week work using a baseline document, timestamped Codex session evidence, and dated Git commits.
- Submit an English description, a public YouTube demo under three minutes with audio, a repository URL, testing access/build, and the `/feedback` Codex Session ID for the main build thread.
- The video must explain both what was built and how Codex and GPT-5.6 were used.
- A public repository needs an appropriate license. A private repository must be shared with `testing@devpost.com` and `build-week-event@openai.com`.
- The working project/test build must remain free and available through the end of judging.
- Do not change the submission after the deadline except if Devpost/OpenAI explicitly permits a narrow correction.
- All third-party APIs, assets, music, marks, and data must be authorized. Use no copyrighted music in the demo.

## Product decision

### Submission name

**Fitareeaee Copilot — trusted, natural-language ride and package matching**

### Track

**Apps for Your Life**

### One-sentence pitch

Fitareeaee Copilot turns an everyday English or Arabic travel/delivery request into a structured, reviewable trip plan, transparently ranks compatible community trips, and carries the user through verification, booking, and chat.

### Meaningful Build Week extension

The new extension must be visually and technically separable from the older marketplace:

1. A prominent **Plan with AI** entry point from Home.
2. A GPT-5.6-powered natural-language planner supporting ride and package intents in English and Arabic.
3. A strict structured result: intent, origin, destination, departure, seats/package details, budget, preferences, summary, and any clarification needed.
4. A review/edit step before any data is saved.
5. Deterministic local matching against Firestore trips, with transparent match reasons. GPT interprets intent; deterministic code controls filtering and ranking.
6. A coherent continuation into the existing trip details, verification, booking, and chat flow.
7. Server-side OpenAI calls through Firebase Functions. The OpenAI key must never be included in Flutter source, Git, or the APK.

### Safety/product boundaries

- GPT-5.6 must not approve identity documents, declare a person safe, make emergency decisions, or guarantee a match.
- Verification remains a manual/admin decision with deterministic status badges.
- AI output is a draft and must be reviewed by the user.
- Show concise uncertainty/error states and never silently fabricate live trips.
- Do not send document images, phone numbers, emails, user IDs, or chat contents to OpenAI for the contest feature.

## Scope control

### Must ship

- Working Android Firebase startup and authentication.
- Home -> Copilot -> results -> trip details -> booking -> chat vertical slice.
- Manual verification status visible where required.
- Secure GPT-5.6 backend integration.
- Firestore/Storage rules that match the shipped collections.
- Transactional or server-authoritative booking to prevent overselling.
- Judge testing instructions, test account or seeded demo data, installable APK, README, progress evidence, demo script, and Devpost draft.

### Ship only if stable

- Admin verification review.
- Notifications.
- Map preview/location autocomplete.
- Arabic UI copy beyond the multilingual Copilot input.

### Hide or explicitly label as prototype for the submission build

- Simulated payments, escrow, wallet, and payouts.
- AI identity verification.
- Tracking links without a deployed viewer.
- Incomplete ratings, support ticket routes, package-photo workflow, and unrelated dead screens.

No real payment integration or Play Store release is required for this deadline. A sideloadable judge APK is sufficient.

## Technical architecture

1. Flutter sends a short authenticated request to a Firebase callable function.
2. Firebase Functions reads `OPENAI_API_KEY` from managed server secrets/environment.
3. The function calls the OpenAI Responses API with a GPT-5.6 model and a strict structured schema.
4. The function validates and normalizes the model result before returning it.
5. Flutter presents the draft for confirmation/editing.
6. Existing deterministic search code ranks Firestore trips and explains exact rule-based reasons.
7. Booking occurs through a Firestore transaction/callable function that validates authentication, availability, ownership, and verification requirements.

Required backend protections: authentication, input length limits, allowed-value validation, output schema validation, short timeouts, safe errors, basic per-user throttling, and no secret or raw model-response logging.

## Four-day execution plan

### Stage 0 — Evidence, repository, and baseline (July 17 night)

- Join/register on Devpost and create a draft submission immediately.
- Confirm personal/team eligibility and Apps for Your Life track.
- Record current source as an explicitly pre-existing baseline; do not claim December work as Build Week work.
- Create `build-week/final` from the preserved baseline.
- Configure the exact GitHub destination. If publishing, sanitize secrets first and add a license.
- Rotate credentials found in tracked `.env` history before making a repository public.
- Record the existing analysis/test/Functions/APK baseline in `BUILD_WEEK_PROGRESS.md`.
- Restore one coherent Firebase configuration path and confirm login on Android.

Gate: `flutter analyze`, `flutter test`, `npm run build`, `flutter build apk --debug`, and one launch/login smoke test.

### Stage 1 — Stable judge vertical slice (July 18 morning)

- Fix registered routes needed by the demo and remove/hide broken quick links.
- Normalize timestamps and canonical schemas for users, trips, bookings, messages, and verifications.
- Replace direct client booking mutation with a transaction/server-authoritative flow.
- Add minimal secure Firestore and Storage rules for only shipped flows.
- Make verification/admin access enforceable by backend rules, not only UI checks.
- Disable dangerous reset/payment callables from the judge build unless properly authorized.

Gate: clean happy path on Android plus negative tests for unauthenticated booking/admin access; create a debug APK checkpoint.

The final mandatory gate also includes Functions contracts, Firestore/Storage
rules emulator tests, and the real Auth/Functions/Firestore booking integration
suite documented in `README.md` and `TEST_MATRIX.md`.

### Stage 2 — GPT-5.6 Fitareeaee Copilot (July 18 afternoon through July 19 morning)

- Add the official OpenAI server SDK to Functions.
- Implement the authenticated structured trip-planning callable using the Responses API and GPT-5.6.
- Add planner DTO/schema, validation, timeouts, and user-friendly errors.
- Build the Copilot screen with example prompts and English/Arabic input.
- Add review/edit confirmation and connect it to deterministic trip matching.
- Display transparent match reasons and preserve user control.
- Add unit tests for parser/schema validation, ranking, empty states, and malformed responses.

Gate: at least three recorded prompts (ride, package, Arabic), deterministic results tests, Functions build, Flutter tests/analyze, Android launch, APK checkpoint.

### Stage 3 — Product coherence and judge mode (July 19)

- Polish only the demonstrated screens and fix overflow/loading/error states.
- Add seeded judge data or a test account with clearly documented credentials.
- Ensure the app remains usable if a live AI call fails: show retry and manual search, not fake output.
- Verify manual verification badges and booking/chat continuation.
- Add privacy/safety notice and concise limitations.
- Remove debug logs and placeholder/coming-soon actions from the demo path.

Gate: fresh-install end-to-end script succeeds twice; APK installs on the user's phone; checkpoint pushed to GitHub.

### Stage 4 — Freeze, release candidate, and submission assets (July 20)

- Freeze features by July 20 at noon Central.
- Run the complete test matrix on a clean build.
- Build a signed release APK if signing is ready; otherwise provide a clearly labeled installable debug/judge APK.
- Generate SHA-256 and publish the APK as a GitHub Release or stable direct download.
- Complete README, Build Week before/after section, architecture, setup, testing instructions, Codex/GPT-5.6 collaboration section, license, screenshots, and limitations.
- Write and rehearse the under-three-minute demo; record backup takes.
- Complete the Devpost draft except for final video/session links.

Gate: release-candidate tag, remote commit confirmed, APK downloaded and installed from the same URL judges will use.

### Stage 5 — Submission day (July 21)

- Only severity-1 fixes; no new features.
- Re-run smoke tests and verify backend quotas/secrets/test credentials.
- Record the final video with audio, no copyrighted music, and no exposed credentials/PII.
- Upload publicly to YouTube and verify playback while signed out.
- Run `/feedback` in the primary Codex build thread and record its session ID.
- Verify repository visibility/sharing, license, README, APK link, testing instructions, English description, category, and all links.
- Submit by **3:00 PM Central**, four hours before the official deadline.
- Save screenshots/PDF/text of the final submitted page and final commit/tag.

## Verification gate after every stage

Run and record:

```text
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
cd functions && npm run build
flutter build apk --debug
```

Also perform the stage-specific Android smoke path. A stage is not complete until failures are fixed or explicitly documented as out of scope. Never push a knowingly broken checkpoint as the latest judge build.

## APK policy

- Debug checkpoint: `build/app/outputs/flutter-apk/app-debug.apk`.
- Release candidate: `build/app/outputs/flutter-apk/app-release.apk` when signing/configuration is ready.
- Record file size, SHA-256, build time, commit SHA, and tested device in `BUILD_WEEK_PROGRESS.md`.
- Keep the final APK URL stable through the judging period.
- Test installation from the published URL, not only from the local build folder.

## Progress and Git protocol

`BUILD_WEEK_PROGRESS.md` is append-only. Every checkpoint records:

- Central and Pacific timestamp.
- Goal and completed work.
- Files changed.
- Commands and exact pass/fail counts.
- APK path/hash and device result.
- Commit SHA/tag/remote status.
- Known issues, rollback point, and next action.

Commit by coherent stage with messages such as:

- `chore(build-week): snapshot pre-existing baseline (not submission work)`
- `fix(core): stabilize Android Firebase vertical slice`
- `feat(copilot): add GPT-5.6 structured trip planning`
- `fix(security): enforce booking and verification authorization`
- `docs(submission): add judge guide and Codex evidence`
- `release: Fitareeaee Copilot Build Week RC1`

Push after each passing gate. Tag stable APK checkpoints. Never commit `.env`, service secrets, test-user passwords, keystores, or private keys.

## Demo outline (maximum 2:45 target)

1. 0:00-0:15 — The real problem: ride/package apps require rigid forms and trust is hard to assess.
2. 0:15-0:35 — Fitareeaee Copilot and what was newly built during Build Week.
3. 0:35-1:20 — Enter a natural-language English or Arabic request; GPT-5.6 returns a structured plan; user reviews it.
4. 1:20-1:55 — Transparent ranked matches, verification context, booking, and chat continuation.
5. 1:55-2:20 — Architecture: Flutter -> secured Firebase Function -> OpenAI Responses API/GPT-5.6 -> validated schema; deterministic ranking.
6. 2:20-2:40 — How Codex accelerated implementation, testing, security review, and Android delivery.
7. 2:40-2:45 — Impact statement and closing.

## Final definition of done

- Eligibility and new-work evidence are unambiguous.
- One coherent Android vertical slice works from a fresh install.
- GPT-5.6 is used in the actual running product through a secure backend.
- The demo does not depend on broken payment/wallet/dead routes.
- All required tests/builds pass and results are recorded.
- A judge can install the APK or use the provided test build without paying.
- GitHub contains the final source, license, README, instructions, evidence, and matching tag.
- The public video is under three minutes and covers Codex and GPT-5.6.
- Devpost contains the category, description, repo, test build, instructions, and `/feedback` session ID before the internal deadline.
