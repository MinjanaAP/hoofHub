import 'package:flutter/material.dart';

class Booking {
  String? rideType;
  String? rideId;
  String? guideId;
  String? uid;
  DateTime? selectedDate;
  String? selectedTime;

  Map<String, dynamic> toJson() => {
        "rideType": rideType,
        "selectedDate": selectedDate?.toIso8601String(), 
        "selectedTime": selectedTime,
        "rideId" : rideId,
        "guideId" : guideId,
        "uid" : uid
      };
}
