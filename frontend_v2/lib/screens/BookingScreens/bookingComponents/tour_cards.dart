import 'package:flutter/material.dart';
import 'package:frontend/models/tour_model.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/services/api_service.dart';

class TourCards extends StatefulWidget {
  final String? selectedTour;
  final Function(String id) onSelect;
  final Function(bool)? onLoading;
  final String searchQuery;
  final String locationFilter;
  final String difficultyFilter;
  final String sortBy;

  const TourCards({
    super.key,
    required this.selectedTour,
    required this.onSelect,
    this.onLoading,
    this.searchQuery = '',
    this.locationFilter = 'All',
    this.difficultyFilter = 'All',
    this.sortBy = 'rating',
  });

  @override
  State<TourCards> createState() => _TourCardsState();
}

class _TourCardsState extends State<TourCards> {
  List<Tour> _tours = [];
  List<Tour> _filteredTours = [];
  bool isLoading = true;

  void _notifyParentLoading(bool loading) {
    if (widget.onLoading == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onLoading!(loading);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTours();
  }

  @override
  void didUpdateWidget(covariant TourCards oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.locationFilter != widget.locationFilter ||
        oldWidget.difficultyFilter != widget.difficultyFilter ||
        oldWidget.sortBy != widget.sortBy) {
      _applyFiltersAndSort();
    }
  }

  Future<void> fetchTours() async {
    _notifyParentLoading(true);
    try {
      final response = await ApiService.dio.get('/rides');
      final rides = response.data;
      // logger.i("Fetched rides: $rides");
      setState(() {
        _tours = rides
            .map<Tour>((json) => Tour.fromApi(json as Map<String, dynamic>))
            .toList();
        _applyFiltersAndSort();
        isLoading = false;
      });
      logger.i("Tours fetched successfully: ${_tours.length}");
    } catch (e) {
      logger.e("Error fetching tours: $e");
      setState(() => isLoading = false);
    } finally {
      _notifyParentLoading(false);
    }
  }

  void _applyFiltersAndSort() {
    //* Apply filters first
    _filteredTours = _tours.where((tour) {
      // Search filter
      final matchesSearch = widget.searchQuery.isEmpty ||
          tour.name.toLowerCase().contains(widget.searchQuery.toLowerCase()) ||
          tour.location
              .toLowerCase()
              .contains(widget.searchQuery.toLowerCase());

      //* Location filter
      final matchesLocation = widget.locationFilter == 'All' ||
          tour.location == widget.locationFilter;

      //* Difficulty filter
      final matchesDifficulty = widget.difficultyFilter == 'All' ||
          (tour.specifications?['difficulty']?.toString().toLowerCase() ??
                  '') ==
              widget.difficultyFilter.toLowerCase();

      return matchesSearch && matchesLocation && matchesDifficulty;
    }).toList();

    _applySorting();
  }

  void _applySorting() {
    switch (widget.sortBy) {
      case 'rating':
        _filteredTours.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price':
        _filteredTours.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'duration':
        _filteredTours.sort((a, b) {
          // Extract numeric value from duration string (e.g., "2 hours" -> 2)
          final aDuration = _parseDuration(a.duration);
          final bDuration = _parseDuration(b.duration);
          return aDuration.compareTo(bDuration);
        });
        break;
      default:
        _filteredTours.sort((a, b) => b.rating.compareTo(a.rating));
    }
  }

  int _parseDuration(String duration) {
    try {
      //* Extract duration in h s
      final regex = RegExp(r'(\d+)');
      final match = regex.firstMatch(duration);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_filteredTours.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              "No tours found",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "Try adjusting your search or filters",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true, // important inside another scrollable
      physics: const NeverScrollableScrollPhysics(), // parent ListView scrolls
      itemCount: _filteredTours.length,
      itemBuilder: (context, index) {
        final tour = _filteredTours[index];
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
      },
    );
  }

  Widget buildTourCard(Tour tour) {
    final isSelected = widget.selectedTour == tour.id;
    final difficulty =
        tour.specifications?['difficulty'] as String? ?? 'Not specified';

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
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child:
                      const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
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
                  'LKR ${tour.price}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
                      difficulty,
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: (tour.guideImage.isNotEmpty)
                        ? NetworkImage(tour.guideImage)
                        : null,
                    child: tour.guideImage.isEmpty
                        ? const Icon(Icons.person, size: 16)
                        : null,
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
