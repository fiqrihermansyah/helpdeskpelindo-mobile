import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AdminProvider.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users'),
      ),
      body: FutureBuilder(
        future: adminProvider.fetchUsers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: adminProvider.users.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(adminProvider.users[index]['name']),
                  subtitle: Text('Role: ${adminProvider.users[index]['role']}'),
                  trailing: DropdownButton<String>(
                    value: adminProvider.users[index]['role'],
                    onChanged: (String? newRole) {
                      adminProvider.updateUserRole(
                        adminProvider.users[index]['id'],
                        newRole!,
                      );
                    },
                    items: <String>['user', 'admin', 'planner']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
