# Judge Testing Instructions

Fitareeaee is an Android Flutter application built with Codex and powered at runtime by GPT-5.6. Testing is free; no payment card or OpenAI account is required by a judge.

> Release status: the hardened lifecycle backend, rules, fictional judge fixtures,
> and v1.0.16 public Android artifact are verified. The v1.0.16 APK was anonymously
> downloaded, hash-matched, installed, and cold-launched on a Moto G Play (2024).
> The exact bytes passed driver sign-in, role guidance, Offer creation UI,
> secure owner withdrawal, paid-confirmed chat, completed-only Past, and clean app-log checks. The same
> byte-identical local artifact passed interactive From/To map selection and generated
> label refresh. Earlier exact-public v1.0.14 testing covers Android microphone consent
> and active three-minute speech recognition.

> Current candidate: v1.0.16 retains the secure payment-gated lifecycle, complete
> role-specific verification, and live GPT-5.6 path; it adds editable local recurring
> plans, truthful submitted/approved progress, reliable account switching, explicit
> rider/driver guidance, correct labels after a map pin is re-picked, and secure
> owner withdrawal for open unpaid trips. Its 49/49 Flutter tests, 31/31 Functions
> contracts, 9/9 rules tests, 10/10 two-account
> lifecycle integration, and API 36 authenticated UI smoke pass. The
> [v1.0.16 prerelease](https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.16)
> is public and its 85,703,283-byte APK was independently downloaded, SHA-256
> matched, installed, and tested on the owner's phone.

Phone-tested rollback: universal profile APK, 83,378,603 bytes, SHA-256
`0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`,
private release-gate source `4630703b5a69e151d07d6e6c9683deced6298302`
and tree-equivalent sanitized source
`6d67f306203886d3d1623f9966f36764589b9cfb`. It reports version
`1.0.5` / code `20260719`, cold-launched on a Motorola phone, and produced zero
matching Fitareeaee fatal, Flutter-error, or app-ANR log entries.

## Current judge candidate

