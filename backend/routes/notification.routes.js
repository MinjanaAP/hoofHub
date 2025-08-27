import express from "express";
import { sendPaymentNotificationController } from "../controllers/notification.controller.js";


const router = express.Router();

router.post("/notify-payment-success", sendPaymentNotificationController); 

export default router;
