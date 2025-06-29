import { auth, db } from "../config/firebase.js";
import Guide from "../models/guide.model.js";
import guideService, { createGuideWithHorse, saveGuideToFirestore } from "../services/guide.service.js";
import uploadToCloudinary from "../utils/cloudinaryUpload.js";


export const registerGuide = async (req, res) => {
    try {
        const {
            fullName,
            email,
            password,
            address,
            nic,
            mobileNumber,
            age,
            gender,
            horseName,
            horseBreed,
            horseAge,
            horseColor,
            horseSpecialNotes,
            bio,
            experience,
            languages,
        } = req.body;

        const userRecord = await auth.createUser({ email, password, displayName: fullName });

        const horseImageFiles = req.files["horseImages"] || [];
        const profileImageFile = req.files["profileImage"]?.[0];

        let profileImageUrl = "";
        const horseImageUrls = [];

        if (profileImageFile) {
            profileImageUrl = await uploadToCloudinary(
                profileImageFile.buffer,
                "guides/profile"
            );
        }

        for (let file of horseImageFiles) {
            const url = await uploadToCloudinary(file.buffer, "guides/horses");
            horseImageUrls.push(url);
        }

        // Create horse objects
        const horseData = {
            name: horseName,
            breed: horseBreed,
            age: horseAge,
            color: horseColor,
            specialNotes: horseSpecialNotes,
            images: horseImageUrls,
        };

        const guideData = {
            fullName,
            email,
            password,
            address,
            nic,
            mobileNumber,
            age,
            gender,
            profileImage: profileImageUrl,
            bio,
            experience,
            languages: languages,
            role : 'guide'
        };

        await createGuideWithHorse(userRecord.uid, guideData, horseData);

        res.status(201).json({ message: "Guide created", uid: userRecord.uid });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
};

const getAllGuides = async (req, res) => {
    try {
        const guides = await guideService.getAllGuides();
        res.status(200).json(guides);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

const getGuideById = async (req, res) => {
    try {
        const guide = await guideService.getGuideById(req.params.id);
        res.status(200).json(guide);
    } catch (err) {
        res.status(404).json({ message: err.message });
    }
};

const updateGuide = async (req, res) => {
    try {
        const updated = await guideService.updateGuide(req.params.id, req.body);
        res.status(200).json(updated);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

const deleteGuide = async (req, res) => {
    try {
        await guideService.deleteGuide(req.params.id);
        res.status(204).end();
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

export default {
    getAllGuides,
    getGuideById,
    updateGuide,
    deleteGuide
}