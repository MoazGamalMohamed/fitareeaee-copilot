# Firestore Indexes

[`firestore.indexes.json`](../firestore.indexes.json) is the authoritative index
manifest for shipped queries. It currently covers:

- rider bookings ordered by creation time;
- user notifications ordered by creation time;
- a participant's messages ordered by creation time;
- messages in one authorized conversation ordered by creation time.

The removed payment prototype has no index or deployable judge path.

After confirming the Firebase project is exactly `fitareeaee`, deploy with:

```bash
firebase deploy --only firestore:indexes --project fitareeaee
```

Rules-emulator tests run independently of index creation. A live deployed query
that reports `failed-precondition` must be compared against the checked-in
manifest; do not follow or deploy an unexpected index link blindly.
