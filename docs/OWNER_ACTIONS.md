# Owner Actions Before Release

This handoff contains only actions that require an account owner, a private
credential, a legal decision, or physical-device interaction. Do not paste API
keys, passwords, service-account files, signing material, or recovery codes into
Codex chat, Git, documentation, screenshots, or the APK.

## Immediate unblock bundle

### 1. Confirm provider-side revocation of the exposed old OpenAI key

A different key was entered privately through Firebase CLI's hidden prompt,
stored as managed secret version 2, deployed only to `planTripWithCopilot`, and
verified with authenticated English ride, English package, and Arabic ride
requests. Obsolete managed version 1 was destroyed, and the post-retirement live
matrix passed. In the OpenAI dashboard, confirm that the old key pasted into the
build conversation is revoked. Never send either key in chat.

### 2. Judge users and fixtures — completed

Two dedicated fictional Firebase Auth judge users and four fixed August 10,
2026 ride/package fixtures are provisioned in `fitareeaee`. Their credentials
exist only in owner-restricted, Git-ignored `.judge-credentials.local.json`.
Keep the eventual judge login credentials only in the private Devpost testing
field, not the public repository, video, screenshots, or progress log.

### 3. GitHub publication — completed

The existing `github.com` Git credential was validated in memory without
printing it. The public repository exists at
`https://github.com/MoazGamalMohamed/fitareeaee-copilot`; both sanitized branches
and annotated tags are pushed. The private original still has no remote.

### 4. Approve or decline inherited Function retirement

The following 36 live prototype Functions exist in project `fitareeaee`, are
absent from the submitted source and judge navigation, and may still serve an
unknown older client. Deletion is therefore intentionally blocked pending the
owner's explicit approval:

```text
adminProcessRefund
adminUnsuspendUser
cancelPayoutRequest
confirmPayment
confirmPaymentEscrow
createPaymentIntent
createPaymentMethodFromCard
createStripeCustomer
getAIVerificationStats
getPayoutStats
getPendingPayouts
onAdminAlertCreated
onBookingCreated
onBookingStatusChanged
onNotificationCreated
onRatingCreated
onRefundRequestCreated
onRefundRequestUpdated
onSupportChatCreated
onTripStatusChanged
onUserCreated
onUserSignOut
onVerificationRequestCreated
placeDetails
placesAutocomplete
processPayoutRequest
processWeeklyPayouts
refundPayment
releaseEscrowPayment
rerunAIVerification
resetAllVerifications
reverseGeocode
savePaymentMethod
scheduledCleanup
stripeWebhook
triggerManualPayoutRun
```

Reply with an explicit approval naming this exact set, or state that it must be
preserved. Codex will not infer permission and will not delete production data.

### 5. Rotate legacy credentials

Firebase CLI diagnostics exposed a legacy Stripe test credential and email app
password from old Runtime Config. No value was copied into source or evidence.
Revoke/rotate both in their provider consoles and update or remove the obsolete
Runtime Config privately. Do not share replacement values in chat.

## Later physical/legal actions

- Physical phone installation is blocked by the differently signed older
  `com.fitareeaee.app` package. The public APK reached Android, but replacing the
  older package requires uninstalling it and deleting its local app data. If that
  data may be discarded, explicitly approve this exact action in chat:
  `UNINSTALL com.fitareeaee.app FROM PHONE ZY22KQPKZS AND DELETE ITS LOCAL APP DATA`.
  Codex can then install and smoke-test the hash-verified public APK through ADB.
- Record the final deployed flow using fictional data and the 2:40 script; upload
  it as a public YouTube video with audio and no unauthorized music/material.
- Run `/feedback` in the primary Codex build thread and paste its Session ID into
  Devpost.
- Review eligibility, ownership, privacy, testing credentials, and every final
  link, then personally perform the legally binding Devpost submission action.

See [`SUBMISSION_CHECKLIST.md`](SUBMISSION_CHECKLIST.md) for the complete release
gate and [`BUILD_WEEK_PROGRESS.md`](BUILD_WEEK_PROGRESS.md) for append-only
evidence.
