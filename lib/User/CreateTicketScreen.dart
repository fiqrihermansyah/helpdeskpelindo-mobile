import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '/Authentication/AuthProvider.dart';

class CreateTicketScreen extends StatefulWidget {
  static const routeName = '/createTicket';

  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedApplication;
  String? _selectedPriority;
  String? _selectedDivision;
  File? _selectedFile;
  String? _selectedFileName;
  List<String> _applications = [
    'Simop Kapal',
    'FS',
    'Sampah Kapal',
    'Kepil',
    'Rupa-rupa',
    'Barang'
  ];
  List<Map<String, dynamic>> _priorities = [];
  List<Map<String, dynamic>> _divisions = [];

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    final priorityUrl = 'http://127.0.0.1:8000/api/priorities';
    final divisionUrl = 'http://127.0.0.1:8000/api/divisions';
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      final priorityResponse = await http.get(
        Uri.parse(priorityUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      final divisionResponse = await http.get(
        Uri.parse(divisionUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (priorityResponse.statusCode == 200 &&
          divisionResponse.statusCode == 200) {
        setState(() {
          _priorities = List<Map<String, dynamic>>.from(
              json.decode(priorityResponse.body));
          _divisions = List<Map<String, dynamic>>.from(
              json.decode(divisionResponse.body));
        });
      } else {
        print(
            'Failed to load dropdown data. Status codes: ${priorityResponse.statusCode}, ${divisionResponse.statusCode}');
        print('Priority response: ${priorityResponse.body}');
        print('Division response: ${divisionResponse.body}');
        throw Exception('Failed to load dropdown data');
      }
    } catch (error) {
      print('Error fetching dropdown data: $error');
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _selectedFileName = result.files.single.name; // Update the file name
      });
    }
  }

  Future<void> _submitTicket() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final nama = authProvider.nama ?? 'Unknown User';
      final token =
          authProvider.token; // Ensure you have the token from authProvider

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://127.0.0.1:8000/api/tickets'),
      );

      request.headers.addAll({
        'Authorization':
            'Bearer $token', // Add the token to the request headers
        'Accept': 'application/json',
      });

      request.fields['title'] = _titleController.text;
      request.fields['submitter'] = nama;
      request.fields['application'] = _selectedApplication!;
      request.fields['priority_id'] = _selectedPriority!;
      request.fields['division_id'] = _selectedDivision!;
      request.fields['description'] = _descriptionController.text;
      request.fields['status_id'] = '1'; // Set status to open

      if (_selectedFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'attachment',
          _selectedFile!.path,
        ));
      }

      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ticket submitted successfully')));
        } else {
          print('Failed to submit ticket: ${response.reasonPhrase}');
          print('Response body: $responseBody');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Failed to submit ticket: ${response.reasonPhrase}')));
        }
      } catch (error) {
        print('Submit ticket error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit ticket: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final nama = authProvider.nama ?? 'Unknown User';

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengajuan Tiket Baru'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                'Pengajuan Topik',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Judul'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: nama,
                decoration: InputDecoration(labelText: 'Pengaju'),
                readOnly: true,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Aplikasi'),
                value: _selectedApplication,
                onChanged: (value) {
                  setState(() {
                    _selectedApplication = value;
                  });
                },
                items: _applications.map((application) {
                  return DropdownMenuItem<String>(
                    value: application,
                    child: Text(application),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih aplikasi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Prioritas'),
                value: _selectedPriority,
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                items: _priorities.map((priority) {
                  return DropdownMenuItem<String>(
                    value: priority['id'].toString(),
                    child: Text(priority['nama_prioritas']),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih prioritas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Divisi'),
                value: _selectedDivision,
                onChanged: (value) {
                  setState(() {
                    _selectedDivision = value;
                  });
                },
                items: _divisions.map((division) {
                  return DropdownMenuItem<String>(
                    value: division['id'].toString(),
                    child: Text(division['nama_divisi']),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Silakan pilih divisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Deskripsi',
                  hintText: 'Tulis deskripsi untuk tiket yang akan diajukan.',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Lampiran:'),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text(_selectedFileName == null
                    ? 'Pilih File'
                    : 'File: $_selectedFileName'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTicket,
                child: Text('Ajukan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
