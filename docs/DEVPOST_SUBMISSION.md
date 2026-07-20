# Devpost Submission Draft

This is judge-ready English copy, but fields marked **PENDING** must be replaced with verified release details before submission.

## Core fields

**Track:** Apps for Your Life

**Title:** Fitareeaee Copilot — trusted, natural-language ride and package matching

**Tagline:** Plan rides and packages in English or Arabic—with AI drafts you control and matches you can understand.

**Repository:** https://github.com/MoazGamalMohamed/fitareeaee-copilot

**Demo video:** **PENDING — public YouTube URL, under three minutes with audio**

**Test build:** https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.5/app-profile.apk — 83,378,603 bytes; SHA-256 `0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`

**Primary Codex Session ID:** **PENDING — run `/feedback` in the primary build thread**

## Description

### Inspiration

Community rides and informal package delivery often begin as a simple sentence: “I need to get from Dallas to Austin Monday morning,” or “Can someone carry a small package next week?” Existing flows make people translate that intent into rigid fields before they can even see whether a compatible trip exists. They also tend to hide why a result was selected.

Fitareeaee Copilot starts with the way people naturally ask for help. It turns an English or Arabic request into a structured plan the user can inspect, correct, and explicitly confirm—then ranks real community trips with reasons the user can understand.

### What it does

From Home, a user taps **Plan with AI** and describes a ride they need, a trip they can offer, or a package they want to send. GPT-5.6 interprets the request into a strict draft containing intent, type, origin, destination, departure date/time, people or seats, package details, maximum budget, preferences, a concise summary, missing information, and a clarification question when needed.

For accessibility, the same Home-only Copilot accepts English or Arabic speech
and can announce its draft through Android accessibility services. A user who
prefers a form can create a ride/package request or, after driver and vehicle
verification, an offer manually and place origin/destination pins on an
interactive OpenStreetMap.

The draft is visibly labeled as AI-generated and remains editable. Copilot never
writes a trip or booking: confirming the reviewed draft only performs
deterministic search over real Firestore trips. Booking, when applicable, is a
later separate explicit action. The app explains route compatibility, time,
availability, price, and preference reasons instead of asking the model to make
an opaque match.

For a find/rider match, the user can continue to trip details, manual
verification context, and a server-authoritative pending-payment booking. An
offer draft ranks request listings; a manually verified driver can submit a
bounded proposal and the rider chooses the proposal. Neither path decrements
seats, confirms a trip, or opens direct chat until payment is verified by a
trusted server. If AI/network access fails, retry and manual search remain
available. Empty Firestore results stay empty.

### How we built it

The Android client is built in Flutter with Riverpod and GoRouter. It sends a minimal authenticated callable request to Firebase Functions. The Function uses the official OpenAI Node SDK and Responses API with `gpt-5.6`, strict JSON Schema output, independent validation, bounded tokens, timeouts, safe error mapping, and per-user throttling. The OpenAI key is a managed server secret and never ships in Dart or the APK. The authenticated live matrix passed English ride, English package, and Arabic ride requests.

After the structured draft returns, deterministic Dart code filters and ranks Firestore trips. GPT-5.6 handles language understanding; application code controls operational eligibility and explains the result. Booking/proposal Functions verify authentication, roles, ownership, trip state, departure, manual verification, duplicates, budget, and inventory. New selections remain pending payment; only a trusted payment finalizer could later confirm them and unlock seats/chat.

Firestore and Storage rules default-deny unknown access, protect verification state, keep Copilot throttle records private, and restrict chat to participants.

### Meaningful Build Week work

Fitareeaee existed before Build Week as a Flutter/Firebase marketplace prototype. That earlier authentication, profile, marketplace, chat, and prototype feature work is not claimed as new.

During Build Week we added the central Fitareeaee Copilot extension: the Home entry point, English/Arabic structured planning and speech entry, official GPT-5.6 Responses API backend, review/edit/confirmation flow, transparent deterministic matching, privacy and safety boundaries, retry/manual fallback, interactive manual trip map pins, transactional booking and lifecycle hardening, server-side verification authorization, restrictive data rules, expanded tests, Android checkpoints, and submission evidence.

The repository preserves an explicit pre-Build Week baseline commit/tag and an append-only progress log so judges can distinguish the extension from older work.

### How Codex helped

Codex served as the primary engineering collaborator across the repository rather than as a one-off code generator. It read the existing architecture and official contest/API guidance, established the honest baseline, traced schema and route mismatches, implemented Flutter and Firebase Functions changes, threat-modeled booking and verification, wrote contract/widget/rules tests, ran repeated Android build gates, recorded APK hashes, and assembled judge documentation.

Human decisions remained explicit: the product/track, the review-first AI boundary, deterministic matching, privacy exclusions, removal of simulated finance from the demo, no AI identity approval, release scope, and final legal submission stay with the developer.

### Challenges

The hardest challenge was turning a broad existing prototype into one coherent and defensible judge path without claiming old work. That required preserving the baseline, narrowing deployable backend surface, reconciling Flutter/Firestore/Functions schemas, moving booking into an atomic server transaction, and separating language interpretation from deterministic matching.

Another challenge was treating model output as untrusted input. Strict structured output is only the first boundary; the server validates every field again, maps failures safely, limits usage, and returns a draft that still requires human review.

### Accomplishments

- A meaningful GPT-5.6 feature that changes how users interact with the product.
- English/Arabic ride and package understanding through one reviewed schema.
- Transparent matching rather than opaque model-made decisions.
- No fabricated live trips and a usable manual fallback.
- Atomic booking and server-controlled verification authorization.
- Privacy minimization, contact-detail redaction, throttling, and strict validation.
- Dated baseline/evidence plus Flutter, Functions, rules, and Android test gates.

