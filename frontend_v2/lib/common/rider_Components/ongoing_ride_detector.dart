// ongoing_ride_detector.dart
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:frontend/theme.dart';

class OngoingRideDetector extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>>? ongoingRide;
  final VoidCallback onTap;

  const OngoingRideDetector({
    Key? key,
    required this.ongoingRide,
    required this.onTap,
  }) : super(key: key);

  @override
  _OngoingRideDetectorState createState() => _OngoingRideDetectorState();
}

class _OngoingRideDetectorState extends State<OngoingRideDetector>
    with TickerProviderStateMixin { 
  late AnimationController _pulseController;
  late AnimationController _iconController;
  late AnimationController _chevronController;
  late AnimationController _liveIndicatorController;

  @override
  void initState() {
    super.initState();
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    _chevronController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _liveIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _iconController.dispose();
    _chevronController.dispose();
    _liveIndicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rideData = widget.ongoingRide?.data();
    final rideId = rideData?['rideId'] ?? "Heading to your destination";

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 114, 53, 147), Color.fromARGB(172, 114, 53, 147)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(40),
          boxShadow:const [
            BoxShadow(
              color:  Color.fromARGB(113, 114, 53, 147),
              blurRadius: 15,
              offset:  Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Animated background elements
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            
            // Pulsing animation
            Positioned.fill(
              child: _PulseAnimation(controller: _pulseController),
            ),
            
            Row(
              children: [
                // Animated icon container
                _AnimatedIconContainer(controller: _iconController),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        " Ride in Progress",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 2,
                              color: Colors.black26,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        rideId,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Live progress indicator
                      _LiveProgressIndicator(controller: _liveIndicatorController),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Animated chevron
                _AnimatedChevron(controller: _chevronController),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pulsing background animation
class _PulseAnimation extends StatelessWidget {
  final AnimationController controller;

  const _PulseAnimation({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _PulsePainter(controller.value),
        );
      },
    );
  }
}

class _PulsePainter extends CustomPainter {
  final double animationValue;

  _PulsePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * (0.8 + animationValue * 0.2);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05 * (1 - animationValue))
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _PulsePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// Animated icon container
class _AnimatedIconContainer extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedIconContainer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 0.1 * Math.sin(controller.value * 2 * Math.pi),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration:const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:  Color.fromARGB(131, 114, 53, 147),
                  blurRadius: 10,
                  offset:  Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.directions_outlined,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        );
      },
    );
  }
}

// Live progress indicator
class _LiveProgressIndicator extends StatelessWidget {
  final AnimationController controller;

  const _LiveProgressIndicator({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Live indicator
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(controller.value > 0.5 ? 1.0 : 0.6),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
        const SizedBox(width: 6),
        const Text(
          "LIVE",
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: LinearProgressIndicator(
            value: 0.7, // You can replace this with actual progress
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

// Animated chevron
class _AnimatedChevron extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedChevron({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.2, 0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    return SlideTransition(
      position: animation,
      child: const Icon(
        Icons.chevron_right,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}