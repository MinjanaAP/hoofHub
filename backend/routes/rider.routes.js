const express = require("express");
const authMiddleware = require("../middleware/authMiddleware.js");
const riderController = require("../controllers/rider.controller.js");


const router = express.Router();

router.post("/register", riderController.registerRider);
router.get("/profile", authMiddleware, riderController.getUserProfile);



module.exports = router;