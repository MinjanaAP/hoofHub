// models/ride_model.dart
class Ride {
  final String id;
  final String title;
  final String location;
  final int price;
  final String imageUrl;

  Ride({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.imageUrl,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      price: json['price'],
      imageUrl: (json['images'] as List).isNotEmpty ? json['images'][0] : '',
    );
  }
}
