import { Router } from "express";
import adminController from "../controllers/admin.controller.js";


const router = Router();

router.post("/signup", adminController.handleAdminSignup);

export default router;
