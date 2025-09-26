import { Router } from 'express';
const router = Router();
import { addReviews, getReviewsByGuideId } from '../controllers/review.controller.js';

router.post('/', addReviews);
router.get('/for-guide/:guideId', getReviewsByGuideId);

export default router;
