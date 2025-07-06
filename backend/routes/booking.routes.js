import { Router } from "express";
const router = Router();
import { createBooking, getAllBookings, getBookingById, updateBooking, deleteBooking, getByGuideId, getByRideId, getByUid } from "../controllers/booking.controller.js";

router.post("/", createBooking);
router.get("/", getAllBookings);
router.get("/:id", getBookingById);
router.put("/:id", updateBooking);
router.delete("/:id", deleteBooking);

router.get("/guide/:guideId", getByGuideId);
router.get("/ride/:rideId", getByRideId);
router.get("/user/:uid", getByUid);

export default router;
