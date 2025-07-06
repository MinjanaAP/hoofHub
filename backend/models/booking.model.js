class Booking {
    constructor({ rideType, selectedDate, selectedTime, rideId, guideId, uid }) {
        this.rideType = rideType;
        this.selectedDate = selectedDate;
        this.selectedTime = selectedTime;
        this.rideId = rideId;
        this.guideId = guideId;
        this.uid = uid;
        this.status = "pending";
        this.createdAt = new Date().toISOString();
    }

    toFireStore(){
        return {
            uid: this.uid,
            rideType : this.rideType,
            selectedDate: this.selectedDate,
            selectedTime : this.selectedTime,
            rideId: this.rideId,
            guideId : this.guideId,
            status :this.status,
            createdAt: new Date().toISOString(),
        };
    }
}

export default Booking;
