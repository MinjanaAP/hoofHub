import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  const FilterSection({super.key});

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  String activeSort = 'rating';

  final List<Map<String, String>> sortOptions = [
    {'id': 'rating', 'label': 'Top Rated'},
    {'id': 'duration', 'label': 'Duration'},
    {'id': 'price', 'label': 'Price'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 8,
                children: sortOptions.map((option) {
                  final isSelected = option['id'] == activeSort;
                  return ChoiceChip(
                    label: Text(option['label']!),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => activeSort = option['id']!);
                    },
                    selectedColor: const Color(0xFF723594),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[800],
                    ),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              filterChip('Location'),
              filterChip('Experience Level'),
              filterChip('Guide Availability'),
            ],
          ),
        ),
      ],
    );
  }

  Widget filterChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.arrow_downward, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
