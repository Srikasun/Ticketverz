import 'package:flutter/material.dart';
import 'package:ticketverz/screens/scan_history_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket Scanner"),
        centerTitle: true,
        backgroundColor: Colors.grey[300], // App bar matches neumorphic theme
        elevation: 0,
      ),
      body: Column(
        children: [
          // Scan Ticket Container
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScannerScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Light base color for neumorphism
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    // Light shadow for the top-left
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-6, -6),
                      blurRadius: 12,
                    ),
                    // Dark shadow for the bottom-right
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: Offset(6, 6),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Scan Ticket",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Scan History Container
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ScanHistoryScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Light base color for neumorphism
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    // Light shadow for the top-left
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-6, -6),
                      blurRadius: 12,
                    ),
                    // Dark shadow for the bottom-right
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      offset: Offset(6, 6),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Scan History",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[300], // Background color for neumorphism
    );
  }
}
