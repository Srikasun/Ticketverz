import 'package:flutter/material.dart';
import 'package:ticketverz/Models/scan_result.dart';

class ScanResultScreen extends StatelessWidget {
  final ScanResult result;

  const ScanResultScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Result")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result.isValid ? "Valid Ticket!" : "Invalid Ticket!",
              style: TextStyle(
                color: result.isValid ? Colors.green : Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text("Movie: ${result.movieName}"),
            Text("Date: ${result.date}"),
            Text("Time: ${result.time}"),
            Text("Seat: ${result.seatNumber}"),
          ],
        ),
      ),
    );
  }
}
