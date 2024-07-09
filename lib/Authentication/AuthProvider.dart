import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  List<String> _roles = [];
  String _nama = '';
  String _token = '';

  bool get isAuthenticated => _isAuthenticated;
  List<String> get roles => _roles;
  String get nama => _nama;
  String get token => _token;

  AuthProvider() {
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _nama = prefs.getString('nama') ?? '';
    _token = prefs.getString('token') ?? '';
    notifyListeners();
  }

  Future<void> login(String nipp, String password) async {
    final url = 'http://127.0.0.1:8000/api/auth/login';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'nipp': nipp,
          'password': password,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ??
            false) {
          final responseData = json.decode(response.body);

          if (responseData.containsKey('roles') &&
              responseData.containsKey('nama') &&
              responseData.containsKey('token')) {
            _isAuthenticated = true;
            _roles = List<String>.from(responseData['roles']);
            _nama = responseData['nama'];
            _token = responseData['token'];
            notifyListeners();

            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('isAuthenticated', true);
            prefs.setString('nama', _nama);
            prefs.setString('token', _token);
          } else {
            throw Exception('Missing fields in response');
          }
        } else {
          throw FormatException(
              'Unexpected content type: ${response.headers['content-type']}');
        }
      } else if (response.statusCode == 401) {
        print('Unauthenticated: ${response.body}');
        throw Exception('Unauthenticated: ${response.body}');
      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (error) {
      print('Login failed: $error');
      throw Exception('Failed to login: $error');
    }
  }

  Future<void> logout() async {
    if (!_isAuthenticated) {
      throw Exception('Not authenticated');
    }

    final url = 'http://127.0.0.1:8000/api/auth/logout';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        _isAuthenticated = false;
        _roles = [];
        _nama = '';
        _token = '';
        notifyListeners();

        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isAuthenticated', false);
        prefs.remove('nama');
        prefs.remove('token');
      } else {
        print('Logout failed: ${response.statusCode} ${response.body}');
        throw Exception('Failed to logout: ${response.statusCode}');
      }
    } catch (error) {
      print('Logout failed: $error');
      throw Exception('Failed to logout: $error');
    }
  }
}
