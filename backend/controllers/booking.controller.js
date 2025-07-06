import Booking from "../models/booking.model.js";
import { createBookingService, getBookingByIdService, getAllBookingsService, updateBookingService, deleteBookingService, getBookingsByGuideIdService, getBookingsByRideIdService, getBookingsByUidService } from "../services/booking.service.js";

export async function createBooking(req, res) {
    try {
        const booking = new Booking(req.body);
        const result = await createBookingService(booking.toFireStore());
        res.status(201).json(result);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
}

export async function getBookingById(req, res) {
    try {
        const { id } = req.params;
        const result = await getBookingByIdService(id);
        if (!result) {
            return res.status(404).json({ error: "Booking not found" });
        }
        res.json(result);
    } catch (error) {
        console.error("Error fetching booking by ID:", error);
        res.status(500).json({ error: "Internal server error" });
    }
}

export async function getAllBookings(_req, res) {
    try {
        const result = await getAllBookingsService();
        res.json(result);
    } catch (error) {
        console.error("Error fetching all bookings:", error);
        res.status(500).json({ error: "Internal server error" });
    }
}

export async function updateBooking(req, res) {
    try {
        const { id } = req.params;
        const result = await updateBookingService(id, req.body);
        res.json(result);
    } catch (error) {
        console.error("Error updating booking:", error);
        res.status(500).json({ error: "Internal server error" });
    }
}

export async function deleteBooking(req, res) {
    try {
        const { id } = req.params;
        const result = await deleteBookingService(id);
        res.json(result);
    } catch (error) {
        console.error("Error deleting booking:", error);
        res.status(500).json({ error: "Internal server error" });
    }
}

export async function getByGuideId(req, res) {
    try {
        const result = await getBookingsByGuideIdService(req.params.guideId);
        res.json(result);
    } catch (error) {
        console.error("Error fetching bookings by guide ID:", error);
        res.status(500).json({ error: "Internal server error ", message: error.message });
    }
}

export async function getByRideId(req, res) {
    try {
        const result = await getBookingsByRideIdService(req.params.rideId);
        res.json(result);
    } catch (error) {
        console.error("Error fetching bookings by ride ID:", error);
        res.status(500).json({ error: "Internal server error" });
    }
}

export async function getByUid(req, res) {
    try {
        const result = await getBookingsByUidService(req.params.uid);
        res.json(result);
    } catch (error) {
        console.error("Error fetching bookings by UID:", error);
        res.status(500).json({ error: "Internal server error" });
    }
}
