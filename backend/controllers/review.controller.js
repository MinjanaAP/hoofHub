import { addReview } from "../services/review.service.js";

export async function addReviews(req, res) {
    try {
        const { bookingId, horseRating, guideRating, reviewText } = req.body;
        // console.log("Request body", req.body);
        // if (!bookingId || !horseRating || !guideRating) {
        //     return res
        //         .status(400)
        //         .json({ message: "bookingId and rating are required" });
        // }

        const review = await addReview({
            bookingId,
            horseRating,
            guideRating,
            reviewText,
        });

        res.status(201).json({ success: true, review });
    } catch (error) {
        console.error("Error in addReview:", error);
        res.status(500).json({ success: false, message: error.message });
    }
}
