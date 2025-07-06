import 'package:flutter/material.dart';
import 'package:frontend/theme.dart';


class BookingProgressBar extends StatelessWidget {
  final String currentStep;
  final List<String> steps;

  const BookingProgressBar({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final stepNames = {
      "details": "Tour Details",
      "date": "Date & Time",
      "rider": "Rider Info",
      "payment": "Payment",
      "confirmation": "Confirmation",
    };

    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 16, right: 16),
      decoration: const BoxDecoration(
        // gradient: LinearGradient(
        //   colors: [Color(0xFF723594), Color(0xFF8f4ab8)],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
      child: Row(
        children: steps.map((step) {
          final index = steps.indexOf(step);
          final isCompleted = steps.indexOf(currentStep) > index;
          final isCurrent = currentStep == step;

          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.primary
                        : isCurrent
                            ? AppColors.primary
                            : const Color.fromARGB(255, 63, 58, 58).withOpacity(0.2),
                    border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Color(0xFF723594))
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCurrent ? Colors.white : Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stepNames[step] ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    color: isCurrent ? AppColors.primary: Color.fromARGB(255, 63, 58, 58).withOpacity(0.2),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
