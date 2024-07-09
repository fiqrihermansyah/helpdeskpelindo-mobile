// TicketDetailScreen.dart
import 'package:flutter/material.dart';

class TicketDetailScreen extends StatelessWidget {
  static const routeName = '/ticketDetails';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticket =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Tiket'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${ticket['ticket_id']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Judul: ${ticket['judul']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Pengaju: ${ticket['pengaju']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Aplikasi: ${ticket['aplikasi']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Tanggal Dibuat: ${DateTime.parse(ticket['created_at']).toLocal().toString().split(' ')[0]}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Prioritas: ${ticket['prioritas']['nama_prioritas']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Status: ${ticket['status']['nama_status']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Deskripsi: ${ticket['deskripsi']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
