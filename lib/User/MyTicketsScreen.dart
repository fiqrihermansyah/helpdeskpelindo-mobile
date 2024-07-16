import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Authentication/AuthProvider.dart';
import '/Authentication/config.dart'; // Impor kelas Config
import 'TicketDetailScreen.dart';
import 'CreateTicketScreen.dart';

class MyTicketsScreen extends StatelessWidget {
  Future<List<dynamic>> _fetchTickets(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/api/tickets'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load tickets');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket Saya'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchTickets(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada tiket yang ditemukan.'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateTicketScreen(),
                              ),
                            );
                          },
                          child: Text('+'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey[300],
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: constraints.maxWidth,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DataTable(
                                columnSpacing: constraints.maxWidth /
                                    7 *
                                    0.1, // Adjust as needed
                                headingRowColor:
                                    MaterialStateProperty.all(Colors.grey[300]),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Judul',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Pengaju',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Aplikasi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Tanggal Dibuat',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Prioritas',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: snapshot.data!.map<DataRow>((ticket) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                          Text(ticket['ticket_id'].toString())),
                                      DataCell(
                                        Text(
                                          ticket['judul'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            TicketDetailScreen.routeName,
                                            arguments: ticket,
                                          );
                                        },
                                      ),
                                      DataCell(Text(ticket['pengaju'])),
                                      DataCell(Text(ticket['aplikasi'])),
                                      DataCell(Text(
                                        DateTime.parse(ticket['created_at'])
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                      )),
                                      DataCell(Text(
                                        ticket['prioritas']['nama_prioritas'],
                                        style: TextStyle(
                                          color: _getPriorityColor(
                                              ticket['prioritas']
                                                  ['nama_prioritas']),
                                        ),
                                      )),
                                      DataCell(Text(
                                        ticket['status']['nama_status'],
                                        style: TextStyle(
                                          color: _getStatusColor(
                                              ticket['status']['nama_status']),
                                          backgroundColor:
                                              _getStatusBackgroundColor(
                                                  ticket['status']
                                                      ['nama_status']),
                                        ),
                                      )),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.black;
      case 'Pending':
        return Colors.black;
      case 'Closed':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  Color _getStatusBackgroundColor(String status) {
    switch (status) {
      case 'Open':
        return Colors.red[200]!;
      case 'Pending':
        return Colors.yellow[200]!;
      case 'Closed':
        return Colors.green[200]!;
      default:
        return Colors.grey;
    }
  }
}
