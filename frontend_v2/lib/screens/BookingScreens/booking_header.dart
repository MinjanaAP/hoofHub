import 'package:flutter/material.dart';

class BookingHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const BookingHeader({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF723594), // #723594
            Color(0xFF8F4AB8), // #8F4AB8
          ], 
          stops: [0.25, 0.9571],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontSize: 20.4,
                fontWeight: FontWeight.w600,
                height: 32 / 20.4, // line-height 32px
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.8),
                fontFamily: 'Inter',
                fontSize: 13.6,
                fontWeight: FontWeight.w400,
                height: 24 / 13.6, // line-height 24px
              ),
            ),
          ],
        ),
      ),
    );
  }
}
