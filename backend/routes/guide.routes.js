import express from "express";
import upload from "../utils/mutler.js"
import guideController, { registerGuide } from "../controllers/guide.controller.js";

const router = express.Router();

router.post("/register", 
    upload.fields([
    { name: 'profileImage', maxCount: 1 },
    { name: 'horseImages', maxCount: 5 },
    ]), 
    registerGuide
);

router.get('/', guideController.getAllGuides);
router.get('/:id', guideController.getGuideById);
router.put('/:id', guideController.updateGuide);
router.delete('/:id', guideController.deleteGuide);


export default router;
