import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/scan_provider.dart';
import '../widgets/ticket_card.dart';

class ScanHistoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetch the list of recent scans from the provider
    final recentScans = ref.watch(recentScansProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Scan History"),
      ),
      body: recentScans.isEmpty
          ? Center(
              child: Text(
                "No scans available.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: recentScans.length,
              itemBuilder: (context, index) {
                final scan = recentScans[index];
                return TicketCard(ticket: scan);
              },
            ),
    );
  }
}
