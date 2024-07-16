import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Authentication/AuthProvider.dart';
import '/Authentication/config.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

class TicketDetailScreen extends StatelessWidget {
  static const routeName = '/ticket-detail';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? ticket =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (ticket == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Tiket Tidak Ditemukan'),
        ),
        body: Center(
          child: Text('Tidak ada data tiket yang tersedia.'),
        ),
      );
    }

    // Construct the URL for the ticket
    String ticketUrl = '${Config.baseUrl}/tickets/${ticket['ticket_id']}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Tiket #${ticket['ticket_id']}'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Refresh logic
            },
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Mark as done logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket['judul'] ?? 'Judul tidak tersedia',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(ticket['deskripsi'] ?? 'Deskripsi tidak tersedia'),
              SizedBox(height: 16),
              if (ticket['files'] != null)
                GestureDetector(
                  onTap: () {
                    // Logic to open file
                  },
                  child: Text(
                    ticket['files']['nama_file'] ?? 'Nama file tidak tersedia',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
              SizedBox(height: 16),
              Card(
                child: ListTile(
                  title: Text('Pengaju'),
                  subtitle: Text(ticket['pengaju'] ?? 'Pengaju tidak tersedia'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Aplikasi'),
                  subtitle:
                      Text(ticket['aplikasi'] ?? 'Aplikasi tidak tersedia'),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text('Divisi'),
                  subtitle: Text(
                      ticket['divisi']?['nama_divisi'] ?? 'Tidak ada divisi'),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: SelectableText(
                  ticketUrl,
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16),
              Text('Balasan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              for (var reply in ticket['balasan'] ?? [])
                Card(
                  child: ListTile(
                    title:
                        Text(reply['user']?['nama'] ?? 'Nama tidak tersedia'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(reply['balasan'] ?? 'Balasan tidak tersedia'),
                        if (reply['files'] != null)
                          GestureDetector(
                            onTap: () {
                              // Logic to open file
                            },
                            child: Text(
                              reply['files']['nama_file'] ??
                                  'Nama file tidak tersedia',
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        Text(
                          DateTime.parse(reply['created_at'] ?? '')
                              .toLocal()
                              .toString(),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 16),
              Text('Balas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _ReplyForm(ticket['id'] as int?), // Ensure ticket['id'] is an int
            ],
          ),
        ),
      ),
    );
  }
}

class _ReplyForm extends StatefulWidget {
  final int? ticketId;

  _ReplyForm(this.ticketId);

  @override
  __ReplyFormState createState() => __ReplyFormState();
}

class __ReplyFormState extends State<_ReplyForm> {
  final _formKey = GlobalKey<FormState>();
  final _replyController = TextEditingController();
  File? _selectedFile;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitReply() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final token = authProvider.token;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Config.baseUrl}/api/tickets/reply'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      request.fields['tiket_id'] = widget.ticketId?.toString() ?? '';
      request.fields['balasan'] = _replyController.text;

      if (_selectedFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'fileInput',
          _selectedFile!.path,
        ));
      }

      try {
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Balasan berhasil dikirim')));
          _replyController.clear();
          setState(() {
            _selectedFile = null;
          });
        } else {
          print('Failed to submit reply: ${response.reasonPhrase}');
          print('Response body: $responseBody');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text('Failed to submit reply: ${response.reasonPhrase}')));
        }
      } catch (error) {
        print('Submit reply error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit reply: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _replyController,
            decoration: InputDecoration(labelText: 'Balasan'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Balasan tidak boleh kosong';
              }
              return null;
            },
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: _pickFile,
            child: Text(_selectedFile == null
                ? 'Pilih File'
                : 'File: ${_selectedFile!.path.split('/').last}'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: _submitReply,
            child: Text('Kirim'),
          ),
        ],
      ),
    );
  }
}
