import { db } from "../config/firebase.js";
import userService from "../services/user.service.js";
import sendNotification from "../utils/sendNotification.js";

export const checkUserRole = async (req, res) => {
    const { uid } = req.params;

    if (!uid) {
        return res
            .status(400)
            .json({ status: false, message: "User ID is required" });
    }

    try {
        const role = await userService.getUserRoleByUid(uid);

        if (!role) {
            return res.status(404).json({ status: false, message: "User not found" });
        }

        return res.status(200).json({ status: true, role });
    } catch (error) {
        return res.status(500).json({ status: false, message: error.message });
    }
};

export const saveFCMToken = async (req, res) => {
    const { uid, fcmToken, role } = req.body;
    try {
        const collection = role === "guide" ? "guides" : "riders";
        await db.collection(collection).doc(uid).update({ fcmToken });
        res.json({ success: true, statusCode :200 });
    } catch (err) {
        res.status(500).json({ error: "Failed to save FCM token : ", message: err.message });
    }
};

export const testNotifications = async (req, res) => {
    const { uid, role, title,description } = req.body;
    try {
        const collection = role === "guide" ? "guides" : "riders";
        const userDoc = await db.collection(collection).doc(uid).get();
        const user = userDoc.data();

        if (user?.fcmToken) {
            await sendNotification(
                user.fcmToken,
                title,
                description
            );
        }

        res.json({ success: true, statusCode :200, message: `Notification send to ${user.uid}` });
    } catch (err) {
        res.status(500).json({ error: "Failed to save FCM token : ", message: err.message });
    }

}


