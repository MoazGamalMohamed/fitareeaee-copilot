# Firestore Composite Indexes Guide

## Overview

This document explains the Firestore composite indexes required by this application and how to deploy them.

## What are Composite Indexes?

Firestore automatically creates single-field indexes, but when you query with:
- Multiple `where()` clauses on different fields, OR
- A `where()` clause combined with `orderBy()` on a different field

...you need a **composite index** that spans multiple fields.

## Required Indexes

This app requires the following composite indexes:

### 1. Bookings Collection
**Used by:** Matches tab to show user's agreed deals
**Query:** 
```dart
.collection('bookings')
.where('passengerId', isEqualTo: userId)
.orderBy('createdAt', descending: true)
```
**Index fields:**
- `passengerId` (ASCENDING)
- `createdAt` (DESCENDING)

### 2. Notifications Collection
**Used by:** Notifications screen
**Query:**
```dart
.collection('notifications')
.where('userId', isEqualTo: user.uid)
.orderBy('createdAt', descending: true)
```
**Index fields:**
- `userId` (ASCENDING)
- `createdAt` (DESCENDING)

### 3. Payments Collection
**Used by:** Payment history screen
**Query:**
```dart
.collection('payments')
.where('payerId', isEqualTo: userId)
.orderBy('createdAt', descending: true)
```
**Index fields:**
- `payerId` (ASCENDING)
- `createdAt` (DESCENDING)

## How to Deploy Indexes

### Option 1: Using Firebase CLI (Recommended)

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```

3. **Deploy the indexes**:
   ```bash
   firebase deploy --only firestore:indexes
   ```

This will read the `firestore.indexes.json` file in the project root and create all indexes defined there.

### Option 2: Using Firebase Console

If you see an error like:
```
[cloud_firestore/failed-precondition] The query requires an index. 
You can create it here: https://console.firebase.google.com/...
```

1. Click the URL in the error message
2. It will open Firebase Console with pre-filled index configuration
3. Click **"Create Index"**
4. Wait for the index to build (usually takes a few minutes)

### Option 3: Manual Creation in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Firestore Database** → **Indexes** tab
4. Click **"Create Index"**
5. Fill in the details:
   - **Collection ID:** (e.g., `bookings`)
   - **Fields to index:** Add each field with its sort order
   - **Query scope:** Collection
6. Click **"Create"**

## Checking Index Status

After deploying, you can check the status in Firebase Console:
1. Go to **Firestore Database** → **Indexes**
2. You'll see all indexes with their status:
   - 🟢 **Enabled** - Ready to use
   - 🟡 **Building** - In progress (wait a few minutes)
   - 🔴 **Error** - Check configuration

## Troubleshooting

### "Index already exists" error
This means the index is already deployed. No action needed.

### "Building" status for a long time
Large collections can take 15-30 minutes to index. Be patient.

### Query still failing after index deployment
- Clear your browser cache/restart the app
- Check that the index fields EXACTLY match the query
- Verify the sort order (ASCENDING vs DESCENDING)

### Need to update an index
You cannot modify an existing index. Instead:
1. Delete the old index in Firebase Console
2. Update `firestore.indexes.json`
3. Run `firebase deploy --only firestore:indexes`

## Index Definitions File

All indexes are defined in `firestore.indexes.json` at the project root. This file is used by Firebase CLI for automated deployment.

Example structure:
```json
{
  "indexes": [
    {
      "collectionGroup": "bookings",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "passengerId", "order": "ASCENDING" },
        { "fieldPath": "createdAt", "order": "DESCENDING" }
      ]
    }
  ]
}
```

## Best Practices

1. **Version Control:** Always commit `firestore.indexes.json` to Git
2. **Deploy Early:** Create indexes in development before production
3. **Monitor Usage:** Check Firebase Console for unused indexes
4. **Document Changes:** Update this file when adding new complex queries
5. **Test Locally:** Use Firebase Emulator for testing before deploying

## Related Files

- `firestore.indexes.json` - Index definitions
- `lib/features/booking/presentation/providers/booking_provider.dart` - Bookings query
- `lib/features/notifications/presentation/providers/notification_provider.dart` - Notifications query
- `lib/features/payment/presentation/providers/payment_provider.dart` - Payments query

## Need Help?

If you encounter issues:
1. Check Firebase Console for error messages
2. Review the specific query in the code (see comments marked "COMPOSITE INDEX REQUIRED")
3. Verify `firestore.indexes.json` matches your query
4. Contact the backend team for assistance
