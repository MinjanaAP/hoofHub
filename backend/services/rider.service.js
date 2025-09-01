import { db } from "../config/firebase.js";


const getAllRiders = async () => {
    console.log("awaaa");
    try {
        const snapshot = await db.collection("riders").get();
        const riders = [];

        snapshot.forEach((doc) => {
            riders.push({ id: doc.id, ...doc.data() });
        });

        return riders;
    } catch (error) {
        console.error("Error fetching riders:", error);
        throw error;
    }
};


export default {
    getAllRiders
}