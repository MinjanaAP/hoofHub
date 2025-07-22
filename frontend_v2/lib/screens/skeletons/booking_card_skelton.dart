import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BookingCardSkelton extends StatelessWidget {
  const BookingCardSkelton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 20, width: 120, color: Colors.white),
              const SizedBox(height: 12),
              Container(height: 16, width: 200, color: Colors.white),
              const SizedBox(height: 8),
              Container(height: 16, width: 100, color: Colors.white),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: Container(height: 40, color: Colors.white)),
                  const SizedBox(width: 8),
                  Expanded(child: Container(height: 40, color: Colors.white)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
