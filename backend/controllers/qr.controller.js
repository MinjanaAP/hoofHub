// controllers/qrController.js
import jwt from "jsonwebtoken";
import { db } from "../config/firebase.js";

export const verifySecureQR = async (req, res) => {
    try {
        const { token } = req.body;

        const decoded = jwt.verify(token, process.env.JWT_SECRET);

        const bookingRef = db.collection("bookings").doc(decoded.bookingId);
        const bookingDoc = await bookingRef.get();

        if (!bookingDoc.exists) {
            return res.status(404).json({ success: false, msg: "Invalid booking" });
        }

        const booking = bookingDoc.data();

        const rideRef = db.collection("rides").doc(booking.rideId);
        const rideDoc = await rideRef.get();

        const riderRef = db.collection("riders").doc(booking.uid);
        const riderDoc = await riderRef.get();

        const guideRef = db.collection("guides").doc(booking.guideId);
        const guideDoc = await guideRef.get();

        if (booking.rideStatus === "started") {
            return res.json({ success: false, msg: "Ride already started" });
        }

        await bookingRef.update({ rideStatus: "scanned" });

       

        return res.json({
            success: true,
            booking: { id: bookingDoc.id, ...booking, rideStatus: "scanned" },
            ride: { id: rideDoc.id, ...rideDoc.data() },
            rider: { id: riderDoc.id, ...riderDoc.data() },
            guide: { id: guideDoc.id, ...guideDoc.data() },
        });
    } catch (err) {
        console.error("QR verification error:", err);
        return res.status(401).json({ success: false, msg: "Invalid or expired QR" });
    }
};
