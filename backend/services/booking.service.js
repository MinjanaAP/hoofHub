import { db } from "../config/firebase.js";
import sendNotification from "../utils/sendNotification.js";

const collection = db.collection("bookings");

export async function createBookingService(data) {
    try {
        if (!data || typeof data !== 'object') {
            throw new Error("Invalid booking data");
        }

        const newBookingRef = collection.doc();
        await newBookingRef.set(data);

        const guideDoc = await db.collection("guides").doc(data.guideId).get();
        const guide = guideDoc.data();

        if (guide?.fcmToken) {
            await sendNotification(
                guide.fcmToken,
                "New Booking Received",
                `You have a new booking on ${data.selectedDate} at ${data.selectedTime}.`,
                { bookingId: newBookingRef.id }
            );
        }

        return { id: newBookingRef.id, ...data };
    } catch (error) {
        console.error("Error creating booking:", error);
        throw new Error("Failed to create booking");
    }
}

export async function getBookingByIdService(id) {
    try {
        if (!id) throw new Error("Booking ID is required");

        const doc = await collection.doc(id).get();
        if (!doc.exists) return null;

        return { id: doc.id, ...doc.data() };
    } catch (error) {
        console.error("Error fetching booking by ID:", error);
        throw new Error("Failed to fetch booking by ID");
    }
}

export async function getAllBookingsService() {
    try {
        const snapshot = await collection.get();
        return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
    } catch (error) {
        console.error("Error fetching all bookings:", error);
        throw new Error("Failed to fetch all bookings");
    }
}

export async function updateBookingService(id, data) {
    try {
        if (!id || !data) {
            throw new Error("Booking ID and update data are required");
        }

        await collection.doc(id).update(data);
        return { id, ...data };
    } catch (error) {
        console.error("Error updating booking:", error);
        throw new Error("Failed to update booking");
    }
}

export async function deleteBookingService(id) {
    try {
        if (!id) throw new Error("Booking ID is required");

        await collection.doc(id).delete();
        return { id };
    } catch (error) {
        console.error("Error deleting booking:", error);
        throw new Error("Failed to delete booking");
    }
}

export async function getBookingsByGuideIdService(guideId) {
    try {
        if (!guideId) throw new Error("Guide ID is required");

        const guideDoc = await db.collection("guides").doc(guideId).get();
        if (!guideDoc.exists) {
            throw new Error("Guide not found");
        }

        const snapshot = await collection.where("guideId", "==", guideId).get();

        const bookingsWithRiderDetails = await Promise.all(
            snapshot.docs.map(async (doc) => {
                const bookingData = { id: doc.id, ...doc.data() };

                if (bookingData.uid) {
                    const riderDoc = await db.collection("riders").doc(bookingData.uid).get();
                    bookingData.rider = riderDoc.exists ? riderDoc.data() : null;
                } else {
                    bookingData.rider = null;
                }

                if (bookingData.rideId) {
                    const rideDoc = await db.collection("rides").doc(bookingData.rideId).get();
                    bookingData.ride = rideDoc.exists ? rideDoc.data() : null;
                } else {
                    bookingData.ride = null;
                }

                return bookingData;
            })
        );

        return bookingsWithRiderDetails;
    } catch (error) {
        console.error("Error fetching bookings by guide ID:", error);
        throw new Error("Failed to fetch bookings by guide ID");
    }
}

export async function getBookingsByRideIdService(rideId) {
    try {
        if (!rideId) throw new Error("Ride ID is required");

        const rideDoc = await db.collection("rides").doc(rideId).get();
        if (!rideDoc.exists) {
            throw new Error("Ride not found");
        }

        const snapshot = await collection.where("rideId", "==", rideId).get();

        const bookingsWithDetails = await Promise.all(
            snapshot.docs.map(async (doc) => {
                const booking = { id: doc.id, ...doc.data() };

                if (booking.uid) {
                    const riderDoc = await db.collection("riders").doc(booking.uid).get();
                    booking.rider = riderDoc.exists ? riderDoc.data() : null;
                } else {
                    booking.rider = null;
                }

                if (booking.guideId) {
                    const guideDoc = await db.collection("guides").doc(booking.guideId).get();
                    booking.guide = guideDoc.exists ? guideDoc.data() : null;
                } else {
                    booking.guide = null;
                }

                return booking;
            })
        );

        return bookingsWithDetails;
    } catch (error) {
        console.error("Error fetching bookings by ride ID:", error);
        throw new Error("Failed to fetch bookings by ride ID");
    }
}



export async function getBookingsByUidService(uid) {
    try {
        if (!uid) throw new Error("User ID is required");

        const userDoc = await db.collection("riders").doc(uid).get();
        if (!userDoc.exists) {
            throw new Error("User not found");
        }

        const snapshot = await collection.where("uid", "==", uid).get();

        const bookingsWithDetails = await Promise.all(
            snapshot.docs.map(async (doc) => {
                const booking = { id: doc.id, ...doc.data() };

                if (booking.guideId) {
                    const guideDoc = await db.collection("guides").doc(booking.guideId).get();
                    booking.guide = guideDoc.exists ? guideDoc.data() : null;
                } else {
                    booking.guide = null;
                }

                if (booking.rideId) {
                    const rideDoc = await db.collection("rides").doc(booking.rideId).get();
                    booking.ride = rideDoc.exists ? rideDoc.data() : null;
                } else {
                    booking.ride = null;
                }

                return booking;
            })
        );

        return bookingsWithDetails;
    } catch (error) {
        console.error("Error fetching bookings by user ID:", error);
        throw new Error("Failed to fetch bookings by user ID");
    }
}

