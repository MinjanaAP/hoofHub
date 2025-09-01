import 'package:flutter/material.dart';

class ReviewItem extends StatelessWidget {
  final String name;
  final String review;
  final String timeAgo;
  final int starCount;
  const ReviewItem(
      {Key? key,
      required this.name,
      required this.review,
      required this.timeAgo,
      required this.starCount,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 13.0)),
                  Text(timeAgo, style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins', fontSize: 10.0)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: List.generate(
                    starCount,
                    (index) =>
                        const Icon(Icons.star_border_outlined, color: Colors.amber, size: 18)),
              ),
              const SizedBox(height: 5),
              Text(review, style: const TextStyle(color: Color.fromARGB(161, 0, 0, 0), fontFamily: 'Poppins', fontSize: 11.0, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
