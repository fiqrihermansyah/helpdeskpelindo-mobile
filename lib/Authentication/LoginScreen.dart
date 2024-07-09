import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AuthProvider.dart';
import '/Admin/AdminDashboardScreen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  final TextEditingController _nippController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nippController,
              decoration: InputDecoration(labelText: 'NIPP'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await authProvider.login(
                    _nippController.text,
                    _passwordController.text,
                  );
                  if (authProvider.isAuthenticated) {
                    if (authProvider.roles.contains('admin')) {
                      Navigator.of(context)
                          .pushReplacementNamed(AdminDashboardScreen.routeName);
                    } else {
                      Navigator.of(context).pushReplacementNamed('/home');
                    }
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Login failed: $error'),
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
