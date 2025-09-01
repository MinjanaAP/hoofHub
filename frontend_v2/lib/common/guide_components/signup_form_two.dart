import 'package:flutter/material.dart';
import 'package:frontend/models/guide_model.dart';
import 'package:provider/provider.dart';


class SignupFormTwo extends StatelessWidget {
   final VoidCallback nextStep;
  final VoidCallback previousStep;
  const SignupFormTwo({Key ? key, required this.nextStep, required this.previousStep}):super(key: key);

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<GuideModel>(context);
     return Padding(
      padding:const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Email"),
            onChanged: (value) => formData.updateEmail(value),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: previousStep, child: const Text("Back")),
              ElevatedButton(onPressed: nextStep, child: const Text("Next"))
            ],
          ),
        ],
      ),
    );
  }
}