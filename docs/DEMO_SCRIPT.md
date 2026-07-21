# Demo Script — 2:40 Target

Target runtime: **2 minutes 40 seconds**. Hard limit: **under 3 minutes**. Record with audible narration, no copyrighted music, no credentials, and no private user data on screen.

Do not record the final take until the live backend, test data, and exact published judge build pass the end-to-end test matrix.

Release gate status: **v1.0.16 passes source, lifecycle backend, rules, local APK,
fresh English/package/Arabic GPT-5.6 evidence, reusable-plan, verification-progress,
API 36 emulator gates, scoped open-trip withdrawal, and exact-public physical-phone
driver/Offer/map/chat/Past smoke**. Before recording, enable Do Not Disturb, close messaging notifications,
and use only the fictional judge accounts. Do not show their credentials.

## Recording setup

- Use the final tagged APK and the same backend judges will access.
- Use fictional demo names/routes and a dedicated test account.
- Preload one compatible fictional Build Week fixture so the deterministic result is real and repeatable. Fixture verification flags are not evidence that a real person or document was reviewed and are never presented as a safety signal.
- Set large, readable emulator/phone text and hide notifications.
- Keep an English request ready to paste; optionally type a short Arabic request in a quick second example.
- Keep the architecture graphic and Build Week before/after slide ready.
- Record a clean backup take.

## Timed narration and actions

### 0:00–0:14 — The problem

**On screen:** Title, then Home.

**Say:** “Finding a community ride—or someone to carry a package—usually means translating an everyday need into rigid forms, then guessing why one result fits. Fitareeaee Copilot makes that planning conversational and transparent.”

### 0:14–0:29 — Honest Build Week boundary

**On screen:** Brief before/after card, then tap **Plan with AI**.

**Say:** “Fitareeaee’s Flutter marketplace existed before Build Week. During Build Week I built this new GPT-5.6 Copilot, review-first matching flow, transactional booking security, authorization rules, and judge-ready Android delivery.”

### 0:29–0:53 — Natural-language planning

**On screen:** Tap the microphone and say, or paste as a recording fallback: “I need a ride from Dallas to Austin on August 10, 2026 at 9:00 AM for two people under $40, no smoking.” Tap **Create AI draft**.

**Say:** “I can type or speak a ride or package naturally in English or Arabic. The app sends only the redacted request, locale, timezone, and current date through an authenticated Firebase Function. Contact details and links in free text are filtered.”

If time allows, briefly show **Saved trip plans** and say: “A recurring request can
stay as an editable template on this device, so I remain in control of when it is
sent to GPT-5.6.”

### 0:53–1:17 — Structured, reviewable draft

**On screen:** Slowly show intent, type, origin, destination, date/time, people, budget, preferences, summary, and the AI disclosure. Edit one field.

**Say:** “GPT-5.6 returns a strict structured draft, which the server validates again. It is clearly labeled as an AI draft. I can correct every field, and missing information becomes a clarification—not an invented assumption. Nothing is saved or booked yet.”

### 1:17–1:39 — Transparent real matches

**On screen:** Tap **Confirm draft and find transparent matches**. Show ranked result and reason chips.

**Say:** “Confirmation runs deterministic search over real Firestore trips. GPT interprets my words; code controls filtering and ranking. Each result explains route compatibility, departure time, seats, budget, and preferences. If Firestore has no match, the app says so and never fabricates one.”

### 1:39–1:58 — Trust, booking, and chat

**On screen:** Open trip details and show verification context. Select once and
show **payment required** with chat still locked. Then open the separate seeded
paid/confirmed fixture and show its participant chat.

**Say:** “The journey continues through trip details and manual verification context. These demo badges are fictional—not a safety claim. A new selection stays pending payment and cannot change seats or unlock chat. Only this seeded paid-confirmed fixture opens a trip-specific conversation for server-authorized participants.”

### 1:58–2:20 — Architecture and safety

**On screen:** Architecture graphic: Flutter → Firebase callable → OpenAI Responses API / GPT-5.6 → validated draft → deterministic Firestore ranking.

**Say:** “The OpenAI key stays in a managed server secret—never Dart, Git, logs, or the APK. The callable adds authentication, strict JSON Schema, validation, timeouts, input limits, and per-user throttling. GPT never approves identity, declares someone safe, makes emergency decisions, or guarantees a match.”

### 2:20–2:34 — Codex collaboration

**On screen:** Fast montage of dated commits, tests, rules, and APK evidence.

**Say:** “Codex helped turn a broad prototype into this focused extension: auditing the baseline, implementing Flutter and Functions, threat-modeling rules and booking, writing tests, running Android builds, and preserving an append-only evidence trail. I made the product, scope, privacy, and release decisions.”

### 2:34–2:40 — Close

**On screen:** Copilot result and product name.

**Say:** “Fitareeaee Copilot turns everyday intent into a plan you control—and matches you can understand.”

## Optional Arabic insert

If the English flow is comfortably under time, replace 5–7 seconds of the natural-language section with this prompt and show that the same structured review appears:

`أحتاج رحلة من دالاس إلى أوستن في 10 أغسطس 2026 الساعة التاسعة صباحًا لشخصين وبميزانية 40 دولارًا، بدون تدخين.`

Do not show two full AI calls if network latency risks exceeding three minutes.

## Final video checks

- Runtime is under 3:00, including intro/outro.
- Narration is audible and the UI text is readable at 1080p.
- The demonstrated path matches the published build.
- GPT-5.6, Codex, the meaningful Build Week extension, and the architecture are explicitly explained.
- No API key, password, email, phone number, user ID, identity document, private chat, or Firebase console secret is visible.
- The upload is public on YouTube and plays while signed out.
