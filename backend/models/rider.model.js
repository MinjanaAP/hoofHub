class Rider {
    constructor(uid, name, email, mobileNumber, role){
        this.uid = uid;
        this.name = name;
        this.email = email;
        this.mobileNumber = mobileNumber;
        this.role = role || "rider";
    }

    toFireStore(){
        return {
            uid: this.uid,
            name: this.name,
            email: this.email,
            mobileNumber: this.mobileNumber,
            role: this.role,
            createdAt: new Date().toISOString(),
        };
    }
}

module.exports = Rider;