import { messaging } from "../config/firebase.js";

const sendNotification = async (token, title, body, data = {}) => {
    const message = {
        token,
        notification: {
            title,
            body,
            image: 'https://res.cloudinary.com/dtv1nvsx9/image/upload/v1750684416/logoColor_dzi3en.jpg'
        },
        android: {
            notification: {
                icon: 'ic_notification', // name of the file, no extension
                color: '#723594' // optional - sets accent color (your brand color)
            }
        },
        data,
    };

    try {
        await messaging.send(message);
        console.log("Push notification sent successfully");
    } catch (error) {
        console.error("Error sending push notification:", error);
    }
};

export default sendNotification;
