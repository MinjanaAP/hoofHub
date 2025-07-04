import 'package:flutter/material.dart';

class Tour {
  final String id;
  final String name;
  final String location;
  final String image;
  final String difficulty;
  final String duration;
  final String price;
  final double rating;
  final int reviews;
  final String guideName;
  final String guideImage;

  Tour({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.difficulty,
    required this.duration,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.guideName,
    required this.guideImage,
  });
}

final List<Tour> tours = [
  Tour(
    id: "1",
    name: "Sunset Beach Ride",
    location: "Coastal Trail",
    image: "https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?auto=format&fit=crop&q=80&w=400",
    difficulty: "Beginner",
    duration: "2 hours",
    price: "\$95",
    rating: 4.9,
    reviews: 128,
    guideName: "Sarah Johnson",
    guideImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=64",
  ),
  Tour(
    id: "2",
    name: "Mountain Trail Adventure",
    location: "Highland Path",
    image: "https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?auto=format&fit=crop&q=80&w=400",
    difficulty: "Intermediate",
    duration: "3 hours",
    price: "\$120",
    rating: 4.8,
    reviews: 96,
    guideName: "Michael Thompson",
    guideImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=64",
  ),
];

class TourCards extends StatelessWidget {
  final String? selectedTour;
  final Function(String id) onSelect;

  const TourCards({
    super.key,
    required this.selectedTour,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tours.map((tour) {
        final isSelected = selectedTour == tour.id;
        return GestureDetector(
          onTap: () => onSelect(tour.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 16),
            transform: isSelected ? Matrix4.identity()*(1.02) : Matrix4.identity(),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: isSelected
                  ? [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))]
                  : [],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tour Image with Price Tag
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        tour.image,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tour.price,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Title + Location + Rating
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tour.name,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.pin_drop, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(tour.location,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.grey)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  size: 14, color: Color(0xFFFFC107)),
                              const SizedBox(width: 4),
                              Text('${tour.rating}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              Text(' (${tour.reviews})',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Difficulty and Duration
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF723594).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tour.difficulty,
                              style: const TextStyle(
                                  color: Color(0xFF723594), fontSize: 13),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              const Icon(Icons.timelapse, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(tour.duration,
                                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(),

                      // Guide Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(tour.guideImage),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tour.guideName,
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w500)),
                                const Text("Your Guide",
                                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Text(
                            "View Details",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF723594),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
