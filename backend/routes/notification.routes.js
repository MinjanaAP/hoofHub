import express from "express";
import { sendNotificationToUserByRoleController, sendPaymentNotificationController } from "../controllers/notification.controller.js";


const router = express.Router();

router.post("/notify-payment-success", sendPaymentNotificationController); 
router.post("/notify-user-by-role", sendNotificationToUserByRoleController);

export default router;
