import { default as adminService } from "../services/admin.service.js";


const handleAdminSignup = async (req, res) => {
    const { firstName, lastName, email, password } = req.body;

    if (!firstName || !lastName || !email || !password) {
        return res.status(400).json({ error: "All fields are required" });
    }

    try {
        const result = await adminService.createAdmin({ firstName, lastName, email, password });
        return res.status(201).json({ message: "Admin created", uid: result.uid });
    } catch (error) {
        console.error("Admin signup error:", error);
        return res
            .status(500)
            .json({ error: error.message || "Something went wrong" });
    }
};

export default {
    handleAdminSignup,
};
