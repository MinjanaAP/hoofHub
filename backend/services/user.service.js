import { db } from "../config/firebase.js";

const saveUserRole = async (userData) => {
    try {
        const userRef = await db.collection("users").add(userData);
        return userRef.id;
    } catch (error) {
        throw new Error("Error saving user role: " + error.message);
    }
};

const getUserRoleByUid = async (uid) => {
    try {
        const userQuery = await db
            .collection("users")
            .where("uid", "==", uid)
            .limit(1)
            .get();

        if (userQuery.empty) {
            return null;
        }

        const userDoc = userQuery.docs[0];
        return userDoc.data().role;
    } catch (error) {
        throw new Error("Error fetching user role: " + error.message);
    }
};

export default {
    saveUserRole,
    getUserRoleByUid,
};
