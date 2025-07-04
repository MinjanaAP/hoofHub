import ridesService from "../services/rides.service.js";
import uploadToCloudinary from "../utils/cloudinaryUpload.js";
import { v4 as uuidv4 } from 'uuid';

export async function createRide(req, res) {
    try {
        const rideData = JSON.parse(req.body.rideData); // assuming rideData sent as JSON string
        const rideImages = req.files["ridesImage"] || [];

        const imageUrls = [];

        for (const file of rideImages) {
            const url = await uploadToCloudinary(file.buffer, "rides");
            imageUrls.push(url);
        }

        const rideId = uuidv4();
        const newRide = await ridesService.createRideService(
            rideId,
            rideData,
            imageUrls
        );

        res.status(201).json(newRide);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Failed to create ride: " + err.message+ err });
    }
}

export async function getAllRides(_, res) {
    try {
        const rides = await ridesService.getAllRidesService();
        res.json(rides);
    } catch {
        res.status(500).json({ error: "Failed to fetch rides" });
    }
}

export async function getRideById(req, res) {
    try {
        const ride = await ridesService.getRideByIdService(req.params.id);
        if (!ride) return res.status(404).json({ error: "Not found" });
        res.json(ride);
    } catch {
        res.status(500).json({ error: "Failed to fetch ride" });
    }
}

export async function updateRide(req, res) {
    try {
        const data = JSON.parse(req.body.rideData);
        const rideImages = req.files["ridesImage"] || [];

        const imageUrls = [];

        for (const file of rideImages) {
            const url = await uploadToCloudinary(file.buffer, "rides");
            imageUrls.push(url);
        }

        const updated = await ridesService.updateRideService(
            req.params.id,
            data,
            imageUrls
        );
        res.json(updated);
    } catch {
        res.status(500).json({ error: "Failed to update ride" });
    }
}

export async function deleteRide(req, res) {
    try {
        await ridesService.deleteRideService(req.params.id);
        res.status(204).send();
    } catch {
        res.status(500).json({ error: "Failed to delete ride" });
    }
}

export const getTopRides = async (req, res) => {
  try {
    const rides = await ridesService.getTopRatedRides(3); 
    res.status(200).json({ status: true, data: rides });
  } catch (error) {
    res.status(500).json({ status: false, message: error.message });
  }
};