# How to Reset All Verifications

## Quick Option: Firebase Console (5 minutes)

### Step 1: Open Firebase Console
https://console.firebase.google.com/project/fitareeaee/firestore/data/~2Fverifications

### Step 2: Reset Each User's Verification

For each document in the `verifications` collection:

**Click on the document → Click "..." menu → Select "Delete document"**

OR manually edit each field:

**Set to false:**
- `identityVerified: false`
- `selfieWithIdVerified: false`
- `driversLicenseVerified: false`
- `vehicleRegistrationVerified: false`
- `insuranceVerified: false`

**Delete these fields** (click "x" next to each):
- `identityVerifiedAt`
- `selfieWithIdVerifiedAt`
- `driversLicenseVerifiedAt`
- `vehicleRegistrationVerifiedAt`
- `insuranceVerifiedAt`
- `identityUrl`
- `selfieWithIdUrl`
- `driversLicenseUrl`
- `vehicleRegistrationUrl`
- `insuranceUrl`
- `verificationConfidence`
- `faceMatchConfidence`
- `idValidityConfidence`
- `verificationMethod`
- `verifiedBy`

**Update:**
- `updatedAt: <current timestamp>`

### Step 3: Clear Pending Requests (if any)
https://console.firebase.google.com/project/fitareeaee/firestore/data/~2Fverification_requests

Delete all documents in `verification_requests` collection.

---

## Alternative: Run Node.js Script

### Prerequisites
1. Install Node.js (if not already installed)
2. Install Firebase Admin SDK:
   ```bash
   npm install firebase-admin
   ```

3. Download Service Account Key:
   - Go to: https://console.firebase.google.com/project/fitareeaee/settings/serviceaccounts/adminsdk
   - Click "Generate new private key"
   - Save as `serviceAccountKey.json` in project root

4. Run the script:
   ```bash
   node reset_verifications.js
   ```

---

## What Happens After Reset?

✅ All verification statuses set to `false`
✅ All verification URLs deleted  
✅ Pending verification requests cleared
✅ Users will see "Not Verified" status in app
✅ Users can submit new verification documents

---

## Quick Check: See Current Verified Users

Run this in Firebase Console (Firestore Query):

1. Go to `verifications` collection
2. Add filter: `selfieWithIdVerified == true`
3. See how many users are currently verified

---

## IMPORTANT: Storage Files

This script only resets Firestore data. The actual ID photos remain in Firebase Storage at:
`verification_documents/{userId}/`

To also delete uploaded documents:
1. Go to: https://console.firebase.google.com/project/fitareeaee/storage
2. Navigate to `verification_documents/` folder
3. Delete all user folders

⚠️ **Warning**: This permanently deletes all ID photos. Users will need to re-upload.

---

## Need Help?

If you have many users (>50), it's better to use the Node.js script for bulk operations.
For just a few users, the Firebase Console is faster and easier.
