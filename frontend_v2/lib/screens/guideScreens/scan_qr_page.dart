import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/common/custom_appbar.dart';
import 'package:frontend/constant/api_constants.dart';
import 'package:frontend/routes/app_routes.dart';
import 'package:frontend/screens/guideScreens/ride_start_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class ScanQRPage extends StatefulWidget {
  const ScanQRPage({super.key});

  @override
  State<ScanQRPage> createState() => _ScanQRPageState();
}

class _ScanQRPageState extends State<ScanQRPage> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;
  String? lastScannedCode;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    cameraController.dispose();
    super.dispose();
  }

  void _initializeCamera() {
    cameraController = MobileScannerController(
      facing: CameraFacing.back,
      formats: [BarcodeFormat.qrCode],
      returnImage: false,
    );
  }

  Future<void> verifyToken(String token) async {
    if (isProcessing || lastScannedCode == token) return;
    
    setState(() {
      isProcessing = true;
      lastScannedCode = token;
    });

    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/bookings/verify-qr"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['success'] == true) {
          // _showSuccessAlert("QR Code verified successfully!");
          if (mounted) {
            Navigator.pushReplacement(context, 
              MaterialPageRoute(
                builder: (context) => RideStartPage(apiResponse: data),
              ),
            );
          }
        } else {
          _showAlert(data['msg'] ?? "Invalid QR code");
        }
      } else {
        _showAlert("Server error: ${response.statusCode}");
      }
    } catch (e) {
      _showAlert("Error verifying QR: ${e.toString()}");
    } finally {
      setState(() => isProcessing = false);
      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => lastScannedCode = null);
        }
      });
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("QR Verification Failed"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSuccessAlert(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Success", style: TextStyle(color: Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Scan Rider QR Code", showBackButton: true),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              
              if (barcodes.isNotEmpty) {
                final String? code = barcodes.first.rawValue;
                
                if (code != null && code.isNotEmpty) {
                  _debounceTimer?.cancel();
                  _debounceTimer = Timer(const Duration(milliseconds: 500), () {
                    verifyToken(code);
                  });
                }
              }
            },
          ),

          _buildScannerOverlay(),

          if (isProcessing)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black54,
          child: const Text(
            "Position the QR code within the frame",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),

        Expanded(
          child: Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: _ScannerOverlayPainter(),
              ),
            ),
          ),
        ),

        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black54,
          child: const Text(
            "Scan the Rider's QR code to verify booking",
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      paint,
    );

    // Draw corner angles
    final cornerLength = 20.0;
    final cornerWidth = 4.0;

    final cornerPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = cornerWidth
      ..style = PaintingStyle.stroke;

    
    canvas.drawLine(Offset.zero, Offset(cornerLength, 0), cornerPaint);
    canvas.drawLine(Offset.zero, Offset(0, cornerLength), cornerPaint);

    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - cornerLength, 0), cornerPaint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, cornerLength), cornerPaint);

    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height - cornerLength), cornerPaint);
    canvas.drawLine(Offset(0, size.height),
        Offset(cornerLength, size.height), cornerPaint);

    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), cornerPaint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}