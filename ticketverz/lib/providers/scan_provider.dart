import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ticketverz/Models/scan_result.dart';

// List of recent scans
final recentScansProvider =
    StateNotifierProvider<RecentScansNotifier, List<ScanResult>>(
  (ref) => RecentScansNotifier(),
);

class RecentScansNotifier extends StateNotifier<List<ScanResult>> {
  RecentScansNotifier() : super([]);

  void addScan(ScanResult scan) {
    state = [...state, scan];
  }
}
