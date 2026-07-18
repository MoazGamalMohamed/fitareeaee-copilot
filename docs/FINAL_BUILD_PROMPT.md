# Dedicated Final Build Prompt

Before sending this prompt, replace `<GITHUB_OWNER/REPO>` with the exact GitHub repository. If it does not exist yet, say `CREATE A NEW PUBLIC REPOSITORY NAMED fitareeaee-copilot` instead.

---

You are Codex working in the existing Fitareeaee Flutter/Firebase repository. Create a persistent goal for this objective and continue until the final submission build is genuinely complete or you encounter a blocker that requires a credential, an unavailable external service, a legal/eligibility decision, or an exact GitHub/Firebase target that cannot be safely inferred.

Use the `openai-docs` skill for current OpenAI API/model guidance. Use `$github:yeet` when publishing passing checkpoints. You may use sub-agents for bounded independent audits or tests when useful, but the primary agent must integrate and verify all work.

## Objective

Finish and production-harden **Fitareeaee Copilot** as an Android submission for OpenAI Build Week before July 21, 2026 at 5:00 PM Pacific. Enter **Apps for Your Life**. The final product must be a coherent Flutter Android app that uses Codex and GPT-5.6, runs as demonstrated, can be installed by judges, has a stable APK, is documented for Devpost, and clearly distinguishes pre-existing work from meaningful Build Week work.

Read these files first and treat them as the continuity source of truth:

- `docs/BUILD_WEEK_MASTER_PLAN.md`
- `docs/BUILD_WEEK_PROGRESS.md`
- `docs/FINAL_BUILD_PROMPT.md`
- the official rules at `https://openai.devpost.com/rules`
- the current repository status and diff

Re-check the live official rules before implementation because they can be amended. Do not rely only on summaries.

## Product to ship

Build the meaningful new extension called **Fitareeaee Copilot**:

1. Add a prominent `Plan with AI` path from Home.
2. Accept a natural-language ride or package request in English or Arabic.
3. Send the minimal authenticated request to a secured Firebase callable backend.
4. Call the official OpenAI Responses API with GPT-5.6 and strict structured output.
5. Return and validate a reviewable trip draft containing intent, origin, destination, departure date/time, seats or package details, maximum budget, preferences, a concise summary, and a clarification question when information is missing.
6. Never save or act on AI output until the user reviews/confirms it.
7. Feed the confirmed draft into deterministic trip filtering/ranking. Show exact, transparent match reasons based on route, availability, time, price, and preferences.
8. Continue through trip details, verification context, server-authoritative booking, and chat.
9. Do not use GPT to approve identity, declare users safe, make emergency decisions, or guarantee matches.
10. Never send identity images, email, phone, user IDs, or chat contents to OpenAI for this feature.

Use the official OpenAI server SDK in Firebase Functions, not OpenRouter. Keep `OPENAI_API_KEY` in managed Firebase/server secrets only. Never put it in Dart, `.env` committed to Git, Android resources, logs, tests, or the APK. Use the current official GPT-5.6 model/API guidance from OpenAI docs. Prefer a short capped request, strict schema, low-cost reasoning settings appropriate for extraction, and a clear retry/manual fallback.

## Existing project risks that must be handled

- Current Firebase initialization uses placeholder options and `.env` is not loaded.
- `google-services.json` and `firestore.rules` are deleted in the working tree.
- The router advertises screens it does not register.
- Booking is client-side and non-transactional.
- Payment/wallet code is simulated and unsafe for production.
- Firestore field names and timestamp formats differ between Flutter, generated models, Cloud Functions, and old rules.
- Admin verification writes directly from the client, while the reset callable only checks authentication.
- Cloud Functions payment release/refund authorization is inadequate.
- The existing AI verification/OpenRouter code is unused/placeholder and must not be presented as the contest AI feature.
- `.env` is tracked in Git history and secrets must be rotated before public publication.
- There is a redundant tracked nested Flutter starter under `fitareeae/`.
- Existing tests are only six domain smoke tests.
- No Git remote is currently configured. Target repository: `<GITHUB_OWNER/REPO>`.

Preserve user work. Do not reset or discard the dirty working tree. First create an explicit, honest snapshot of all pre-existing work with documentation that it predates Build Week and is not claimed as new contest work. Use a `build-week/final` branch and a clear baseline tag/commit. If the existing repository history contains secrets and the target is public, create a sanitized submission repository or otherwise remove the exposure safely; do not publish leaked credentials. Explain and record the chosen approach.

## Implementation order

### Stage 0: baseline, evidence, configuration

- Inspect status/diff and make an explicit pre-existing baseline checkpoint.
- Append the checkpoint to `docs/BUILD_WEEK_PROGRESS.md`.
- Verify/establish the exact GitHub target and remote.
- Rotate/sanitize tracked credentials before public push.
- Establish one coherent Firebase configuration path for Android.
- Confirm authentication can launch on Android.
- Keep the root Flutter app authoritative; do not accidentally build the nested starter.

### Stage 1: stable vertical slice and security

