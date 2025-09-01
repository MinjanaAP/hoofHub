import { Router } from 'express';
const router = Router();
import { addReviews } from '../controllers/review.controller.js';

router.post('/', addReviews);

export default router;
