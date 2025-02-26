const admin = require("firebase-admin");
const dotenv = require("dotenv");

dotenv.config();

admin.initializeApp({
    credential :admin.credential.cert({
        projectId: process.env.FIREBASE_PROJECT_ID,
        private_key: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, "\n"),
        client_email: process.env.FIREBASE_CLIENT_EMAIL,
    }),
    databaseURL: "https://hoofhub-70999.firebaseio.com"
});

const db = admin.firestore();
const auth = admin.auth();

module.exports = { db, auth };