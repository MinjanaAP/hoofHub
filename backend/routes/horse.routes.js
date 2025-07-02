import express from 'express';
import { createHorse, getAllHorses, getHorseById, updateHorse, deleteHorse } from '../controllers/horse.controller.js';

const router = express.Router();

router.post('/', createHorse); // Create
router.get('/', getAllHorses); // Read all
router.get('/:id', getHorseById); // Read by id
router.put('/:id', updateHorse); // Update
router.delete('/:id', deleteHorse); // Delete

export default router; 