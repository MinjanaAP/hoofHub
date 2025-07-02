// models/Admin.ts
export default class Admin {
  constructor(uid, firstName, email, lastName, role, status){
        this.uid = uid;
        this.firstName = firstName;
        this.email = email;
        this.lastName = lastName;
        this.role = role || "admin";
        this.status = status || "pending";
    }

    toFireStore(){
        return {
            uid: this.uid,
            firstName: this.firstName,
            email: this.email,
            lastName: this.lastName,
            role: this.role,
            status : this.status,
            createdAt: new Date().toISOString(),
        };
    }
}


module.exports = {
  collectionName: "admins",
};