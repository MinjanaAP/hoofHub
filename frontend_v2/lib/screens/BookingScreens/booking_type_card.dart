import 'package:flutter/material.dart';


class BookingType {
  final String id;
  final String title;
  final String description;
  final IconData icon;

  BookingType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

final List<BookingType> bookingTypes = [
  BookingType(
    id: 'single',
    title: 'Single Ride',
    description: 'A solo adventure on horseback',
    icon: Icons.person_2_outlined
  ),
  BookingType(
    id: 'couple',
    title: 'Couple Ride',
    description: 'A romantic experience for two',
    icon: Icons.heart_broken_outlined
  ),
  BookingType(
    id: 'kids',
    title: 'Kids Ride',
    description: 'Safe and fun riding for children',
    icon: Icons.baby_changing_station_outlined
  ),
  BookingType(
    id: 'group',
    title: 'Group Ride',
    description: 'Ride with friends or family',
    icon: Icons.people_alt_outlined
  ),
];

class BookingTypeCards extends StatelessWidget {
  final String? selectedType;
  final Function(String) onSelect;

  const BookingTypeCards({
    Key? key,
    required this.selectedType,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: .8,
      physics: const NeverScrollableScrollPhysics(),
      children: bookingTypes.map((type) {
        final bool isSelected = selectedType == type.id;
        return GestureDetector(
          onTap: () => onSelect(type.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF723594) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                if (isSelected)
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                else
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : const Color(0xFF723594).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    type.icon,
                    size: 28,
                    color: isSelected ? Colors.white : const Color(0xFF723594),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  type.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  type.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isSelected
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey[600],
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
