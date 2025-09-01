import 'package:flutter/material.dart';
import 'package:frontend/models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final Booking _data = Booking();

  Booking get data => _data;

  void setRideType(String? type) {
    _data.rideType = type;
    notifyListeners();
  }

  void setDateTime(DateTime date, String time) {
    _data.selectedDate = date;
    _data.selectedTime = time;
    notifyListeners();
  }

  void setGuideId(String? id) {
    _data.guideId = id;
    notifyListeners();
  }

  void setRideId(String? id) {
    _data.rideId = id;
    notifyListeners();
  }

  void setUid(String? id) {
    _data.uid = id;
    notifyListeners();
  }
  void reset() {
    _data.rideType = null;
    _data.guideId = null;
    _data.selectedDate = null;
    _data.rideId = null;
    _data.selectedTime = null;
    notifyListeners();
  }
}
