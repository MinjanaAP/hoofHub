// widgets/ride_area_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/models/ride_model.dart';


class _RideAreaCard extends StatelessWidget {
  final Ride ride;
  const _RideAreaCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              ride.imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ride.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(ride.location,
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 4),
                Text('Rs. ${ride.price.toString()}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.green)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
