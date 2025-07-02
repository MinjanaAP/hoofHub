import { auth, db } from "../config/firebase.js";

const createAdmin = async ({ firstName, lastName, email, password }) => {
    // Create user in Firebase Auth
    const userRecord = await auth.createUser({
        email,
        password,
        displayName: `${firstName} ${lastName}`,
    });

    const uid = userRecord.uid;

    // Save additional data in Firestore
    const adminData = {
        uid,
        email,
        firstName,
        lastName,
        role: "admin",
        status: "PENDING",
        createdAt: new Date(),
    };

    await db.collection("admins").doc(uid).set(adminData);

    return { uid };
};

export default {
    createAdmin,
};
