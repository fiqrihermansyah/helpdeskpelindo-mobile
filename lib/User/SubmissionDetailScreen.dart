import 'package:flutter/material.dart';

class SubmissionDetailScreen extends StatelessWidget {
  static const routeName = '/submission-detail';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> submission =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    String getStatusLabel(String status) {
      switch (status) {
        case 'New':
          return 'New';
        case 'Progress':
          return 'Progress';
        case 'Sudah Ditetapkan':
          return 'Sudah Ditetapkan';
        default:
          return status;
      }
    }

    Color getStatusColor(String status) {
      switch (status) {
        case 'New':
          return Colors.red[200]!;
        case 'Progress':
          return Colors.yellow[200]!;
        case 'Sudah Ditetapkan':
          return Colors.green[200]!;
        default:
          return Colors.grey[200]!;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Submission #${submission['id']}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    submission['nomor_ppkb'] ?? 'Nomor PPKB tidak tersedia',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    decoration: BoxDecoration(
                      color: getStatusColor(submission['status']),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      getStatusLabel(submission['status']),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'PPKB Ke: ${submission['ppkb_ke'] ?? 'PPKB Ke tidak tersedia'}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: Text('Service Code'),
                  subtitle: Text(submission['service_code'] ??
                      'Service Code tidak tersedia'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Nama Kapal'),
                  subtitle: Text(
                      submission['nama_kapal'] ?? 'Nama Kapal tidak tersedia'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Keagenan'),
                  subtitle:
                      Text(submission['keagenan'] ?? 'Keagenan tidak tersedia'),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
