import { admin, db } from "../config/firebase.js";

const deductHoofcoins = async ({
    riderId,
    hoofcoins,
    bookingId,
    discountAmount,
}) => {
    // Deduct coins
    await db
        .collection("riders")
        .doc(riderId)
        .update({
            hoofcoins: admin.firestore.FieldValue.increment(-hoofcoins),
        });

    // Log transaction
    await db.collection("hoofcoin_transactions").add({
        riderId,
        type: "discount_redemption",
        amount: -hoofcoins,
        bookingId,
        discountAmount,
        createdAt: new Date(),
    });

    return { message: "HoofCoins deducted successfully" };
};

const returnHoofcoins = async ({ riderId, hoofcoins, bookingId }) => {
    // Return coins
    await db
        .collection("riders")
        .doc(riderId)
        .update({
            hoofcoins: admin.firestore.FieldValue.increment(hoofcoins),
        });

    // Log transaction
    await db.collection("hoofcoin_transactions").add({
        riderId,
        type: "discount_return",
        amount: hoofcoins,
        bookingId,
        createdAt: new Date(),
    });

    return { message: "HoofCoins returned successfully" };
};

export default { deductHoofcoins, returnHoofcoins };
