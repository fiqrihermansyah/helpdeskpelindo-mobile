// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Admin/AdminProvider.dart';
import 'Authentication/AuthProvider.dart';
import 'PlannerManagement/PlannerProvider.dart';
import 'User/TicketProvider.dart';
import 'Authentication/LoginScreen.dart';
import 'Authentication/HomeScreen.dart';
import 'User/CreateTicketScreen.dart';
import 'Admin/AdminDashboardScreen.dart';
import 'Admin/UserListScreen.dart';
import 'PlannerManagement/PlannerSubmissionListScreen.dart';
import 'User/MyTicketsScreen.dart';
import 'User/MySubmissionsScreen.dart';
import 'User/TicketDetailScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TicketProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => PlannerProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, authProvider, _) => MaterialApp(
          title: 'Helpdesk App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: authProvider.isAuthenticated ? HomeScreen() : LoginScreen(),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            AdminDashboardScreen.routeName: (ctx) => AdminDashboardScreen(),
            PlannerSubmissionListScreen.routeName: (ctx) =>
                PlannerSubmissionListScreen(),
            '/home': (ctx) => HomeScreen(),
            '/tiketsaya': (ctx) => MyTicketsScreen(),
            '/submissionsaya': (ctx) => MySubmissionsScreen(),
            CreateTicketScreen.routeName: (ctx) => CreateTicketScreen(),
            TicketDetailScreen.routeName: (ctx) => TicketDetailScreen(),
          },
        ),
      ),
    );
  }
}
