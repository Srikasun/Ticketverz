import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isScanning = false;
  bool _flashOn = false;

  // Function to handle API call for QR code verification
  Future<void> verifyQrCode(String qrCodeData) async {
    setState(() {
      _isScanning = true;
    });

    final url =
        Uri.parse("https://api.ticketverz.com/api/bookings/verifyQrCode");
    final body = jsonEncode({"qrCodeData": qrCodeData});
    final headers = {
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData["status"] == "Ok" && responseData["code"] == 200) {
          _showResultDialog(
            title: "Success",
            message: "The ticket is valid!",
            isValid: true,
          );
        } else {
          _showResultDialog(
            title: "Invalid Ticket",
            message: "The ticket is not valid.",
            isValid: false,
          );
        }
      } else {
        _showResultDialog(
          title: "Error",
          message: "Failed to verify the ticket. Please try again.",
          isValid: false,
        );
      }
    } catch (e) {
      _showResultDialog(
        title: "Network Error",
        message: "An error occurred: $e",
        isValid: false,
      );
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  // Function to show result dialog
  void _showResultDialog(
      {required String title, required String message, required bool isValid}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Handle QR code detection
  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isNotEmpty && !_isScanning) {
      final qrCodeData = capture.barcodes.first.rawValue ?? 'Unknown';
      verifyQrCode(qrCodeData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: Stack(
        children: [
          // Camera scanner view
          MobileScanner(
            onDetect: _onDetect,
          ),
          // Flash and Camera Controls
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Flash toggle button
                IconButton(
                  icon: Icon(
                    _flashOn ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      _flashOn = !_flashOn;
                    });
                    MobileScannerController().toggleTorch(); // Toggle flash
                  },
                ),
                // Switch camera button
                IconButton(
                  icon: Icon(
                    Icons.cameraswitch,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    MobileScannerController().switchCamera(); // Switch camera
                  },
                ),
              ],
            ),
          ),
          if (_isScanning)
            Center(
              child: CircularProgressIndicator(), // Show loader while scanning
            ),
        ],
      ),
    );
  }
}
