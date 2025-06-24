export default class Guide {
    constructor(data) {
        this.fullName = data.fullName || "";
        this.email = data.email || "";
        this.address = data.address || "";
        this.nic = data.nic || "";
        this.mobileNumber = data.mobileNumber || "";
        this.password = data.password || "";
        this.age = data.age || 0;
        this.gender = data.gender || "Male";

        this.horseName = data.horseName || "";
        this.horseBreed = data.horseBreed || "";
        this.horseAge = data.horseAge || 0;
        this.horseColor = data.horseColor || "";
        this.horseSpecialNotes = data.horseSpecialNotes || "";

        this.profileImagePath = data.profileImagePath || "";
        this.bio = data.bio || "";
        this.experience = data.experience || "";
        this.languages = data.languages || [];
    }
}
