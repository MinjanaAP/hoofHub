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

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'],
      name: json['title'],
      location: json['location'] ?? 'Unknown Location',
      image: (json['images'] as List).isNotEmpty ? json['images'][0] : '',
      difficulty: json['difficulty'] ?? 'Beginner',
      duration: json['duration'] ?? '1 hour',
      price: '\$${json['price'] ?? '0'}',
      rating: (json['rating'] ?? 4.5).toDouble(),
      reviews: json['reviews'] ?? 0,
      guideName: json['guide']?['name'] ?? 'Unknown Guide',
      guideImage: json['guide']?['image'] ?? '',
    );
  }
}
