import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Authentication/AuthProvider.dart';
import '/Authentication/config.dart'; // Impor kelas Config

class CreateSubmissionScreen extends StatefulWidget {
  static const routeName = '/create-submission';

  @override
  _CreateSubmissionScreenState createState() => _CreateSubmissionScreenState();
}

class _CreateSubmissionScreenState extends State<CreateSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomorPpkbController = TextEditingController();
  final _ppkbKeController = TextEditingController();
  String _serviceCode = 'Pindah';
  final _namaKapalController = TextEditingController();
  final _keagenanController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitSubmission() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      var response = await submitSubmission(
        token,
        _nomorPpkbController.text,
        int.parse(_ppkbKeController.text),
        _serviceCode,
        _namaKapalController.text,
        _keagenanController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (response['status'] == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response['message'])));
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Failed to submit submission: ${response['message']}')));
      }
    }
  }

  Future<Map<String, dynamic>> submitSubmission(
    String token,
    String nomorPpkb,
    int ppkbKe,
    String serviceCode,
    String namaKapal,
    String keagenan,
  ) async {
    var uri = Uri.parse('${Config.baseUrl}/api/submissions');
    var request = http.Request('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['Accept'] = 'application/json'
      ..bodyFields = {
        'nomor_ppkb': nomorPpkb,
        'ppkb_ke': ppkbKe.toString(),
        'service_code': serviceCode,
        'nama_kapal': namaKapal,
        'keagenan': keagenan,
        'status': 'New', // Set status to 'New'
      };

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    return {
      'status': response.statusCode,
      'message':
          json.decode(response.body)['message'] ?? 'Something went wrong',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Submission'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _nomorPpkbController,
                      decoration: InputDecoration(labelText: 'Nomor PPKB'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor PPKB tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ppkbKeController,
                      decoration: InputDecoration(labelText: 'PPKB Ke'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'PPKB Ke tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField(
                      value: _serviceCode,
                      items: [
                        'Pindah',
                        'Tambat',
                        'Perpanjangan',
                        'Keberangkatan',
                        'Labuh'
                      ]
                          .map((serviceCode) => DropdownMenuItem(
                                child: Text(serviceCode),
                                value: serviceCode,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _serviceCode = value as String;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Service Code'),
                    ),
                    TextFormField(
                      controller: _namaKapalController,
                      decoration: InputDecoration(labelText: 'Nama Kapal'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Kapal tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _keagenanController,
                      decoration: InputDecoration(labelText: 'Keagenan'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keagenan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _submitSubmission,
                      child: Text('Kirim'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
