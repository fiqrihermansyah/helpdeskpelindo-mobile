import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Authentication/AuthProvider.dart';
import '/Authentication/config.dart'; // Impor kelas Config

class UserListScreen extends StatefulWidget {
  static const routeName = '/userList';

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _isLoading = true;
  List<dynamic> _users = [];
  List<dynamic> _roles = [];

  @override
  void initState() {
    super.initState();
    _fetchUsersAndRoles();
  }

  Future<void> _fetchUsersAndRoles() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      final userResponse = await http.get(
        Uri.parse('${Config.baseUrl}/api/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      final roleResponse = await http.get(
        Uri.parse('${Config.baseUrl}/api/roles'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (userResponse.statusCode == 200 && roleResponse.statusCode == 200) {
        setState(() {
          _users = json.decode(userResponse.body)['data'];
          _roles = json.decode(roleResponse.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load users or roles');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: $error')),
      );
    }
  }

  Future<void> _attachRoles(int userId, int roleId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;

    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/api/attach-roles'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
          'role_ids': [roleId],
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Roles attached successfully')),
        );
        _fetchUsersAndRoles(); // Refresh the user list
      } else {
        throw Exception('Failed to attach roles');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error attaching roles: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar User'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (ctx, i) {
                final user = _users[i];
                int? selectedRoleId =
                    user['roles'].isNotEmpty ? user['roles'][0]['id'] : null;

                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['nama'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text('NIPP: ${user['nipp']}'),
                            Text('Divisi: ${user['divisi']['nama_divisi']}'),
                            Text('Nomor Handphone: ${user['nomor_hp']}'),
                            Wrap(
                              children: _roles.map<Widget>((role) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: role['id'],
                                      groupValue: selectedRoleId,
                                      onChanged: (int? val) {
                                        setState(() {
                                          selectedRoleId = val;
                                        });
                                      },
                                    ),
                                    Text(role['name']),
                                  ],
                                );
                              }).toList(),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedRoleId != null) {
                                  _attachRoles(user['id'], selectedRoleId!);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Please select a role')),
                                  );
                                }
                              },
                              child: Text('Attach Roles'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
