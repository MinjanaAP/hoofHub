const { auth, db } = require("../config/firebase");
const Rider = require("../models/rider.model");

exports.registerRider = async (req , res )=>{
    try {
        const {email, password, name, mobileNumber, role} = req.body;

        if (!email || !password || !name || !mobileNumber || !role) {
            return res.status(400).json({ status: false, message: "All fields are required" });
        }

        //? CREATE user in Firebase Authentication
        const userRecord = await auth.createUser({
            email,
            password,
            displayName: name,
        });
        const newRider = new Rider(userRecord.uid, name, email,mobileNumber, role);
        await db.collection("riders").doc(userRecord.uid).set(newRider.toFireStore());
        res.status(201).json({
            status: true,
            message: "User registered successfully!",
            uid: userRecord.uid
        });
    } catch (error) {
        res.status(500).json({
            status: false,
            error: error.message
        })
    }
}

exports.getUserProfile = async (req, res)=>{
    try {
        const riderDoc = await db.collection("riders").doc(req.user.uid).get();
        if(!riderDoc){
            return res.status(404).json({status: false , error: "User not Found."});
        }
        return res.status(200).json({ status: true, data: riderDoc.data()});
    } catch (error) {
        res.status(500).json({ status:false, error: error.message });
    }
}