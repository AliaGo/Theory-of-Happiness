# TOH Firebase Functions

`syncCastleStats` keeps the public `castle_stats/{castleId}` documents in sync
with users' private `castle_visits` records.

## First deployment

1. Install the Firebase CLI: `npm install -g firebase-tools`
2. From the repository root, sign in: `firebase login`
3. Select the Firebase project: `firebase use --add`
4. Install the function dependencies: `cd functions && npm install`
5. Return to the repository root and deploy: `firebase deploy --only functions:syncCastleStats`

The function uses the Firebase Admin SDK, so it can write the aggregate document
while clients remain read-only.
