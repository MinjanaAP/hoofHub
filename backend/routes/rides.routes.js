import { Router } from "express";
import {
    createRide,
    getAllRides,
    getRideById,
    updateRide,
    deleteRide,
    getTopRides
} from "../controllers/rides.controller.js";
import upload from "../utils/mutler.js";

const router = Router();

router.post(
    "/",
    upload.fields([{ name: "ridesImage", maxCount: 5 }]),
    createRide
);

router.get("/", getAllRides);
router.get("/:id", getRideById);

router.put(
    "/:id",
    upload.fields([{ name: "ridesImage", maxCount: 5 }]),
    updateRide
);

router.delete("/:id", deleteRide);
router.get("/rating/top", getTopRides);

export default router;
