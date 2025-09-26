import { db } from "../config/firebase.js";

export async function addReview({
    bookingId,
    horseRating,
    guideRating,
    reviewText,
}) {
    const bookingSnap = await db.collection("bookings").doc(bookingId).get();
    if (!bookingSnap.exists) throw new Error("Booking not found");

    const bookingData = bookingSnap.data();
    const { uid, guideId, rideId } = bookingData;

    const guideSnap = await db.collection("guides").doc(guideId).get();
    if (!guideSnap.exists) throw new Error("Guide not found");

    const { horseId } = guideSnap.data();

    const reviewRef = db.collection("reviews").doc();
    const reviewData = {
        bookingId,
        uid,
        guideId,
        horseId,
        rideId,
        reviewText: reviewText || "",
        guideRating,
        createdAt: new Date().toISOString(),
    };

    await reviewRef.set(reviewData);

    await updateAverageRating("guides", guideId, guideRating);
    await updateAverageRating("horses", horseId, horseRating);

    return { id: reviewRef.id, ...reviewData };
}

export async function getReviewsByGuideIdService(guideId) {
    const reviewSnap = await db
        .collection("reviews")
        .where("guideId", "==", guideId)
        .get();

    if (reviewSnap.empty) {
        throw new Error("No reviews found for this guide");
    }

    const reviews = await Promise.all(
        reviewSnap.docs.map(async (doc) => {
            const data = doc.data();

            const riderSnap = await db.collection("riders").doc(data.uid).get();
            const riderData = riderSnap.exists
                ? riderSnap.data()
                : { name: "Unknown Rider" };

            return {
                id: doc.id,
                ...data,
                riderName: riderData.name,
            };
        })
    );

    const sortedReviews = reviews.sort(
        (a, b) => new Date(b.createdAt) - new Date(a.createdAt)
    );

    return sortedReviews;
}

async function updateAverageRating(collection, docId, newRating) {
    const ref = db.collection(collection).doc(docId);

    await db.runTransaction(async (t) => {
        const doc = await t.get(ref);

        if (!doc.exists) throw new Error(`${collection} doc not found`);

        const data = doc.data();
        const totalRatings = data.totalRatings || 0;
        const ratingSum = data.ratingSum || 0;

        const updatedTotal = totalRatings + 1;
        const updatedSum = ratingSum + newRating;
        const updatedAvg = updatedSum / updatedTotal;

        t.update(ref, {
            totalRatings: updatedTotal,
            ratingSum: updatedSum,
            averageRating: updatedAvg,
        });
    });
}