### What we learned

AI is most useful here as an interface to human intent, not as the authority over identity, safety, inventory, or transactions. Combining GPT-5.6 language understanding with deterministic application rules produces a workflow that is both flexible and explainable. We also learned that a trustworthy Build Week submission needs evidence and scope discipline as much as features: old work must be visible, tests must match claims, and prototypes that cannot be secured should not appear in the judge path.

### What’s next

After judging, the next steps are stronger multilingual PII detection, Firebase App Check enforcement, operational monitoring, improved location autocomplete, a broader Arabic interface, accessibility testing across more devices, and carefully designed trust/safety operations. Real payments would require a separate compliant product and security effort; they are intentionally excluded from this submission.

## Technologies

- Flutter / Dart
- Material 3
- Riverpod
- GoRouter
- Firebase Authentication
- Cloud Firestore
- Firebase Cloud Functions (Node.js 20 / TypeScript)
- Firebase Storage and Security Rules
- Firebase Local Emulator Suite
- OpenAI official Node SDK
- OpenAI Responses API
- GPT-5.6
- Strict JSON Schema structured output
- Node test runner
- Flutter widget and domain tests
- flutter_map / OpenStreetMap tiles
- speech_to_text and Android accessibility announcements
- Android SDK / Gradle / ADB
- Git and Codex

## Architecture summary

```text
Natural-language request (English or Arabic)
  → Flutter review flow
  → authenticated Firebase callable
  → privacy filtering + rate limit
  → OpenAI Responses API / GPT-5.6
  → strict schema + independent server validation
  → editable AI draft
  → explicit user confirmation
  → deterministic Firestore ranking with reasons
  → trip details / manual verification context
  → pending-payment booking/proposal
  → trusted paid confirmation (seeded fixture in contest build)
  → participant-only chat
```

GPT-5.6 interprets intent. It does not approve identity, declare users safe, make emergency decisions, guarantee matches, alter inventory, or book automatically.

## Before/after table

| Before Build Week | Built during Build Week |
| --- | --- |
| Existing Flutter/Firebase marketplace prototype | Fitareeaee Copilot as the central new workflow |
| Rigid trip forms/manual browsing | English/Arabic natural-language planning |
| Unused OpenRouter/AI-verification prototype | Official server-side GPT-5.6 Responses API integration |
| No contest-facing structured AI result | Strict validated, editable trip draft |
| Existing trip browsing | Deterministic ranking with transparent reasons |
| Client-side booking risks | Authenticated atomic booking transaction |
| Primarily UI-protected verification | Server-controlled manual review and restrictive rules |
| Broad prototype surface | Focused judge path with finance/reset/dead paths excluded |
| Six domain smoke tests | Expanded Flutter, Functions, and rules contracts |

## Testing instructions summary

Install the universal Android APK, sign in with the privately supplied judge account, tap **Plan with AI**, and use: “I need a ride from Dallas to Austin on August 10, 2026 at 9:00 AM for two people under $40, no smoking.” Review/edit the AI draft, confirm it, and inspect the transparent match reasons plus details. Verify that a new selection says payment required and does not unlock chat. Use the seeded paid/confirmed fixture to demonstrate Chat. Then try the fixed-date Arabic or package prompt in the judge guide. No payment card or OpenAI account is required.

Full instructions: [`JUDGE_TESTING.md`](JUDGE_TESTING.md).

## Known limitations

- The final APK is sideloaded rather than distributed through Google Play.
- Matching depends on actual seeded/live Firestore trips and never guarantees a result.
- AI interpretation can be wrong; all output requires review.
- Verification is manual context, not a declaration that a participant is safe.
- No real payment, escrow, wallet, payout, AI identity verification, or emergency support is included.
- The v1.0.7 candidate includes interactive map pins, permanent linked
  OpenStreetMap attribution, and English/Arabic speech
  entry, but not turn-by-turn navigation, routing-service ETA, address autocomplete,
  or full Arabic UI localization.
- The v1.0.5 public APK passed download/hash verification, emulator installation,
  Motorola installation/cold launch, authenticated Home, payment-gated Chat empty
  state, manual request creation, and app-specific crash-log checks. The live GPT-5.6
  draft, transparent match, details, seeded confirmed Chat, and fictional realtime
  message evidence remains recorded from its source-compatible predecessor.

## Suggested screenshot/image captions

1. **Home:** “Plan with AI makes the Build Week Copilot the clearest path into Fitareeaee.”
2. **Natural-language input:** “Describe a ride or package in everyday English or Arabic, with clear AI and privacy boundaries.”
3. **Reviewable draft:** “GPT-5.6 returns a strict, editable draft—never an automatic booking.”
4. **Transparent matches:** “Real Firestore trips are ranked deterministically with route, time, availability, price, and preference reasons.”
5. **Trust and booking:** “A new selection remains pending payment; only a trusted paid confirmation can unlock inventory and participant chat.”
6. **Architecture:** “Flutter → secured Firebase Function → OpenAI Responses API/GPT-5.6 → validated draft → deterministic matching.”

## Final fields to replace

- **DONE:** public repository URL
- **PENDING:** public YouTube URL
- **DONE:** stable v1.0.5 fallback APK URL, size, and SHA-256
- **PENDING:** replace the test-build fields with the already published/hash-matched
  v1.0.7 prerelease only after physical-phone smoke and stable promotion
- **DONE:** release tag `fitareeaee-copilot-v1.0.5` / sanitized source commit `6d67f306203886d3d1623f9966f36764589b9cfb`
- **PENDING:** private judge credential placement
- **DONE:** public repository Issues tab for non-sensitive support
- **PENDING:** primary Codex `/feedback` Session ID
