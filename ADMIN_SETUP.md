# Admin Setup Guide

## Overview
The admin panel is now protected - only users in the `admins` collection can access it. The shield icon only appears for admin users.

## How to Add Yourself as Admin

### Step 1: Get Your User ID
1. Open the app and sign in
2. Go to the Profile screen
3. Your user ID is visible in the profile data or in the URL when editing profile

**OR** find it in Firebase Console:
1. Go to Firebase Console: https://console.firebase.google.com/project/fitareeaee
2. Navigate to **Authentication** → **Users**
3. Copy your **User UID**

### Step 2: Add Admin Document in Firestore
1. Go to Firebase Console: https://console.firebase.google.com/project/fitareeaee/firestore/data
2. Click **"Start collection"** (if `admins` collection doesn't exist)
3. Collection ID: `admins`
4. Click **"Next"**
5. Document ID: **[YOUR_USER_ID]** (paste the UID you copied)
6. Add field:
   - Field: `isAdmin`
   - Type: `boolean`
   - Value: `true`
7. Add another field (optional but recommended):
   - Field: `email`
   - Type: `string`
   - Value: `your@email.com`
8. Click **"Save"**

### Step 3: Verify Admin Access
1. **Hot restart** the app (press `R` in terminal or stop/restart)
2. Go to Profile screen
3. You should now see the **shield icon** (🛡️) in the top-right
4. Tap it to access the admin panel

## How to Add Other Admins

### Option 1: Via Firebase Console (Recommended)
Same as Step 2 above, but use the other person's User ID.

### Option 2: Via Code (Future Enhancement)
Currently, admins can only be added via Firebase Console. To enable admins to add other admins through the app:

1. Create an admin management screen
2. Add a form to enter user email or ID
3. Call `adminRepository.addAdmin(userId)` (needs implementation)

## Security Notes

- **Admin documents can only be created via Firebase Console** (Firestore rules prevent app-side creation)
- **Users can only read their own admin status** (prevents discovering who admins are)
- **Admin panel checks authentication twice**: 
  - Once in the Profile screen (to show/hide shield icon)
  - Once in the Admin screen itself (to prevent direct URL access)
- **Firestore rules enforce admin-only access** to the verifications collection for reading all users' data

## Testing

After adding yourself as admin:
```dart
// In Flutter DevTools console:
AdminRepository().isCurrentUserAdmin(); // Should return true
```

## Revoking Admin Access

To remove admin privileges:
1. Go to Firebase Console → Firestore
2. Navigate to `admins/{userId}`
3. Either:
   - Delete the document entirely, OR
   - Set `isAdmin` to `false`
4. User must restart app for changes to take effect

## Current Admin(s)

Add your email here after setup:
- [Your email]: [Your User ID] - Owner/Primary Admin

---

**Note**: Always keep at least one admin with access! If you lose admin access, you'll need Firebase Console access to restore it.
