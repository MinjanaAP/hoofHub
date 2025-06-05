import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/guide_components/signup_form_one.dart';
import 'package:frontend/common/guide_components/signup_form_two.dart';
import 'package:frontend/common/hoof_ride_text.dart';
import 'package:frontend/common/profile_image_picker.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/models/guide_model.dart';
import 'package:frontend/screens/guideScreens/guide_signup.dart';
import 'package:frontend/theme.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';


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
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Controllers for step 1 (Guide Details)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
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
    // Dispose all controllers
    nameController.dispose();
    emailController.dispose();
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
      // Save guide details
      formData.updateFullName(nameController.text);
      formData.updateEmail(emailController.text);
      formData.updateAddress(addressController.text);
      formData.updateNic(nicController.text);
      formData.updateMobileNumber(mobileNumberController.text);
      formData.updateAge(int.tryParse(ageController.text) ?? 0);
      formData.updateGender(genderController.text);
    } else if (_currentStep == 1) {
      // Save horse details
      formData.updateHorseName(horseNameController.text);
      formData.updateHorseBreed(horseBreedController.text);
      formData.updateHorseAge(int.tryParse(horseAgeController.text) ?? 0);
      formData.updateHorseColor(horseColorController.text);
      formData.updateHorseSpecialNotes(horseNotesController.text);
    }
    // Step 3 data is saved when fields change directly
  }

  void submitForm() {
    if (_formKeys[2].currentState!.validate()) {
      final formData = Provider.of<GuideModel>(context, listen: false);
      
      // Save profile details
      formData.updateBio(bioController.text);
      formData.updateExperience(experienceController.text);
      formData.updateLanguages(languagesController.text.split(','));

      setState(() => _isLoading = true);
      
      // Submit all data
      logger.i("Guide Data: ${formData.fullName}, ${formData.email}");
      logger.i("Horse Data: ${formData.horseName}, ${formData.horseBreed}");
      logger.i("Profile Data: ${formData.bio}, ${formData.experience}");
      
      // TODO: Implement your submission logic here
      // After submission:
      // Navigator.push(context, MaterialPageRoute(builder: (_) => SuccessScreen()));
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // Step 1: Guide Details
                    _buildGuideDetailsStep(),
                    
                    // Step 2: Horse Details
                    _buildHorseDetailsStep(),
                    
                    // Step 3: Guide Profile
                    _buildGuideProfileStep(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideDetailsStep() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset("assets/images/signupBackImg.png"),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
          child: Form(
            key: _formKeys[0],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(
                          height: 21.0,
                        ),
                        const Text(
                          "Email Address",
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
                          hintText: "Enter your email address.",
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please enter your email.";
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
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
                          "Address",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 7.0,
                        ),
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
                        const SizedBox(
                          height: 21.0,
                        ),
                        const Text(
                          "NIC",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 7.0,
                        ),
                        CustomTextFormField(
                          hintText: "Enter your NIC here.",
                          controller: nicController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your nic number.";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 21.0,
                        ),
                        const Text(
                          "Mobile",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 7.0,
                        ),
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
                        const SizedBox(
                          height: 21.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                        color: AppColors.primary),
                                  ),
                                  const SizedBox(
                                    height: 7.0,
                                  ),
                                  CustomTextFormField(
                                    hintText: "Your age",
                                    controller: ageController,
                                    keyboardType: TextInputType.phone,
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
                                        color: AppColors.primary),
                                  ),
                                  const SizedBox(
                                    height: 7.0,
                                  ),
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
                                          fontFamily: 'Poppins'),
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 12),
                                    ),
                                    hint: const Text("Gender"),
                                    items: ["Male", "Female", "Other"]
                                        .map((gender) => DropdownMenuItem(
                                            value: gender, child: Text(gender)))
                                        .toList(),
                                    onChanged: (value) {
                                      genderController.text = value!;
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please select your gender.";
                                      }
                                      return null;
                                    },
                                  )
                                ],
                              ),
                            )
                      ]),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 8,
                    ),
                    child: const Text("Next"),
                  ),
                ),
                const SizedBox(height: 30.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorseDetailsStep() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset("assets/images/signupBackImg.png"),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
          child: Form(
            key: _formKeys[1],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
        ),
      ],
    );
  }

  Widget _buildGuideProfileStep() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset("assets/images/signupBackImg.png"),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
          child: Form(
            key: _formKeys[2],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const ProfileImagePicker(
                //   onImageSelected: (path) {
                //     Provider.of<GuideModel>(context, listen: false)
                //         .updateProfileImage(path);
                //   },
                // ),
                const ProfileImagePicker(),
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: previousStep,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
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
        ),
      ],
    );
  }
}