- Register only the routes needed by the judge path and remove/hide broken actions.
- Define canonical schemas and robust Timestamp/String conversion for shipped models.
- Implement booking through a callable/transaction that checks auth, ownership, trip state, seats, duplicate booking, and verification requirements atomically.
- Create Firestore and Storage rules matching the shipped collections and admin model.
- Require real backend authorization for verification approval/rejection.
- Remove, disable, or secure the global verification reset and payment release/refund callables.
- Hide simulated payments/wallets and other incomplete features from the submission path rather than expanding scope.

### Stage 2: GPT-5.6 Copilot

- Implement the backend Responses API integration and strict schema validation.
- Add per-user input limits, timeout, safe error mapping, basic throttling, and privacy-preserving logs.
- Build a polished Copilot input, examples, loading/error/clarification states, review/edit step, and deterministic results.
- Support at least: English ride request, package request, and Arabic request.
- Add unit/provider/widget tests around schema parsing, malformed output, ranking, empty results, retry, and user confirmation.

### Stage 3: judge-ready coherence

- Polish the demonstrated screens only.
- Provide seeded demo data or a test account without committing credentials.
- Ensure manual search remains available if AI is temporarily unavailable.
- Verify booking/chat/verification continuation.
- Add privacy, safety, limitations, and AI-draft disclosure.
- Remove debug logs and placeholders from the demo path.

### Stage 4: release and submission materials

- Add/update an English README with setup, architecture, testing, sample data, APK link, Build Week before/after table, Codex collaboration, GPT-5.6 design, security/privacy, and limitations.
- Add a suitable open-source license if publishing publicly and confirm third-party licenses/assets.
- Create `docs/TEST_MATRIX.md`, `docs/DEMO_SCRIPT.md`, `docs/SUBMISSION_CHECKLIST.md`, and `docs/BUILD_WEEK_CHANGELOG.md`.
- Prepare Devpost title, tagline, description, technologies, testing instructions, image captions, and a demo script under 2:45.
- Explicitly remind me to run `/feedback` in the primary build thread and paste its Session ID into Devpost.

## Mandatory verification after every stage

Run and record exact results in `docs/BUILD_WEEK_PROGRESS.md`:

```text
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
cd functions && npm run build
flutter build apk --debug
```

Add focused tests for changed behavior. Perform the stage's Android smoke path. Do not call a stage complete or push it as the latest checkpoint while a required gate fails. If a failure is genuinely outside submission scope, document it, hide/remove the affected path, and verify the judge path again.

At release candidate, also:

- build `app-release.apk` with a safe signing setup if available; otherwise publish a clearly labeled installable judge/debug APK;
- compute SHA-256 and size;
- install on a connected Android device with ADB when available, or give me exact manual installation steps and wait for my phone result;
- test a fresh install, sign-in/test account, AI planning, results, booking, and chat twice;
- download the APK from the same stable URL judges will receive and install that downloaded copy;
- tag the exact commit that produced it.

## Progress, GitHub, and continuity requirements

- `docs/BUILD_WEEK_PROGRESS.md` is append-only.
- Each entry needs Central/Pacific timestamp, objective, files changed, commands/results, APK path/hash/device, commit/tag, remote push status, known issues, rollback point, and next action.
- Commit coherent stages with honest messages distinguishing baseline from new Build Week work.
- After every passing stage, commit and push to `<GITHUB_OWNER/REPO>` and create/update a draft PR or the agreed final branch using `$github:yeet`.
- Never commit secrets, test passwords, keystores, service-account files, API keys, or private user data.
- Do not rewrite public history or force-push unless I explicitly approve the exact operation.
- Do not make the repository public until secret exposure is remediated.
- Keep the final APK URL and judge backend available through the judging period.

## Authorized actions and limits

I authorize you to read and edit files inside this repository; add narrowly necessary dependencies; run formatters, analyzers, tests, code generation, Firebase emulators, Flutter/Gradle builds, and Android install commands; create documentation and generated build artifacts; make local commits; push passing commits/tags to the configured `<GITHUB_OWNER/REPO>`; and open/update a draft PR.

I authorize deployment of the verified Firestore rules, indexes, Storage rules, and Firebase Functions only after you confirm the exact Firebase project ID is the intended Fitareeaee contest project, local builds/tests pass, secrets are configured server-side, and the deployment does not delete production data. Do not reset or delete Firebase data. Do not enable paid services, purchase anything, change billing, publish to an app store, send external messages, make the repository public, merge a PR, or incur more than USD $5 of OpenAI API testing without asking me first.

Use reasonable assumptions and continue autonomously. Ask only when a missing credential/target or consequential choice truly blocks progress. For approval prompts required by the environment, request the narrowest reusable command prefix needed. Never bypass sandbox/security approvals.

## Final handoff requirements

Do not stop at code completion. The task is complete only when you provide:

- a working tested Android judge build and stable APK path/link/hash;
- final GitHub commit, tag, branch/PR, and confirmation the remote matches local source;
- passing analysis, Flutter tests, Functions build, and recorded smoke tests;
- the Build Week before/after evidence and Codex/GPT-5.6 documentation;
- complete judge testing instructions and test access approach;
- Devpost-ready English copy and under-three-minute demo script;
- a final rules/submission checklist with every item marked done or requiring my manual action;
- the exact remaining manual actions, especially phone install confirmation, YouTube upload, `/feedback` Session ID, and final Devpost submit.

Lead each update with the outcome and keep working until this definition of done is met.

---
