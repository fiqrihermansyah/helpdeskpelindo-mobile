import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Authentication/AuthProvider.dart';
import '/Authentication/config.dart'; // Impor kelas Config
import '/User/SubmissionDetailScreen.dart';

class MySubmissionsScreen extends StatefulWidget {
  static const routeName = '/submissionsaya';

  @override
  _MySubmissionsScreenState createState() => _MySubmissionsScreenState();
}

class _MySubmissionsScreenState extends State<MySubmissionsScreen> {
  bool _isLoading = true;
  List<dynamic> _submissions = [];

  @override
  void initState() {
    super.initState();
    _fetchSubmissions();
  }

  Future<void> _fetchSubmissions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      final response = await http.get(
        Uri.parse('${Config.baseUrl}/api/submissions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _submissions = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load submissions: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching submissions: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submission Saya'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _submissions.isEmpty
              ? Center(child: Text('Tidak ada submission.'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Submission Saya',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Table(
                              columnWidths: {
                                0: FixedColumnWidth(50),
                                1: FlexColumnWidth(),
                                2: FlexColumnWidth(),
                                3: FlexColumnWidth(),
                                4: FlexColumnWidth(),
                                5: FlexColumnWidth(),
                                6: FlexColumnWidth(),
                                7: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(
                                  decoration:
                                      BoxDecoration(color: Colors.grey[300]),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('ID',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Nomor PPKB',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('PPKB Ke',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Service Code',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Nama Kapal',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Keagenan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Status',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Tanggal Dibuat',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                for (var submission in _submissions)
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Text(submission['id'].toString()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              SubmissionDetailScreen.routeName,
                                              arguments: submission,
                                            );
                                          },
                                          child: Text(
                                            submission['nomor_ppkb'] ?? '',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            submission['ppkb_ke'].toString() ??
                                                ''),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            submission['service_code'] ?? ''),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            submission['nama_kapal'] ?? ''),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            Text(submission['keagenan'] ?? ''),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: submission['status'] == 'New'
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2, horizontal: 8),
                                                decoration: BoxDecoration(
                                                  color: Colors.red[200],
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                child: Text(
                                                    submission['status'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              )
                                            : submission['status'] == 'Progress'
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 2,
                                                            horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      color: Colors.yellow[200],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Text(
                                                        submission['status'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  )
                                                : submission['status'] ==
                                                        'Sudah Ditetapkan'
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 2,
                                                                horizontal: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.green[200],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Text(
                                                            submission[
                                                                'status'],
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )
                                                    : Text(
                                                        submission['status']),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(submission['created_at']
                                                ?.substring(0, 10) ??
                                            ''),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
