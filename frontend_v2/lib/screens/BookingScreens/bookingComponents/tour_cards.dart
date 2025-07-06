import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/models/tour_model.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/skeletons/custom_loading_page.dart';
import 'package:http/http.dart' as http;

class TourCards extends StatefulWidget {
  final String? selectedTour;
  final Function(String id) onSelect;
  final Function(bool)? onLoading;

  const TourCards({
    super.key,
    required this.selectedTour,
    required this.onSelect,
    this.onLoading,
  });

  @override
  State<TourCards> createState() => _TourCardsState();
}

class _TourCardsState extends State<TourCards> {
  List<Tour> _tours = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTours();
  }

  Future<void> fetchTours() async {
    widget.onLoading?.call(true);
    try {
      final response =
          await http.get(Uri.parse("${ApiConstants.baseUrl}/rides"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tours = data.map((json) => Tour.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load tours");
      }
    } catch (e) {
      print("Error fetching tours: $e");
      setState(() => isLoading = false);
    }finally {
    widget.onLoading?.call(false);
  }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // return const CustomLoadingScreen();
      return const SizedBox.shrink();
    }

    if (_tours.isEmpty) {
      return const Center(child: Text("No tours available."));
    }

    return Column(
      children: _tours.map((tour) {
        final isSelected = widget.selectedTour == tour.id;
        return GestureDetector(
          onTap: () => widget.onSelect(tour.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 16),
            transform:
                isSelected ? Matrix4.identity() * 1.02 : Matrix4.identity(),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: isSelected
                  ? [
                      const BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4))
                    ]
                  : [],
              borderRadius: BorderRadius.circular(16),
            ),
            child: buildTourCard(tour),
          ),
        );
      }).toList(),
    );
  }

  Widget buildTourCard(Tour tour) {
    final isSelected = widget.selectedTour == tour.id;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(           
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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

            // ✅ Selection check mark
            if (isSelected)
              const Positioned(
                top: 12,
                left: 12,
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFF723594),
                  size: 24,
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
                            const Icon(Icons.pin_drop,
                                size: 14, color: Colors.grey),
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
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      Text(' (${tour.reviews})',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Difficulty and Duration
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
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
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.ridePage,
                      arguments: tour.id);
                    },
                    child: const Text(
                      "View Details",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF723594),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
