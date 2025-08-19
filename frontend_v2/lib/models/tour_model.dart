class Tour {
  final String id;
  final String name;
  final String location;
  final String image;
  final double price;
  final double rating;
  final int reviews;
  final String duration;
  final String guideName;
  final String guideImage;
  final Map<String, dynamic>? specifications;

  Tour({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.duration,
    required this.guideName,
    required this.guideImage,
    this.specifications,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      image: json['image'],
      price: json['price'].toDouble(),
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      duration: json['duration'],
      guideName: json['guideName'],
      guideImage: json['guideImage'],
      specifications: json['specifications'] as Map<String, dynamic>?,
    );
  }

  // More forgiving factory that maps the API shape used by our backend
  // which typically returns: title, images[], location, price, rating, reviews, duration, guide{fullName, profileImage}
  factory Tour.fromApi(Map<String, dynamic> json) {
    final dynamic imagesValue = json['images'];
    String resolvedImage = '';
    if (imagesValue is List && imagesValue.isNotEmpty) {
      final first = imagesValue.first;
      if (first is String) {
        resolvedImage = first;
      }
    } else if (json['image'] is String) {
      resolvedImage = json['image'] as String;
    }

    final Map<String, dynamic>? guide = json['guide'] is Map<String, dynamic>
        ? json['guide'] as Map<String, dynamic>
        : null;

    return Tour(
      id: (json['id'] ?? json['_id']).toString(),
      name: (json['title'] ?? json['name'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      image: resolvedImage,
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : 0.0,
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0.0,
      reviews: (json['reviews'] is num) ? (json['reviews'] as num).toInt() : 0,
      duration: (json['duration'] ?? '').toString(),
      guideName: (guide != null
              ? (guide['fullName'] ?? guide['name'])
              : (json['guideName'] ?? ''))
          .toString(),
      guideImage: (guide != null
              ? (guide['profileImage'] ?? guide['image'])
              : (json['guideImage'] ?? ''))
          .toString(),
      specifications: json['specifications'] is Map<String, dynamic>
          ? json['specifications'] as Map<String, dynamic>
          : null,
    );
  }
}