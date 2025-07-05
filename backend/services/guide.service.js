import { db } from "../config/firebase.js";
import horseService from "./horse.service.js";
import saveHorseToFirestore from "./horse.service.js";
import userService from "./user.service.js";
import saveUserRole from "./user.service.js";
import admin from 'firebase-admin';

export const saveGuideToFirestore = async (uid, guideData) => {
    try {
        const guideRef = db.collection("guides").doc(uid);
        await guideRef.set({
            ...guideData,
            createdAt: new Date().toISOString(),
        });
        return { success: true };
    } catch (error) {
        throw new Error("Error saving guide: " + error.message);
    }
};

export const createGuideWithHorse = async (uid, guideData, horseData) => {
    const horseId = await horseService.createHorse(horseData);
    guideData.horseId = horseId;
    const userData = {
        uid: uid,
        role:'guide'
    }
    const roleId = await userService.saveUserRole(userData);
    guideData.roleId = roleId;
    try {
        const guideRef = db.collection("guides").doc(uid);
        await guideRef.set({
            ...guideData,
            createdAt: new Date().toISOString(),
        });

        const rideId = guideData.rideId; // make sure this exists
        const rideRef = db.collection("rides").doc(rideId);
        await rideRef.update({
            guideIds: admin.firestore.FieldValue.arrayUnion(uid)
        });


        return { success: true };
    } catch (error) {
        throw new Error("Error saving guide: " + error.message);
    }
};

const getGuideById = async (uid) => {
    const doc = await db.collection("guides").doc(uid).get();
    if (!doc.exists) {
        throw new Error("Guide not found");
    }

    const guide = doc.data();
    const horse = await db.collection("horses").doc(guide.horseId).get();
    return { id: doc.id, ...guide, horse: horse.exists ? horse.data() : null };
};

const getAllGuides = async () => {
    const snapshot = await db.collection("guides").get();
    const guides = [];

    for (const doc of snapshot.docs) {
        const guide = doc.data();
        const horse = await db.collection("horses").doc(guide.horseId).get();
        guides.push({
            id: doc.id,
            ...guide,
            horse: horse.exists ? horse.data() : null,
        });
    }
    return guides;
};

const updateGuide = async (id, updatedData) => {
    await db.collection("guides").doc(id).update(updatedData);
    return { id, ...updatedData };
};

const deleteGuide = async (id) => {
    const guideDoc = await db.collection("guides").doc(id).get();
    if (!guideDoc.exists) throw new Error("Guide not found");
    const guide = guideDoc.data();

    // Delete horse
    await db.collection("horses").doc(guide.horseId).delete();
    await db.collection("guides").doc(id).delete();
};

const getGuidesByRideId = async (rideId) => {
    const rideDoc = await db.collection('rides').doc(rideId).get();

    if (!rideDoc.exists) {
        throw new Error("Ride not found");
    }

    const rideData = rideDoc.data();
    const guideIds = rideData.guideIds || [];

    const guidePromises = guideIds.map(async (uid) => {
        const guideDoc = await db.collection('guides').doc(uid).get();
        if (!guideDoc.exists) return null;

        const guideData = guideDoc.data();

        // Fetch the horse details
        const horseDoc = await db.collection('horses').doc(guideData.horseId).get();

        return {
            id: guideDoc.id,
            ...guideData,
            horse: horseDoc.exists ? horseDoc.data() : null
        };
    });

    const guides = await Promise.all(guidePromises);

    // Filter out any nulls (nonexistent guides)
    return guides.filter(g => g !== null);
};


export default  {
    deleteGuide,
    getAllGuides,
    getGuideById,
    updateGuide,
    getGuidesByRideId
}