- Final source branch: [agent/payment-gated-chat-trip-support](https://github.com/MoazGamalMohamed/fitareeaee-copilot/tree/agent/payment-gated-chat-trip-support)
- Repository root/support: [github.com/MoazGamalMohamed/fitareeaee-copilot](https://github.com/MoazGamalMohamed/fitareeaee-copilot)
- APK URL: [app-profile.apk](https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.16/app-profile.apk)
- Build type: universal AOT profile Android judge APK, debug-signed for sideloading
- SHA-256: `FBDB24024908450DD8DF2686099A5F6A44A147B66E03B9B5CCDD51C25712415B`
- Source tag/commit: `fitareeaee-copilot-v1.0.16` / sanitized `a827e555f789f0913eb93c0ac34160f6b85d9218`
- Minimum Android version: **Android 7.0 / API 24** (verified from the merged release-candidate manifest)
- Judge account: **READY — provide the dedicated fictional rider credentials privately in Devpost testing instructions, never in Git**

Live GPT-5.6 planner verification: **PASS** — managed secret version 2 is enabled, obsolete
version 1 is destroyed, and `planTripWithCopilot` is deployed. On July 20 the exact
public v1.0.13 APK returned validated `gpt-5.6` review drafts for an English ride, a
5 kg English package, and an Arabic ride. No key was read or exposed.

Current physical-phone judge path: **PASS** — the exact public v1.0.16 APK is
installed on the Moto G Play (2024), reports version `1.0.16` / code `20260730`, and
cold-launched in 2.794 seconds. It authenticated the fictional driver, displayed the
role-specific Home/Offer actions, opened the complete Offer form, loaded the seeded
paid-confirmed conversation without the former Firebase failure, and showed the
completed-only Past/rating state. The byte-identical local artifact also passed a
live secure withdrawal that removed the disposable offer from Available while
retaining it as Cancelled history. It also passed
interactive From/To map pin selection and distinct refreshed labels. No matched app
fatal, Flutter, Firebase, permission, or ANR error appeared. No real payment or
identity is used.

New bookings in v1.0.16 are deliberately **not confirmed before payment**. Since
the contest build has no real payment provider, selecting a trip or driver creates
only a pending-payment record and does not decrement seats or unlock chat. Use the
seeded paid/confirmed fixture to demonstrate Chat; do not enter a real card.

## Install

1. On an Android phone or emulator, enable installation from the browser/file manager used to download the APK.
2. Download the APK from the final URL above.
3. Optionally verify its SHA-256 before installing:

   ```powershell
   Get-FileHash .\fitareeaee-copilot.apk -Algorithm SHA256
   ```

   ```bash
   sha256sum fitareeaee-copilot.apk
   ```

4. Open the APK and approve the Android installation prompt.
5. Launch **Fitareeaee** and sign in with the dedicated judge credentials supplied privately through Devpost.

The app is sideloaded for judging and is not a Google Play release.

## Recommended five-minute test

### 1. Create an English AI draft

From Home, tap **Plan with GPT-5.6** and enter:

> I need a ride from Dallas to Austin on August 10, 2026 at 9:00 AM for two people under $40, no smoking.

Tap **Create GPT-5.6 draft**. Verify that:

- the screen says **AI draft — review required**;
- intent/type, route, date/time, people, budget, and preferences are structured;
- every operational field is editable;
- the disclosure says GPT-5.6 does not book, verify identity, guarantee matches, or decide who is safe.

### 2. Review before searching

Edit one field, such as the budget. Tap **Confirm draft and find transparent matches**.

This confirmation starts search only. It should not create a trip or booking.

### 3. Inspect transparent matches

Verify that results are actual seeded/live Firestore trips and include understandable reasons such as route, time, seats, price, or preferences. Open a result to view trip details and verification context.

The dedicated judge accounts, trips, and verification flags are explicitly
fictional Build Week fixtures. They do not represent real people, reviewed real
identity documents, or a claim that any person or trip is safe.

If no trip matches, the expected behavior is an honest empty state with **Adjust AI draft** and manual browsing options. No synthetic trip should appear.

### 4. Continue the judge path

Using the provided seeded trip/account:

1. Open trip details.
2. Review manual verification context.
3. If **Book Trip** is shown, select it once and verify the server creates a
   **payment required** state without decrementing inventory or opening chat.
4. Open the separately supplied seeded paid/confirmed fixture and verify
   **Open Confirmed Chat** is shown instead of another booking action.
5. Open participant chat and send only a clearly fictional test message.

No real payment is requested or processed.

For an **offer** prompt, the expected result is a compatible request listing.
The verified driver may submit only a bounded proposal. Direct participant chat
stays closed until the rider selects the proposal and trusted payment confirmation
makes the resulting booking paid/confirmed.

### 5. Try Arabic or a package

Return to **Plan with GPT-5.6** and try either:

> أحتاج رحلة من دالاس إلى أوستن في 10 أغسطس 2026 الساعة التاسعة صباحًا لشخصين وبميزانية 40 دولارًا، بدون تدخين.

or:

> I need to send a 5 kg package from Chicago to Milwaukee on August 10, 2026 at 10:00 AM under $30.

The same structured review and explicit confirmation rules should apply.

## Failure and boundary checks

- Remove a required detail: expect missing-information guidance or a clarification question.
- Enter a request with an email/likely phone number: the app should report that contact details were removed before sending to OpenAI.
- Repeatedly submit too quickly: expect a friendly throttle message.
- Use manual search after an AI/backend error: the app should remain navigable.
- Expect no AI identity approval, safety declaration, guaranteed match, or automatic booking.
- Expect no wallet, escrow, payout, or real-payment workflow in the submitted path.

## Architecture being tested

```text
Flutter Android app
  → authenticated Firebase callable Function
  → OpenAI Responses API / GPT-5.6 with strict structured output
  → server validation and normalization
  → editable user-reviewed draft
  → deterministic ranking of real Firestore trips
  → trip details → manual verification context → transactional booking → participant chat
```

## Known limitations

- The APK is distributed directly for judging, not through Google Play.
- The v1.0.7 candidate includes an interactive map pin picker and English/Arabic
  speech entry. It does not provide turn-by-turn navigation, address autocomplete,
  full Arabic localization, or a routing-service ETA.
- AI output may misunderstand language; the user must review the draft.
- Matching depends on available Firestore trips and does not guarantee a result.
- Verification is manual context, not an assurance that a person or trip is safe.
- Payments, escrow, wallet, payout, and AI identity verification are excluded prototypes.

## Troubleshooting

- **Installation blocked:** allow installs from the downloading app, then retry.
- **Sign-in fails:** confirm the exact judge credentials and network connection; report the time/error without posting the password.
- **AI unavailable:** retry once, then use manual search. This is the designed fallback.
- **No matches:** use the documented seeded prompt/account or adjust the draft; the app intentionally does not fabricate results.
- **Already booked:** this is valid for the shared judge fixture; Trip Details should
  show **Open Confirmed Chat**, not a second confirmation action.
- **Support contact:** use the public repository's GitHub Issues tab without posting credentials or private data.
