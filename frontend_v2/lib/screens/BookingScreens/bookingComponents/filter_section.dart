import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  final Function(String)? onSortChanged;
  final Function(String)? onLocationChanged;
  final Function(String)? onDifficultyChanged;

  const FilterSection({
    super.key,
    this.onSortChanged,
    this.onLocationChanged,
    this.onDifficultyChanged,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  String activeSort = 'rating';
  String selectedLocation = 'All';
  String selectedDifficulty = 'All';

  final List<Map<String, String>> sortOptions = [
    {'id': 'rating', 'label': 'Top Rated'},
    {'id': 'duration', 'label': 'Duration'},
    {'id': 'price', 'label': 'Price'},
  ];

  final List<String> locationOptions = ['All', 'Knuckles Range', 'Bentota Beach', 'Nuwara Eliya', 'Pannala Horse Farm', 'australia'];
  final List<String> difficultyOptions = ['All', 'Very Easy', 'Easy', 'Medium', 'Hard'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //? Sort Options
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
                      widget.onSortChanged?.call(option['id']!);
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
          ],
        ),
        const SizedBox(height: 12),
        
        //? Filter Chips
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildLocationFilter(),
              const SizedBox(width: 8),
              _buildDifficultyFilter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationFilter() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() => selectedLocation = value);
        widget.onLocationChanged?.call(value);
      },
      itemBuilder: (context) => locationOptions.map((location) {
        return PopupMenuItem(
          value: location,
          child: Text(location),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedLocation != 'All' 
              ? const Color(0xFF723594).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedLocation != 'All' 
                ? const Color(0xFF723594)
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLocation == 'All' ? 'Location' : selectedLocation,
              style: TextStyle(
                color: selectedLocation != 'All' 
                    ? const Color(0xFF723594)
                    : Colors.grey[800],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: selectedLocation != 'All' 
                  ? const Color(0xFF723594)
                  : Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyFilter() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() => selectedDifficulty = value);
        widget.onDifficultyChanged?.call(value);
      },
      itemBuilder: (context) => difficultyOptions.map((difficulty) {
        return PopupMenuItem(
          value: difficulty,
          child: Text(difficulty),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedDifficulty != 'All' 
              ? const Color(0xFF723594).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedDifficulty != 'All' 
                ? const Color(0xFF723594)
                : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedDifficulty == 'All' ? 'Difficulty' : selectedDifficulty,
              style: TextStyle(
                color: selectedDifficulty != 'All' 
                    ? const Color(0xFF723594)
                    : Colors.grey[800],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: selectedDifficulty != 'All' 
                  ? const Color(0xFF723594)
                  : Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}