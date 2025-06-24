import { db } from '../config/firebase.js';

async function saveHorseToFirestore(horseData) {
  const horseRef = await db.collection('horses').add(horseData);
  return horseRef.id;
}

export default saveHorseToFirestore;
