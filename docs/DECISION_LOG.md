# Build Week Decision Log

This log records consequential scope and conflict decisions. It complements the
append-only execution evidence in `BUILD_WEEK_PROGRESS.md`.

## 2026-07-18 — Contest release hierarchy

- Official rules and the live Devpost site override older notes and prototypes.
- The demonstrated Home → Copilot → review → real matches → details → verification
  → booking → trip-specific chat path has priority over marketplace breadth.
- English and USD are the contest shell defaults. Arabic Copilot input remains
  required. Non-functional language/currency selectors will not ship.
- Real payment, escrow, refunds, wallet, bank payout, cashback, AI identity approval,
  embedded turn-by-turn maps, and automatic private-chat moderation remain excluded.
  No simulated balance or money movement may be represented as real.
- Voice-to-Copilot ships only if permission, transcript review, Arabic/English
  fallback, accessibility, and physical-phone tests all pass. Otherwise it remains
  a documented post-contest enhancement.

## 2026-07-18 — Identity and communication safety

- Manual admin review remains authoritative for identity verification. GPT-5.6
  receives no identity images, document numbers, chat text, phone numbers, or account IDs.
- Conversations must be authorized server-side and scoped to a trip/booking, not
  merely a participant pair. A canceled/past conversation may remain readable but
  must not silently become the chat for a new trip.
- Admins do not receive blanket private-chat access. Contest support uses explicit
  case escalation and auditable authorization or is deferred.
- A phone action may only reveal an authorized verified contact after booking/request
  authorization and must open the device dialer; no direct-call permission is used.

## 2026-07-18 — Judge data and publication

- The approved judge provisioner creates only two fictional users and fixed fixture
  documents. Credentials stay in the ignored local file and private Devpost field.
- Owner-user Google credentials require a quota-project header; Firestore fixture
  writes use a short-lived access token through the official REST commit endpoint,
  avoiding service-account files.
- The private original history is never published because it once tracked `.env`.
  Only the separately sanitized durable sibling clone may receive a GitHub remote.
- Placeholder examples in preserved pre-existing history are not credentials; they
  are recorded separately from real secret scans and must never be described as live keys.

## 2026-07-18 — Submitted product boundary

- Trip-scoped chat, transactional pre-departure cancellation, incoming/outgoing booking
  visibility, manual verification, and deterministic live-trip matching ship in the
  judge path.
- Cancelled conversations remain readable but become write-closed. A new trip creates
  a distinct authorization and an empty conversation.
- The contest build exposes no payment, escrow, wallet, refund, bank payout, or cashback
  control. Settings disclose that payments are disabled rather than simulating money.
- Interface localization and currency conversion do not ship because they are not
  end-to-end functional. English/USD remain explicit; Arabic natural-language Copilot
  input remains supported and tested.
- Android release updates use dated version code `20260718`; the stale version code `1`
  discovered during emulator installation is not a release candidate.

## 2026-07-20 — Reusable plans and authentication lifecycle

- Recurring trip plans are stored only in account-scoped local preferences. They
  contain a name and natural-language request, never booking, payment, verification,
  identity, contact, or chat data. A template reaches GPT-5.6 only after an explicit
  new draft action.
- Authentication routing is driven by Firebase's current session and one stable
  router. User/screen data providers are disposable, and owner profiles reload after
  explicit edits instead of holding a Firestore listener through sign-out.
- Verification progress reports both submission and approval. An uploaded document
  is not represented as approved until manual review says so.
- A debug-signed profile APK remains acceptable for the contest sideload build
  because no safe private release-signing configuration exists. Physical-phone
  verification is reported separately and never inferred from emulator success.
