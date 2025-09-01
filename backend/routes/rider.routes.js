import express from "express";
import authMiddleware from "../middleware/authMiddleware.js";
import { getAllRiders, getUserProfile, registerRider } from "../controllers/rider.controller.js";


const router = express.Router();

router.post("/register", registerRider);
router.get("/profile", authMiddleware, getUserProfile);
router.get("/", getAllRiders);



// module.exports = router;
export default router;