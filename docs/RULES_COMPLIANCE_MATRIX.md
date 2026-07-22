# OpenAI Build Week Rules Compliance Matrix

Last live review: **July 21, 2026**

Authoritative sources:

- [Official Rules](https://openai.devpost.com/rules)
- [Live FAQ](https://openai.devpost.com/details/faqs)
- [Challenge overview and judging criteria](https://openai.devpost.com/)
- [Official GPT-5.6 model guidance](https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6)

If this document conflicts with the official website, the official website wins.

## Submission and eligibility

| Official requirement | Fitareeaee evidence | Status / owner action |
| --- | --- | --- |
| Submit by July 21, 2026 at 5:00 PM Pacific | Final APK, repository, description, judge guide, and demo script are prepared before the deadline. | Owner must complete the legally binding Devpost submission before 5:00 PM Pacific. |
| Choose one track | **Apps for Your Life**: a consumer ride and package-delivery planning application. | Ready |
| Build a working project with Codex and GPT-5.6 | Codex is the primary Build Week engineering workflow; the deployed server uses the official OpenAI SDK, Responses API, and `gpt-5.6` for structured trip planning and bounded first-line support. | Ready; primary Session ID still must be pasted into Devpost. |
| Existing projects must be meaningfully extended during the submission period | `PRE_BUILD_WEEK_BASELINE.md`, the baseline tag, dated commits, `BUILD_WEEK_CHANGELOG.md`, `PUBLICATION_HISTORY.md`, and the append-only progress log distinguish inherited work from Build Week work. | Ready |
| Project installs, runs consistently, and matches the video/text | Universal Android APK plus free fictional judge accounts, deterministic fixture data, release hashes, automated gates, emulator checks, and physical-phone checks are documented. | Final video must depict only behavior in the exact submitted APK. |
| Entrant and team satisfy eligibility and conflict rules | No technical artifact can establish the entrant's age, residence, authority, conflicts, or other legal facts. | Owner legal confirmation required. |

## Required Devpost materials

| Official requirement | Fitareeaee evidence | Status / owner action |
| --- | --- | --- |
| English text description explaining features and operation | `DEVPOST_SUBMISSION.md` contains English title, tagline, description, architecture, technologies, limitations, and testing summary. | Ready |
| Public YouTube demonstration, three minutes or under | `DEMO_SCRIPT.md` targets 2:40 and covers the working product, Codex, GPT-5.6, Build Week delta, and safety boundaries. | Owner must record, upload as Public, verify while signed out, and paste the URL. |
| Video has audible voiceover | The script contains exact narration for every segment. | Owner must confirm audio is audible. Background music alone does not satisfy the rule. |
| Video explains what was built, how Codex was used, and how GPT-5.6 is used | Dedicated narration distinguishes Codex's engineering role from GPT-5.6's runtime role. | Ready in script; owner must preserve it in the final recording. |
| Video avoids unauthorized copyrighted material and third-party marks | No music is bundled; the script requires no copyrighted music, private data, credentials, or unnecessary third-party branding. | Owner must audit the final recording and confirm rights/authorization. |
| Repository URL for judging and testing | Public sanitized repository with MIT license and branch-specific final source link. | Ready |
| README includes setup, sample/test data, testing guidance, Codex collaboration, human decisions, and GPT-5.6 use | `README.md` contains each required section and links to detailed evidence. | Ready |
| `/feedback` Codex Session ID from the primary build thread | The latest organizer checklist says to run `/feedback` from the slash menu; the FAQ's `/status` command remains the display fallback. | Owner must run `/feedback` here and paste its Session ID into Devpost. |
| Free working access through the judging period | Direct APK and private fictional judge credentials; judges need neither a payment card nor an OpenAI account. | Owner must paste credentials only into Devpost's private testing instructions and keep Firebase/APK available through August 5. |
| Submission materials are in English | README, Devpost copy, judge guide, captions, and narration are in English; Arabic is demonstrated only as an app input. | Ready |

## Technical implementation evidence

| Area | Evidence |
| --- | --- |
| Codex | Repository audit, honest baseline, architecture tracing, Flutter/Functions/security-rule implementation, threat modeling, automated tests, release gates, APK/device validation, documentation, and dated progress evidence. Human product, privacy, scope, safety, and release decisions remain explicit. |
| GPT-5.6 | Official OpenAI Node SDK and Responses API; literal `gpt-5.6` model; strict JSON Schema output; independent server validation; authenticated callables; server-held secret; input/output limits; timeouts; throttling; contact redaction; privacy-preserving `safety_identifier`; `store: false`; bounded error mapping. |
| Non-decorative use | GPT-5.6 turns English/Arabic free-form requests or offers into the structured draft that drives the central review and matching workflow. It also provides bounded first-line support before human escalation. |
| Deterministic authority | Application code controls role eligibility, verification, trip publication, ranking, inventory, payment state, booking, lifecycle, and chat authorization. GPT-5.6 cannot approve identity, declare safety, process payment, guarantee a match, or book automatically. |
| Request versus Offer | **Request** creates the paying rider/sender side. **Offer** creates the receiving driver/courier side. A recognized marketplace account may select either action, but the server requires participant verification for Request and additional driver-licence and vehicle verification for Offer, then rechecks both sides during booking. |
| Judge viability | Complete product experience: Home → GPT-5.6 draft → review → transparent real matches → details → verification context → pending-payment boundary → seeded paid-confirmed chat → completion/rating/Past. |

## Judging criteria alignment

- **Technological Implementation:** meaningful Codex collaboration, official GPT-5.6 integration, strict server boundaries, authorization rules, tests, and release evidence.
- **Design:** coherent Android experience with distinct Request and Offer paths, voice input, map pin selection, editable drafts, transparent matching, and truthful empty/error/payment states.
- **Potential Impact:** reduces rigid-form and language barriers for people arranging community rides or package delivery, including English/Arabic voice entry and accessibility announcements.
- **Quality of the Idea:** combines natural-language interpretation with explainable deterministic matching instead of delegating trust, identity, payment, or operational decisions to a model.

## Final owner-only actions

1. Confirm eligibility, ownership, third-party rights, and acceptance of the Official Rules.
2. Record the exact submitted APK with the 2:40 English voiceover; upload it publicly or unlisted to YouTube and verify it signed out.
3. Run `/feedback` in the primary Codex build thread and paste its Session ID; use `/status` only if the ID must be displayed again.
4. Paste fictional judge credentials into Devpost's private testing instructions only.
5. Preview every link and submit before 5:00 PM Pacific; save a copy of the final submitted page.
