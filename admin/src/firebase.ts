// Firebase v9 modular SDK
import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyBIjGlOzK8MRIiFMwrMNZBDJ0nefjTbL6o",
  authDomain: "hoofhub-70999.firebaseapp.com",
  projectId: "hoofhub-70999",
  storageBucket: "hoofhub-70999.firebasestorage.app",
  messagingSenderId: "790831491577",
  appId: "1:790831491577:web:2db40ea41a6244c3f77528"
};

const app = initializeApp(firebaseConfig);

export const auth = getAuth(app);
export const db = getFirestore(app);
