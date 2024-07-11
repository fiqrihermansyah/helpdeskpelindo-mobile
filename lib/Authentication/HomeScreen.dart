import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import '/User/CreateSubmissionScreen.dart'; // Import CreateSubmissionScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/pelindo.png'),
        title: Text('Help Desk Support'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              if (result == 'logout') {
                authProvider.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              } else if (result == 'tiketsaya') {
                Navigator.of(context).pushNamed('/tiketsaya');
              } else if (result == 'submissionsaya') {
                Navigator.of(context).pushNamed('/submissionsaya');
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'tiketsaya',
                child: Text('Tiket Saya'),
              ),
              const PopupMenuItem<String>(
                value: 'submissionsaya',
                child: Text('Submission Saya'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Help Desk Support',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/image1.png', width: 100, height: 100),
                SizedBox(width: 20),
                Image.asset('assets/image2.png', width: 100, height: 100),
                SizedBox(width: 20),
                Image.asset('assets/image3.png', width: 100, height: 100),
              ],
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    '/createTicket'); // Navigasi ke halaman pengajuan tiket
              },
              child: Text('Ajukan Tiket'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CreateSubmissionScreen
                    .routeName); // Navigasi ke halaman pengajuan submission
              },
              child: Text('Ajukan Submission'),
            ),
          ],
        ),
      ),
    );
  }
}
