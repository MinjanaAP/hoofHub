import express from "express";
const router = express.Router();

router.get('/', (req, res) => {
    res.json({ message: "Welcome to Hoofhub" });
});

// module.exports = router;
export default router;