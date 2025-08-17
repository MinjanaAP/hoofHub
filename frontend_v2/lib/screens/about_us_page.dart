import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/theme.dart';


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "About Us", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Brand Logo
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/discover_horse.png',
                width: 180,
                height: 180,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "HoofHub",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Ride. Connect. Experience.",
              style: TextStyle(fontSize: 16, color: Colors.black54,fontFamily: 'Poppins',),
            ),
            const SizedBox(height: 30),

            // Mission Card
            _buildInfoCard(
              icon: Icons.favorite,
              title: "Our Mission",
              description:
                  "At HoofHub, we aim to connect horse riding enthusiasts with certified guides and trusted stables, creating safe, joyful, and unforgettable riding experiences.",
            ),
            const SizedBox(height: 20),

            // Vision Card
            _buildInfoCard(
              icon: Icons.auto_awesome,
              title: "Our Vision",
              description:
                  "We envision a future where riders and guides seamlessly connect through technology, making horse riding more accessible, secure, and enjoyable for everyone.",
            ),
            const SizedBox(height: 30),

            // Core Values
            const Text(
              "Our Core Values",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _buildValueCard(Icons.security, "Safety First"),
                _buildValueCard(Icons.people, "Community"),
                _buildValueCard(Icons.eco, "Sustainability"),
                _buildValueCard(Icons.star, "Excellence"),
              ],
            ),
            const SizedBox(height: 30),

            // Team Section
            const Text(
              "Meet Our Team",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildTeamCard(
                  name: "Pasan Athuluwage",
                  role: "Founder & Developer",
                  imageUrl:
                      "https://res.cloudinary.com/dtv1nvsx9/image/upload/v1755442148/insta_prof_xkjybq.jpg", // Replace with your image
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Socials
            const Text(
              "Connect With Us",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.facebook, color: Color(0xFF3b5998)),
                SizedBox(width: 20),
                Icon(Icons.facebook, color: Color(0xFFE1306C)),
                SizedBox(width: 20),
                Icon(Icons.facebook, color: Color(0xFF1DA1F2)),
              ],
            ),
            const SizedBox(height: 40),

            const Text(
              "© 2025 HoofHub. All rights reserved.",
              style: TextStyle(color: Colors.black54, fontFamily: 'Poppins'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Helpers ---
  static Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String description}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 40),
            const SizedBox(height: 12),
            Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,fontFamily: 'Poppins',)),
            const SizedBox(height: 8),
            Text(description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  static Widget _buildValueCard(IconData icon, String title) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 36),
          const SizedBox(height: 10),
          Text(title,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  static Widget _buildTeamCard(
      {required String name,
      required String role,
      required String imageUrl}) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(height: 12),
          Text(name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(role,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }
}
