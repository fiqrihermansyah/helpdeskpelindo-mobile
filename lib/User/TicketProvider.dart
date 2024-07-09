import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TicketProvider with ChangeNotifier {
  List _tickets = [];

  List get tickets => _tickets;

  Future<void> fetchTickets() async {
    final url = 'http://your-laravel-api-url/api/tickets';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _tickets = json.decode(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  Future<void> createTicket(String title, String description) async {
    final url = 'http://your-laravel-api-url/api/tickets';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'title': title,
        'description': description,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 201) {
      fetchTickets();
    } else {
      throw Exception('Failed to create ticket');
    }
  }
}
