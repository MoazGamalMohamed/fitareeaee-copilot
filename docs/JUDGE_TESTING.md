# Judge Testing Instructions

Fitareeaee Copilot is an Android Flutter application. Testing is free; no payment card or OpenAI account is required by a judge.

> Release status: the hardened backend, rules, judge fixtures, authenticated
> GPT-5.6 Copilot, and public Android artifact are deployed and verified. The
> v1.0.5 APK was downloaded, hash-matched, and installed on a Motorola phone.
> Authenticated Home, manual trip creation, payment-gated Chat, version metadata,
> and app-specific crash logs passed on that exact public artifact.

> Superseding candidate: v1.0.6 adds interactive origin/destination map pins,
> English/Arabic speech entry, completed-only Past Trips, and server-authoritative
> start/complete/cancel/rating lifecycle controls. Its local profile APK passed
> the complete automated gate and authenticated API 36 emulator smoke. The
> [v1.0.6 prerelease](https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/tag/fitareeaee-copilot-v1.0.6)
> is public and its APK was anonymously redownloaded, hash-matched, clean-installed,
> and cold-launched on API 36. Keep using the stable v1.0.5 information below until
> that exact v1.0.6 download is tested on the owner's phone.

Final artifact: universal profile APK, 83,378,603 bytes, SHA-256
`0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`,
private release-gate source `4630703b5a69e151d07d6e6c9683deced6298302`
and tree-equivalent sanitized source
`6d67f306203886d3d1623f9966f36764589b9cfb`. It reports version
`1.0.5` / code `20260719`, cold-launched on a Motorola phone, and produced zero
matching Fitareeaee fatal, Flutter-error, or app-ANR log entries.

## Final release information

- Repository: [github.com/MoazGamalMohamed/fitareeaee-copilot](https://github.com/MoazGamalMohamed/fitareeaee-copilot)
- APK URL: [app-profile.apk](https://github.com/MoazGamalMohamed/fitareeaee-copilot/releases/download/fitareeaee-copilot-v1.0.5/app-profile.apk)
- Build type: universal AOT profile Android judge APK, debug-signed for sideloading
- SHA-256: `0BFCB8E7712F0EA4CBEFBC6F9D7AB83A68B3CEDAB207D8EC158ECF6424D8DB64`
- Source tag/commit: `fitareeaee-copilot-v1.0.5` / sanitized `6d67f306203886d3d1623f9966f36764589b9cfb`
- Minimum Android version: **Android 7.0 / API 24** (verified from the merged release-candidate manifest)
- Judge account: **READY — provide the dedicated fictional rider credentials privately in Devpost testing instructions, never in Git**

Live Copilot verification: **PASS** — authenticated English ride, English
package, and Arabic ride requests returned validated drafts through the deployed
Firebase callable after the obsolete secret version was retired.

Physical judge path: **PASS** — the fixed English request returned a reviewable
GPT-5.6 draft and one transparent live match. The match opened Trip Details; a
separate seeded paid/confirmed fixture opened participant Chat and rendered a
fictional realtime message. No real payment or real identity is involved.

New bookings in v1.0.5 are deliberately **not confirmed before payment**. Since
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
5. Launch **Fitareeaee Copilot** and sign in with the dedicated judge credentials supplied privately through Devpost.

The app is sideloaded for judging and is not a Google Play release.

## Recommended five-minute test

### 1. Create an English AI draft

From Home, tap **Plan with AI** and enter:

> I need a ride from Dallas to Austin on August 10, 2026 at 9:00 AM for two people under $40, no smoking.

Tap **Create AI draft**. Verify that:

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

Return to **Plan with AI** and try either:

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
- The v1.0.6 candidate includes an interactive map pin picker and English/Arabic
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
