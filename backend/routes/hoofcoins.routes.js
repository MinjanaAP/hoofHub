import { Router } from "express";
import hoofcoinsController from "../controllers/hoofcoins.controller.js";
const router = Router();


// Deduct HoofCoins
router.post("/deduct-hoofcoins", hoofcoinsController.deductHoofcoins);

// Return HoofCoins
router.post("/return-hoofcoins", hoofcoinsController.returnHoofcoins);

export default router;
