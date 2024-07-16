import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Authentication/AuthProvider.dart';
import '/Admin/UserListScreen.dart';
import '/Authentication/config.dart'; // Import Config class

class AdminDashboardScreen extends StatefulWidget {
  static const routeName = '/admin-dashboard';

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(UserListScreen.routeName);
          },
          child: Text('Daftar User'),
        ),
      ),
    );
  }
}
