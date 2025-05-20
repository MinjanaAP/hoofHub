import 'package:flutter/material.dart';
import 'package:frontend/models/guide_model.dart';
import 'package:provider/provider.dart';

class SignupFormOne extends StatelessWidget {
  final VoidCallback nextStep;
  const SignupFormOne({Key? key, required this.nextStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formData = Provider.of<GuideModel>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: "Name"),
            onChanged: (value) => formData.updateFullName(value),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: nextStep, child: const Text("Next"))
        ],
      ),
    );
  }
}
