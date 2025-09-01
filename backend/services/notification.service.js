import { db } from "../config/firebase.js";
import sendNotification from "../utils/sendNotification.js";

export const sendPaymentNotificationService = async ({
    riderId,
    guideId,
    riderTitle,
    riderDescription,
    guideTitle,
    guideDescription,
}) => {
    try {
        const riderDoc = await db.collection("riders").doc(riderId).get();
        if (!riderDoc.exists) throw new Error("Ride not found");
        const riderData = riderDoc.data();
        const riderFcmToken = riderData?.fcmToken;

        const guideDoc = await db.collection("guides").doc(guideId).get();
        if (!guideDoc.exists) throw new Error("Guide not found");
        const guideData = guideDoc.data();
        const guideFcmToken = guideData?.fcmToken;

        const results = {};

        if (riderFcmToken) {
            results.rider = await sendNotification(
                riderFcmToken,
                riderTitle,
                riderDescription,
                { riderId }
            );
        } 

        if (guideFcmToken) {
            results.guide = await sendNotification(
                guideFcmToken,
                guideTitle,
                guideDescription,
                { riderId, guideId }
            );
        }

        return results;
    } catch (error) {
        console.error("Error in sendPaymentNotificationService:", error);
        throw error;
    }
};

export const sendNotificationToUserByRole = async (userId, role, title, body, data, route) => {
    try {
        const userDoc = await db.collection(role + "s").doc(userId).get();
        if (!userDoc.exists) throw new Error(role + " not found");
        const userData = userDoc.data();
        const fcmToken = userData?.fcmToken;
        console.log(
            `Sending notification to ${role} (ID: ${userId}) with token: ${fcmToken} ${title} - ${body}-${JSON.stringify(data)}`
        );
        // const route = '/riderStartingRidePage'
        if (fcmToken) {
            const result = await sendNotification(
                fcmToken,
                title,
                body,
                { ...data, userId, role, route }
            );
            return result;
        }
    } catch (error) {
        console.error("Error in send notifications to user by role:", error);
        throw error;
    }
}