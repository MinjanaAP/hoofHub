import express from 'express';
import { checkUserRole, saveFCMToken } from '../controllers/user.controller.js';


const router = express.Router();

router.get('/role/:uid', checkUserRole);
router.post('/fcm-token', saveFCMToken);

export default router;
