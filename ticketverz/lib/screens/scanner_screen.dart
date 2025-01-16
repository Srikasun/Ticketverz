import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ticketverz/Models/scan_result.dart';
import 'package:ticketverz/screens/scan_result_screen.dart';

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
          // Extract details from the response to create a ScanResult object
          final result = ScanResult(
            isValid: true,
            movieName: responseData["data"]["movieName"] ?? "Unknown",
            date: responseData["data"]["date"] ?? "Unknown",
            time: responseData["data"]["time"] ?? "Unknown",
            seatNumber: responseData["data"]["seatNumber"] ?? "Unknown",
          );

          // Navigate to ScanResultScreen with valid result data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanResultScreen(result: result),
            ),
          );
        } else {
          // Create an invalid ScanResult object
          final result = ScanResult(
            isValid: false,
            movieName: "N/A",
            date: "N/A",
            time: "N/A",
            seatNumber: "N/A",
          );

          // Navigate to ScanResultScreen with invalid result data
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScanResultScreen(result: result),
            ),
          );
        }
      } else {
        // Handle error response
        final result = ScanResult(
          isValid: false,
          movieName: "N/A",
          date: "N/A",
          time: "N/A",
          seatNumber: "N/A",
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ScanResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      // Handle network error
      final result = ScanResult(
        isValid: false,
        movieName: "N/A",
        date: "N/A",
        time: "N/A",
        seatNumber: "N/A",
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(result: result),
        ),
      );
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
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
