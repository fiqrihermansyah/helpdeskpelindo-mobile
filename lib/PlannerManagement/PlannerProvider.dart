import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlannerProvider with ChangeNotifier {
  List _submissions = [];

  List get submissions => _submissions;

  Future<void> fetchSubmissions() async {
    final url = 'http://your-laravel-api-url/api/submissions';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _submissions = json.decode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load submissions');
    }
  }

  Future<void> closeSubmission(int submissionId) async {
    final url =
        'http://your-laravel-api-url/api/submissions/$submissionId/close';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      fetchSubmissions();
    } else {
      throw Exception('Failed to close submission');
    }
  }

  Future<void> reopenSubmission(int submissionId) async {
    final url =
        'http://your-laravel-api-url/api/submissions/$submissionId/reopen';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      fetchSubmissions();
    } else {
      throw Exception('Failed to reopen submission');
    }
  }
}
