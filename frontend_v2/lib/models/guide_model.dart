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

  // Horse details
  String horseName = "";
  String horseBreed = "";
  int horseAge = 0;
  String horseColor = "";
  String horseSpecialNotes = "";

  // Guide profile details
  String profileImagePath = "";
  String bio = "";
  String experience = "";
  List<String> languages = [];

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

  void updateHorseName(String newName) {
    horseName = newName;
    notifyListeners();
  }

  void updateHorseBreed(String newBreed) {
    horseBreed = newBreed;
    notifyListeners();
  }

  void updateHorseAge(int newAge) {
    horseAge = newAge;
    notifyListeners();
  }

  void updateHorseColor(String newColor) {
    horseColor = newColor;
    notifyListeners();
  }

  void updateHorseSpecialNotes(String newNotes) {
    horseSpecialNotes = newNotes;
    notifyListeners();
  }

  // Add new update methods for profile details
  void updateProfileImage(String path) {
    profileImagePath = path;
    notifyListeners();
  }

  void updateBio(String newBio) {
    bio = newBio;
    notifyListeners();
  }

  void updateExperience(String newExp) {
    experience = newExp;
    notifyListeners();
  }

  void updateLanguages(List<String> newLanguages) {
    languages = newLanguages;
    notifyListeners();
  }
}
