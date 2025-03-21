import 'package:flutter/material.dart';

class GuideModel extends ChangeNotifier {
  String fullName = "";
  String email = "";
  String address = "";
  String nic = "";
  String mobileNumber = "";
  String password = "";
  int age = 0;
  String gender = "Male";

  void updateFullName(String newName) {
    fullName = newName;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    email = newEmail;
    notifyListeners();
  }

  void updateAddress(String newAddress) {
    address = newAddress;
    notifyListeners();
  }

  void updateNic(String newNic) {
    nic = newNic;
    notifyListeners();
  }

  void updateMobileNumber(String newMobileNumber) {
    mobileNumber = newMobileNumber;
    notifyListeners();
  }

  void updatePassword(String newUpdatePassword) {
    password = newUpdatePassword;
    notifyListeners();
  }

  void updateAge(int newAge) {
    age = newAge;
    notifyListeners();
  }

  void updateGender(String newGender) {
    gender = newGender;
    notifyListeners();
  }
}
