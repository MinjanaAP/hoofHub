const { auth } = require("../config/firebase.js");

const verifyToken = async (req, res, next)=>{
    const token = req.headers.authorization?.split(" ")[1];

    if(!token){
        return res.status(401).json({
            status : false,
            error: "Unauthorized"
        });
    }

    try {
        const decodedToken = await auth.verifyToken(token);
        req.user = decodedToken;
        next();
    } catch (error) {
        res.status(403).json({
            status: false,
            error: "Invalid token."
        })
    }
}

module.exports = verifyToken;