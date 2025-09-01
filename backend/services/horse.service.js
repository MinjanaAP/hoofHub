import { db } from '../config/firebase.js';

// Create
async function createHorse(horseData) {
  const horseRef = await db.collection('horses').add(horseData);
  return horseRef.id;
}

// Read all
async function getAllHorses() {
  const snapshot = await db.collection('horses').get();
  const horses = await Promise.all(snapshot.docs.map(async doc => {
    const horse = { id: doc.id, ...doc.data() };
    let owner = null;
    if (horse.ownerId) {
      const ownerDoc = await db.collection('guides').doc(horse.ownerId).get();
      if (ownerDoc.exists) {
        owner = { id: ownerDoc.id, ...ownerDoc.data() };
      }
    }
    return { ...horse, owner };
  }));
  return horses;
}

// Read by ID
async function getHorseById(horseId) {
  const doc = await db.collection('horses').doc(horseId).get();
  if (!doc.exists) return null;
  const horse = { id: doc.id, ...doc.data() };
  let owner = null;
  if (horse.ownerId) {
    const ownerDoc = await db.collection('guides').doc(horse.ownerId).get();
    if (ownerDoc.exists) {
      owner = { id: ownerDoc.id, ...ownerDoc.data() };
    }
  }
  return { ...horse, owner };
}

// Update
async function updateHorse(horseId, updateData) {
  await db.collection('horses').doc(horseId).update(updateData);
  return true;
}

// Delete
async function deleteHorse(horseId) {
  await db.collection('horses').doc(horseId).delete();
  return true;
}

export default {
  createHorse,
  getAllHorses,
  getHorseById,
  updateHorse,
  deleteHorse
};
