import 'package:flutter/material.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/theme.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Cards
          Column(
            children: [
              HeaderCard(
                title: "Ready to Ride?",
                subtitle: "Book your next adventure now",
                buttonText: "Book a Ride",
                backgroundColor: AppColors.primary,
                icon: Icons.calendar_today,
              ),
              SizedBox(height: 24),
              HeaderCard(
                title: "",
                subtitle: "Earn rewards with every ride",
                buttonText: "Redeem Rewards",
                backgroundColor: Color.fromARGB(234, 179, 127, 8),
                icon: Icons.card_giftcard,
                amount: 2450,
              ),
            ],
          ),
          SizedBox(height: 40),

          // Special Offers
          SectionTitle(title: "Special Offers"),
          SizedBox(height: 16),
          OfferCard(
            title: "20% Off First Ride",
            description: "New riders get 20% off their first booking",
            code: "NEWRIDER",
          ),
          SizedBox(height: 40),

          // Upcoming
          SectionTitle(title: "Upcoming"),
          SizedBox(height: 16),
          UpcomingRideCard(
            rideTitle: "Trail Ride with Thunder",
            rideTime: "Tomorrow at 10:00 AM",
          ),
          SizedBox(height: 20),

          Divider(
            color: Color.fromARGB(72, 39, 18, 51), // Optional: set the color of the line
            thickness: 1.5,    // Optional: set the thickness of the line
            indent: 0,      // Optional: set the start indent of the line
            endIndent: 0,   // Optional: set the end indent of the line
          ),

          SizedBox(height: 20),
          // Discover
          DiscoverSection(),

          SizedBox(height: 20),

          Divider(
            color: Color.fromARGB(72, 39, 18, 51), // Optional: set the color of the line
            thickness: 1.5,    // Optional: set the thickness of the line
            indent: 0,      // Optional: set the start indent of the line
            endIndent: 0,   // Optional: set the end indent of the line
          ),

          SizedBox(height: 20),

          // Features
          FeatureTile(
            icon: Icons.bolt,
            title: "Seamless Booking",
            description:
                "Easily book horse rides with a few taps on your phone.",
          ),
          SizedBox(height: 20),
          FeatureTile(
            icon: Icons.access_time_filled,
            title: "Real-Time Availability",
            description: "Instantly check available rides and guides near you.",
          ),
          SizedBox(height: 20),
          FeatureTile(
            icon: Icons.lock,
            title: "Secure Payments",
            description:
                "Experience hassle-free, secure payments for every booking.",
          ),
          SizedBox(height: 20),
          FeatureTile(
            icon: Icons.favorite,
            title: "Valuable Feedback",
            description: "Share your ride experiences and help others make informed choices.",
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

// Reusable widgets

class HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color backgroundColor;
  final IconData icon;
  final int? amount;

  const HeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.backgroundColor,
    required this.icon,
    this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (amount != null)
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "HoofCoins",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "$amount coins",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ]),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 48.0,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (amount != null) {
                } else {
                  Navigator.pushNamed(context, AppRoutes.bookingType);
                }
              },
              icon: Icon(icon, size: 18),
              label: Text(buttonText),
            ),
          )
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Color.fromARGB(255, 45, 1, 69), // Updated color
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String title;
  final String description;
  final String code;

  const OfferCard({
    super.key,
    required this.title,
    required this.description,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 0,
        bottom: 0,
        left: 8,
        right: 0,
      ),
      decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7), 
              blurRadius: 4,
              offset: const Offset(0, 4),
            )
          ]),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(description),
              const SizedBox(height: 8),
              Text("Use Code: $code",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class UpcomingRideCard extends StatelessWidget {
  final String rideTitle;
  final String rideTime;

  const UpcomingRideCard(
      {super.key, required this.rideTitle, required this.rideTime});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: const Icon(Icons.timelapse_rounded, color: AppColors.primary, size: 32),
        title: Text(rideTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins')),
        subtitle: Text(rideTime),
      ),
    );
  }
}

class DiscoverSection extends StatelessWidget {
  const DiscoverSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Discover Unforgettable Horse Riding Experiences",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        Image.asset(
          'assets/images/discover_section.png', // replace with your actual image
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        
        const SizedBox(height: 8),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.aboutUs);
                },
                child: const Text("Learn More About HoofHub",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.bookingType);
                },
                child: const Text("Start Your Adventure Today",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.background
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }
}
