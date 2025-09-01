import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/hoof_ride_text.dart';
import 'package:frontend/common/profile_image_picker.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/models/guide_model.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/tour_card_skeleton.dart';
import 'package:frontend/screens/BookingScreens/bookingComponents/tour_cards.dart';
import 'package:frontend/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class GuideSignup extends StatefulWidget {
  const GuideSignup({super.key});

  @override
  State<GuideSignup> createState() => _GuideSignupState();
}

class _GuideSignupState extends State<GuideSignup> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  var logger = Logger();
  bool _isLoading = false;
  String? selectedTour;
  bool isTourLoading = false;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // horse image picker
  List<XFile> selectedHorseImages = [];

  Future<void> pickHorseImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.length <= 5) {
      setState(() {
        selectedHorseImages = images;
        Provider.of<GuideModel>(context, listen: false).horseImagePaths =
            images.map((img) => img.path).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only upload up to 5 images")),
      );
    }
  }

  // Controllers for step 1 (Guide Details)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  // Controllers for step 2 (Horse Details)
  final TextEditingController horseNameController = TextEditingController();
  final TextEditingController horseBreedController = TextEditingController();
  final TextEditingController horseAgeController = TextEditingController();
  final TextEditingController horseColorController = TextEditingController();
  final TextEditingController horseNotesController = TextEditingController();

  // Controllers for step 3 (Guide Profile)
  final TextEditingController bioController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController languagesController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    addressController.dispose();
    nicController.dispose();
    mobileNumberController.dispose();
    ageController.dispose();
    genderController.dispose();
    horseNameController.dispose();
    horseBreedController.dispose();
    horseAgeController.dispose();
    horseColorController.dispose();
    horseNotesController.dispose();
    bioController.dispose();
    experienceController.dispose();
    languagesController.dispose();
    super.dispose();
  }

  void nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      _saveCurrentStepData();
      if (_currentStep < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
        setState(() => _currentStep++);
      }
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      setState(() => _currentStep--);
    }
  }

  void _saveCurrentStepData() {
    final formData = Provider.of<GuideModel>(context, listen: false);

    if (_currentStep == 0) {
      formData.updateFullName(nameController.text);
      formData.updateEmail(emailController.text);
      formData.updatePassword(passwordController.text);
      formData.updateAddress(addressController.text);
      formData.updateNic(nicController.text);
      formData.updateMobileNumber(mobileNumberController.text);
      formData.updateAge(int.tryParse(ageController.text) ?? 0);
      formData.updateGender(genderController.text);
    } else if (_currentStep == 1) {
      formData.updateHorseName(horseNameController.text);
      formData.updateHorseBreed(horseBreedController.text);
      formData.updateHorseAge(int.tryParse(horseAgeController.text) ?? 0);
      formData.updateHorseColor(horseColorController.text);
      formData.updateHorseSpecialNotes(horseNotesController.text);
    }
  }

  void submitForm() async {
    if (_formKeys[2].currentState!.validate()) {
      final formData = Provider.of<GuideModel>(context, listen: false);

      formData.updateBio(bioController.text);
      formData.updateExperience(experienceController.text);
      formData.updateLanguages(languagesController.text.split(','));
      formData.updateRideId(selectedTour);

      setState(() => _isLoading = true);

      logger
          .i("Guide Data: ${formData.fullName}, ${formData.profileImagePath}");
      logger.i("Horse Data: ${formData.horseName}, ${formData.horseBreed}");
      logger.i("Profile Data: ${formData.rideId}, ${formData.experience}");

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConstants.baseUrl}/guides/register'),
        );

        request.fields['fullName'] = formData.fullName;
        request.fields['email'] = formData.email;
        request.fields['password'] = formData.password;
        request.fields['address'] = formData.address;
        request.fields['nic'] = formData.nic;
        request.fields['mobileNumber'] = formData.mobileNumber;
        request.fields['age'] = formData.age.toString();
        request.fields['gender'] = formData.gender;

        request.fields['horseName'] = formData.horseName;
        request.fields['horseBreed'] = formData.horseBreed;
        request.fields['horseAge'] = formData.horseAge.toString();
        request.fields['horseColor'] = formData.horseColor;
        request.fields['horseSpecialNotes'] = formData.horseSpecialNotes;

        request.fields['bio'] = formData.bio;
        request.fields['experience'] = formData.experience;
        request.fields['languages'] = formData.languages.join(',');
        request.fields['rideId'] = formData.rideId!;

        // Attach image
        if (formData.profileImagePath.isNotEmpty) {
          File imageFile = File(formData.profileImagePath);
          request.files.add(await http.MultipartFile.fromPath(
            'profileImage',
            imageFile.path,
            filename: imageFile.path,
          ));
        }

        // Attach horse images
        for (int i = 0; i < formData.horseImagePaths.length; i++) {
          File imageFile = File(formData.horseImagePaths[i]);
          request.files.add(await http.MultipartFile.fromPath(
            'horseImages',
            imageFile.path,
            filename: 'horse_$i.jpg',
          ));
        }

        var response = await request.send();
        if (response.statusCode == 201) {
          logger.i("Guide created successfully.");
          // Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessScreen()));

          if (!mounted) return;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("You're All Set!"),
                content:
                    const Text("Signup successful. Please login to continue."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                          context, AppRoutes.guideLogin);
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          final resBody = await response.stream.bytesToString();
          final resJson = jsonDecode(resBody);

          final errorMessage = resJson['message'] ?? 'Failed to register.';

          logger.e(
              "Failed to register. Code: ${response.statusCode}, Error: $errorMessage");

          if (mounted) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Registration Error"),
                content: Text(errorMessage),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("OK"))
                ],
              ),
            );
          }
        }
      } catch (e) {
        logger.e("Submission error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(
        title: "hoofHub",
        showBackButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const HoofHubText(text: "Guide."),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "sign up",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "to create hoof account.",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(
              color: Color.fromARGB(102, 115, 53, 148),
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StepIndicator(
                  step: 1,
                  isActive: _currentStep == 0,
                  text: "Guide Details",
                ),
                StepIndicator(
                  step: 2,
                  isActive: _currentStep == 1,
                  text: "Horse Details",
                ),
                StepIndicator(
                  step: 3,
                  isActive: _currentStep == 2,
                  text: "Guide Profile",
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildGuideDetailsStep(),
                  _buildHorseDetailsStep(),
                  _buildGuideProfileStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Form(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ProfileImagePicker(
                onImageSelected: (imagePath) {
                  Provider.of<GuideModel>(context, listen: false)
                      .updateProfileImage(imagePath);
                },
              ),
            ),
            const SizedBox(height: 21),
            const Text(
              "Full Name",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Enter your name here.",
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your full name.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            const Text(
              "Email Address",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Enter your email address.",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email.";
                }
                if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                    .hasMatch(value)) {
                  return "Enter a valid email address.";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 21.0,
            ),
            const Text(
              "Password",
              style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary),
            ),
            const SizedBox(
              height: 7.0,
            ),
            CustomTextFormField(
              hintText: "Enter your password.",
              controller: passwordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a password.";
                }
                if (value.length < 6) {
                  return "Password must be at least 6 characters long.";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 21.0,
            ),
            const Text(
              "Confirm Password",
              style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary),
            ),
            const SizedBox(
              height: 7.0,
            ),
            CustomTextFormField(
              hintText: "Re-enter your Password.",
              controller: confirmPasswordController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please confirm your password.";
                }
                if (value != passwordController.text) {
                  return "Passwords do not match.";
                }
                return null;
              },
              prefixIcon: Icons.lock,
            ),
            const SizedBox(height: 21.0),
            const Text(
              "Address",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Enter your address here.",
              controller: addressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your address.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            const Text(
              "NIC",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Enter your NIC here.",
              controller: nicController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your NIC number.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            const Text(
              "Mobile",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Enter your Mobile number.",
              controller: mobileNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your mobile number.";
                } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                  return "Enter a valid 10-digit mobile number.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Age",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 7.0),
                      CustomTextFormField(
                        hintText: "Your age",
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your age.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 7.0),
                      DropdownButtonFormField<String>(
                        value: genderController.text.isNotEmpty
                            ? genderController.text
                            : null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(
                              color: Color(0xFF9CA2B5),
                              width: 1.0,
                            ),
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                            fontFamily: 'Poppins',
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                        ),
                        hint: const Text("Gender"),
                        items: ["Male", "Female", "Other"]
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text(gender),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            genderController.text = value;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select your gender.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: ElevatedButton(
                onPressed: nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 8,
                ),
                child: const Text("Next"),
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildHorseDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Form(
        key: _formKeys[1],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "Horse Images (max 5)",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7),
            ElevatedButton(
              onPressed: pickHorseImages,
              child: const Text("Select Images"),
            ),
            Wrap(
              spacing: 10,
              children: selectedHorseImages.map((img) {
                return Image.file(
                  File(img.path),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                );
              }).toList(),
            ),
            const Text(
              "Horse Name",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Enter your horse's name",
              controller: horseNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter horse name.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            const Text(
              "Horse Breed",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Enter horse breed",
              controller: horseBreedController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter horse breed.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Horse Age",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 7.0),
                      CustomTextFormField(
                        hintText: "Age",
                        controller: horseAgeController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter horse age.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Color",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 7.0),
                      CustomTextFormField(
                        hintText: "Color",
                        controller: horseColorController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter color.";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 21.0),
            const Text(
              "Special Notes",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Any special notes about your horse",
              controller: horseNotesController,
              // maxLines: 3,
            ),
            const SizedBox(height: 30.0),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: previousStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Back"),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Next"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideProfileStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
      child: Form(
        key: _formKeys[2],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "Bio",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Tell us about yourself",
              controller: bioController,
              // maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your bio.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            const Text(
              "Experience",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Your experience as a guide",
              controller: experienceController,
              // maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your experience.";
                }
                return null;
              },
            ),
            const SizedBox(height: 21.0),
            const Text(
              "Languages",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7.0),
            CustomTextFormField(
              hintText: "Comma separated list (e.g., English,Sinhala,Tamil)",
              controller: languagesController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter languages you speak.";
                }
                return null;
              },
            ),
            const SizedBox(height: 30.0),
            const Text(
              "Select your ride area",
              style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            TourCards(
              selectedTour: selectedTour,
              onSelect: (id) => setState(() => selectedTour = id),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: previousStep,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Back"),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isLoading) return;
                      submitForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isLoading
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Submitting..."),
                              SizedBox(width: 10),
                              CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ],
                          )
                        : const Text("Submit"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int step;
  final String text;
  final bool isActive;

  const StepIndicator({
    Key? key,
    required this.step,
    required this.isActive,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: isActive ? AppColors.primary : Colors.grey[300],
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                "$step",
                style: TextStyle(
                  color: isActive ? AppColors.primary : Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            text,
            style: TextStyle(
              color: isActive
                  ? AppColors.primary
                  : const Color.fromARGB(65, 114, 53, 147),
              fontFamily: 'Poppins',
              fontSize: 10.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
