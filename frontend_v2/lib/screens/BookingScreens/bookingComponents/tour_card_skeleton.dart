import 'package:flutter/material.dart';

class TourCardSkeleton extends StatelessWidget {
  const TourCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Title placeholder
                    Container(height: 16, width: 150, color: Colors.grey[300]),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 100, color: Colors.grey[300]),
                    const SizedBox(height: 12),
                    // Difficulty and duration
                    Row(
                      children: [
                        Container(
                            height: 20, width: 80, color: Colors.grey[300]),
                        const SizedBox(width: 16),
                        Container(
                            height: 20, width: 60, color: Colors.grey[300]),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    // Guide info
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 12, width: 80, color: Colors.grey[300]),
                            const SizedBox(height: 4),
                            Container(
                                height: 10, width: 60, color: Colors.grey[200]),
                          ],
                        ),
                        const Spacer(),
                        Container(
                            height: 20, width: 70, color: Colors.grey[300]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
