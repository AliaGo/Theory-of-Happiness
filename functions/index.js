const { initializeApp } = require("firebase-admin/app");
const { FieldValue, getFirestore } = require("firebase-admin/firestore");
const { onDocumentWritten } = require("firebase-functions/v2/firestore");
const { logger } = require("firebase-functions");

initializeApp();

const db = getFirestore();

function validRating(value) {
  return typeof value === "number" && Number.isInteger(value) && value >= 1 && value <= 5;
}

async function rebuildCastleStats(castleId) {
  const visits = await db
    .collectionGroup("castle_visits")
    .where("castleId", "==", castleId)
    .get();

  let recommendationTotal = 0;
  let recommendationCount = 0;
  let difficultyTotal = 0;
  let difficultyCount = 0;

  visits.forEach((visit) => {
    const data = visit.data();

    if (validRating(data.recommendationRating)) {
      recommendationTotal += data.recommendationRating;
      recommendationCount += 1;
    }

    if (validRating(data.difficultyRating)) {
      difficultyTotal += data.difficultyRating;
      difficultyCount += 1;
    }
  });

  await db.collection("castle_stats").doc(String(castleId)).set(
    {
      castleId,
      visitCount: visits.size,
      recommendationAverage: recommendationCount
        ? Math.round((recommendationTotal / recommendationCount) * 10) / 10
        : null,
      recommendationCount,
      difficultyAverage: difficultyCount
        ? Math.round((difficultyTotal / difficultyCount) * 10) / 10
        : null,
      difficultyCount,
      updatedAt: FieldValue.serverTimestamp()
    },
    { merge: true }
  );
}

// A visit can be created, edited, or deleted. Rebuild both castles if an edit
// ever changes its castleId, so the public totals cannot become stale.
exports.syncCastleStats = onDocumentWritten(
  "users/{userId}/castle_visits/{visitId}",
  async (event) => {
    const previous = event.data?.before.exists ? event.data.before.data() : null;
    const current = event.data?.after.exists ? event.data.after.data() : null;
    const castleIds = new Set(
      [previous?.castleId, current?.castleId].filter((id) => Number.isInteger(id))
    );

    await Promise.all([...castleIds].map(rebuildCastleStats));
    logger.info("Castle statistics updated", {
      castleIds: [...castleIds],
      userId: event.params.userId
    });
  }
);
