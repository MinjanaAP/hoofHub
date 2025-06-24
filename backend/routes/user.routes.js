import express from 'express';
import { checkUserRole } from '../controllers/user.controller.js';


const router = express.Router();

router.get('/role/:uid', checkUserRole);

export default router;
