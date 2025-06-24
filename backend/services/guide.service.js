import { db } from "../config/firebase.js";
import saveHorseToFirestore from "./horse.service.js";

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
    const horseId = await saveHorseToFirestore(horseData);
    guideData.horseId = horseId;

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

export default  {
    deleteGuide,
    getAllGuides,
    getGuideById,
    updateGuide
}