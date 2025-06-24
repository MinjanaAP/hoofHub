class Horse {
  final String name;
  final String image;
  final String breed;
  final String experience;

  Horse({
    required this.name,
    required this.image,
    required this.breed,
    required this.experience,
  });

  factory Horse.fromJson(Map<String, dynamic> json) {
    return Horse(
      name: json['name'],
      image: json['image'],
      breed: json['breed'],
      experience: json['experience'],
    );
  }
}
