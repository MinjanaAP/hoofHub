import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/common/guide_components/signup_form_one.dart';
import 'package:frontend/common/guide_components/signup_form_two.dart';
import 'package:frontend/common/hoof_ride_text.dart';
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
              Column(
                children: [
                  LinearProgressIndicator(value: (_currentStep + 1)/3),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics:const NeverScrollableScrollPhysics(),
                      children: [
                        SignupFormOne(nextStep: nextStep),
                        SignupFormTwo(nextStep: nextStep, previousStep: previousStep),
                      ],
                    )
                  )
                ],
              )
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
