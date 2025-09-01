import { db } from "../config/firebase.js";

// CREATE
export const createRideService = async (id, rideData, imageUrls) => {
    try {
        const rideRef = db.collection("rides").doc(id);

        const data = {
            ...rideData,
            price: parseFloat(rideData.price),
            rating: parseFloat(rideData.rating),
            reviews: parseInt(rideData.reviews),
            maxParticipants: parseInt(rideData.maxParticipants),
            images: imageUrls,
            createdAt: new Date().toISOString(),
        };

        await rideRef.set(data);
        return { id, ...data };
    } catch (error) {
        throw new Error("Error creating ride: " + error.message);
    }
};

// READ ALL
export const getAllRidesService = async () => {
    try {
        const snapshot = await db.collection("rides").get();
        const rides = snapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data(),
        }));
        return rides;
    } catch (error) {
        throw new Error("Error fetching rides: " + error.message);
    }
};

// READ ONE
export const getRideByIdService = async (id) => {
    try {
        const doc = await db.collection("rides").doc(id).get();
        if (!doc.exists) throw new Error("Ride not found");
        return { id: doc.id, ...doc.data() };
    } catch (error) {
        throw new Error("Error fetching ride: " + error.message);
    }
};

// UPDATE
export const updateRideService = async (id, updatedData, imageUrls = []) => {
    try {
        const data = {
            ...updatedData,
            images: imageUrls,
            updatedAt: new Date().toISOString(),
        };
        await db.collection("rides").doc(id).update(data);
        return { id, ...data };
    } catch (error) {
        throw new Error("Error updating ride: " + error.message);
    }
};

// DELETE
export const deleteRideService = async (id) => {
    try {
        await db.collection("rides").doc(id).delete();
        return { success: true };
    } catch (error) {
        throw new Error("Error deleting ride: " + error.message);
    }
};

export const getTopRatedRides = async (limit = 3) => {
    try {
        const snapshot = await db
            .collection("rides")
            .orderBy("rating", "desc")
            .limit(limit)
            .get();

        const rides = snapshot.docs.map((doc) => ({
            id: doc.id,
            ...doc.data(),
        }));

        return rides;
    } catch (error) {
        throw new Error("Failed to fetch top-rated rides: " + error.message);
    }
};

export default {
    createRideService,
    getAllRidesService,
    getRideByIdService,
    updateRideService,
    deleteRideService,
    getTopRatedRides,
};
