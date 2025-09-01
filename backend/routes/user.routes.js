import express from 'express';
import { checkUserRole, saveFCMToken, testNotifications } from '../controllers/user.controller.js';


const router = express.Router();

router.get('/role/:uid', checkUserRole);
router.post('/fcm-token', saveFCMToken);
router.post('/send-notifications', testNotifications);

export default router;
