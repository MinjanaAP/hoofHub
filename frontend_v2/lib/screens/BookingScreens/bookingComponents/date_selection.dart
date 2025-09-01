import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelection extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Function(DateTime, String) onSelect; // Accepts DateTime and String

  const DateSelection({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onSelect,
  });

  @override
  State<DateSelection> createState() => _DateSelectionState();
}

class _DateSelectionState extends State<DateSelection> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Select Date & Time",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
        
            // Date picker
            SizedBox(
              height: 220,
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                onDateChanged: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
        
            // Time picker
            const Text(
              "Select Time",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
        
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    builder: (context, child) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: false,
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (time != null) {
                    setState(() {
                      selectedTime = time;
                    });
                  }
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  selectedTime == null
                      ? "Select Time"
                      : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}",
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedTime == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
        
            // Time validation message
            if (selectedTime != null &&
                (selectedTime!.hour < 9 ||
                    (selectedTime!.hour >= 18 && selectedTime!.minute > 0)))
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Please select time between 9:00 AM and 6:00 PM",
                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),
        
            // Selected details display
            if (selectedDate != null || selectedTime != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Selected Appointment:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (selectedDate != null)
                    Text(
                      "Date: ${DateFormat('EEE, MMM d, y').format(selectedDate!)}",
                    ),
                  if (selectedTime != null)
                    Text(
                      "Time: ${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}",
                    ),
                  const SizedBox(height: 24),
                ],
              ),
        
            // Continue button
            ElevatedButton(
              onPressed: (selectedDate != null &&
                      selectedTime != null &&
                      selectedTime!.hour >= 9 &&
                      (selectedTime!.hour < 18 ||
                          (selectedTime!.hour == 18 &&
                              selectedTime!.minute == 0)))
                  ? () {
                      // Convert TimeOfDay to String in "HH:mm AM/PM" format
                      final timeStr =
                          "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')} ${selectedTime!.period == DayPeriod.am ? 'AM' : 'PM'}";
        
                      widget.onSelect(selectedDate!, timeStr);
                      widget.onNext();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (selectedDate != null &&
                        selectedTime != null &&
                        selectedTime!.hour >= 9 &&
                        (selectedTime!.hour < 18 ||
                            (selectedTime!.hour == 18 &&
                                selectedTime!.minute == 0)))
                    ? const Color(0xFF723594)
                    : Colors.grey.shade300,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Continue",
                style: TextStyle(
                  color: (selectedDate != null &&
                          selectedTime != null &&
                          selectedTime!.hour >= 9 &&
                          (selectedTime!.hour < 18 ||
                              (selectedTime!.hour == 18 &&
                                  selectedTime!.minute == 0)))
                      ? Colors.white
                      : Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
