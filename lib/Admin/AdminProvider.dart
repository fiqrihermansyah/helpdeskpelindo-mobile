import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminProvider with ChangeNotifier {
  List _users = [];

  List get users => _users;

  Future<void> fetchUsers() async {
    final url = 'http://your-laravel-api-url/api/users';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _users = json.decode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateUserRole(int userId, String role) async {
    final url = 'http://your-laravel-api-url/api/users/$userId';
    final response = await http.put(
      Uri.parse(url),
      body: json.encode({
        'role': role,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      throw Exception('Failed to update user role');
    }
  }
}
