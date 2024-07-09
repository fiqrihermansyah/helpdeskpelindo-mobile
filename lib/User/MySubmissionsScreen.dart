import 'package:flutter/material.dart';

class MySubmissionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission Saya'),
      ),
      body: Center(
        child: Text('Daftar submission saya akan ditampilkan di sini.'),
      ),
    );
  }
}
