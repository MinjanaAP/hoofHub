
import { Router } from "express";
import PaymentController from "../controllers/payment.controller.js";
const router = Router();

router.post("/create-payment-intent", PaymentController.createPaymentIntent);

export default router;
