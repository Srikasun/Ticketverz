class ScanResult {
  final String movieName;
  final String date;
  final String time;
  final String seatNumber;
  final bool isValid;

  ScanResult({
    required this.movieName,
    required this.date,
    required this.time,
    required this.seatNumber,
    required this.isValid,
  });
}
