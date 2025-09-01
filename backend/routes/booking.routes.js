import { Router } from "express";
const router = Router();
import { createBooking, getAllBookings, getBookingById, updateBooking, deleteBooking, getByGuideId, getByRideId, getByUid, getAllBookingsWithDetails, getBookingByIdWithDetails, storeQRCodeUrl, updateRideStatus } from "../controllers/booking.controller.js";
import { verifySecureQR } from "../controllers/qr.controller.js";

router.post("/", createBooking);
router.get("/details", getAllBookingsWithDetails);
router.get("/:id/details", getBookingByIdWithDetails);
router.get("/", getAllBookings);
router.get("/:id", getBookingById);
router.put("/:id", updateBooking);
router.delete("/:id", deleteBooking);

router.get("/guide/:guideId", getByGuideId);
router.get("/ride/:rideId", getByRideId);
router.get("/user/:uid", getByUid);
router.post("/save-qr/:id", storeQRCodeUrl );
router.post("/verify-qr", verifySecureQR);  
router.post("/change-ride-status/:id", updateRideStatus );

export default router;
