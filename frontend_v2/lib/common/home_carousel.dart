import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:frontend/theme.dart';

class HomeCarousel extends StatelessWidget {
  final List<String> imageUrls = [
    "https://images.pexels.com/photos/3764466/pexels-photo-3764466.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/2980870/pexels-photo-2980870.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/3764466/pexels-photo-3764466.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/2980870/pexels-photo-2980870.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "https://images.pexels.com/photos/3764466/pexels-photo-3764466.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
  ];

  HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CarouselSlider(
        items: imageUrls.map((url) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              Container(
                margin: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black.withOpacity(0.4), // Dark overlay
                ),
              ),

              Positioned(
                left: 20.0,
                right: 20.0,
                top: 50.0,
                child: Align(
                  alignment: Alignment.bottomRight, 
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Enjoy seamless",
                        textAlign: TextAlign.end, 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "riding",
                        textAlign: TextAlign.end, 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        "experience !",
                        textAlign: TextAlign.end, 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12.0,),
                      SizedBox(
                        width: 150.0,
                        child: ElevatedButton(
                          onPressed: (){}, 
                          child:const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.add_circle_outline ),
                              SizedBox(width: 6.0,),
                              Text('Book Rides',
                                style: TextStyle(
                                fontFamily: 'Poppins',
                                color: AppColors.primary,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w900,
                              ),
                              ),
                            ],
                          )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        options: CarouselOptions(
          height: 220.0,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 1,
        ),
      ),
    );
  }
}
