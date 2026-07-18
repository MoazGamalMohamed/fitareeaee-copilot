# Firestore Index Setup - Quick Start

## 🚨 IMPORTANT: Required Before Running the App

This app requires Firestore composite indexes to function properly. Without them, features like **Matches**, **Notifications**, and **Payment History** will not work.

## Quick Setup (2 minutes)

### Step 1: Install Firebase CLI
```bash
npm install -g firebase-tools
```

### Step 2: Login to Firebase
```bash
firebase login
```

### Step 3: Deploy Indexes
```bash
cd "c:\Users\moaaz\New Project\fitareeaee"
firebase deploy --only firestore:indexes
```

**That's it!** Firebase will create all required indexes automatically.

## ⏱️ Wait Time

After deployment, indexes need to build:
- **Small databases:** 2-5 minutes
- **Large databases:** 15-30 minutes

Check status at: Firebase Console → Firestore Database → Indexes tab

## 🐛 If You See an Error

When you open the **Matches** tab and see:
```
[cloud_firestore/failed-precondition] The query requires an index.
```

**Option A:** Click the URL in the error message and click "Create Index" in Firebase Console

**Option B:** Run the deployment command above

## ✅ Verify Setup

1. Open the app in Chrome
2. Sign in with a test account
3. Go to **Trips** → **Matches** tab
4. Should see "No matching trips found" instead of an error
5. Create a test trip and booking to verify

## 📚 Detailed Documentation

See `docs/FIRESTORE_INDEXES.md` for:
- Complete list of required indexes
- Troubleshooting guide
- Manual setup instructions
- Best practices

## 🔍 Which Features Need Indexes?

| Feature | Collection | Why |
|---------|-----------|-----|
| Matches Tab | `bookings` | Query by user + sort by date |
| Notifications | `notifications` | Query by user + sort by date |
| Payment History | `payments` | Query by user + sort by date |

## 🆘 Need Help?

If deployment fails or indexes don't build:
1. Check Firebase Console for error messages
2. Verify you have **Editor** or **Owner** role in Firebase project
3. Ensure `firestore.indexes.json` exists in project root
4. Contact the development team

---

**Next Steps:** After deploying indexes, proceed with normal app development and testing.
