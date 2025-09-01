import QRCode from "qrcode";
import cloudinary from "../utils/cloudinary.js";
import { Readable } from "stream";
import jwt from "jsonwebtoken";

export const generateAndUploadSecureQR = async (bookingId, riderId) => {
    try {
        const token = jwt.sign(
            { bookingId, riderId },
            process.env.JWT_SECRET,  
        );

        const qrBuffer = await QRCode.toBuffer(token, { type: "png" });

        return new Promise((resolve, reject) => {
            const uploadStream = cloudinary.uploader.upload_stream(
                { folder: "qr_codes" },
                (error, result) => {
                    if (error) reject(error);
                    else resolve(result.secure_url);
                }
            );

            Readable.from(qrBuffer).pipe(uploadStream);
        });
    } catch (err) {
        throw new Error("Secure QR generation failed: " + err.message);
    }
};
