import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/guide_components/signup_form_one.dart';
import 'package:frontend/common/guide_components/signup_form_two.dart';
import 'package:frontend/common/hoof_ride_text.dart';
import 'package:frontend/common/profile_image_picker.dart';
import 'package:frontend/common/signup_text_feild.dart';
import 'package:frontend/models/guide_model.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentStep++;
      });
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() {
        _currentStep--;
      });
    }
  }

  void submitForm() {
    final formData = Provider.of<GuideModel>(context, listen: false);
    logger.i("Name : ${formData.fullName}");
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController nicController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              const HoofHubText(
                text: "Guide.",
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(
                height: 18,
              ),
              const Divider(
                color: Color.fromARGB(102, 115, 53, 148),
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 16,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StepIndicator(
                    step: 1,
                    isActive: true,
                    text: "Guide Details",
                  ),
                  StepIndicator(
                    step: 2,
                    isActive: false,
                    text: "Horse Details",
                  ),
                  StepIndicator(
                    step: 3,
                    isActive: false,
                    text: "Guide Profile",
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const ProfileImagePicker(),
              Stack(children: [
                Positioned.fill(
                    child: Image.asset(
                  "assets/images/signupBackImg.png",
                )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 0.0),
                  child: Form(
                    key: _formKey,
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
                        const SizedBox(
                          height: 7.0,
                        ),
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
                          ],
                        ),
                        const SizedBox(height: 30.0),
                        SizedBox(
                          width: double.infinity,
                          height: 48.0,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.black,
                              elevation: 8,
                            ),
                            child: _isLoading
                                ? const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("Signing Up..."),
                                      SizedBox(width: 10),
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ],
                                  )
                                : const Text("Next"),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      )),
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int step;
  final String text;
  final bool isActive;

  const StepIndicator(
      {Key? key,
      required this.step,
      required this.isActive,
      required this.text})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: [
          CircleAvatar(
              radius: 20,
              backgroundColor: isActive ? Colors.purple : Colors.grey[300],
              child: CircleAvatar(
                radius: 18,
                child: Text(
                  "$step",
                  style: TextStyle(
                      color: isActive ? Colors.purple : Colors.black,
                      fontFamily: 'Poppins'),
                ),
              )),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            text,
            style: TextStyle(
                color: isActive
                    ? AppColors.primary
                    : const Color.fromARGB(65, 114, 53, 147),
                fontFamily: 'Poppins',
                fontSize: 10.0,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
