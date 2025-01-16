import 'package:flutter/material.dart';
import 'package:ticketverz/Models/scan_result.dart';

class TicketCard extends StatelessWidget {
  final ScanResult ticket;

  const TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        title: Text(ticket.movieName),
        subtitle: Text("Date: ${ticket.date}, Time: ${ticket.time}"),
        trailing: Icon(
          ticket.isValid ? Icons.check_circle : Icons.error,
          color: ticket.isValid ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
