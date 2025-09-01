import { sendNotificationToUserByRole, sendPaymentNotificationService } from "../services/notification.service.js";


export const sendPaymentNotificationController = async (req, res) => {
    try {
        const { riderId, guideId, riderTitle, riderDescription, guideTitle, guideDescription } = req.body;
        console.log("Notification request body : ", req.body);

        if (!riderId || !guideId || !riderTitle || !riderDescription || !guideTitle || !guideDescription) {
            return res.status(400).json({ success: false, error: "Missing required parameters" });
        }

        const result = await sendPaymentNotificationService({
            riderId,
            guideId,
            riderTitle,
            riderDescription,
            guideTitle,
            guideDescription
        });

        return res.status(200).json({ success: true, message: "Notifications sent successfully", result });
    } catch (error) {
        console.error("Error in sendPaymentNotificationController:", error);
        return res.status(500).json({ success: false, error: "Failed to send notifications" });
    }
};

export const sendNotificationToUserByRoleController = async (req, res) => {
    try {
        const { userId, role, title, body, data, route } = req.body;
        if (!userId || !role || !title || !body) {
            return res.status(400).json({ success: false, error: "Missing required parameters" });
        }

        const result = await sendNotificationToUserByRole(userId, role, title, body, data, route);
        return res.status(200).json({ success: true, message: "Notification sent successfully", result });
    } catch (error) {
        console.error("Error in sendNotificationToUserByRoleController:", error);
        return res.status(500).json({ success: false, error: "Failed to send notifications" });
    }
}