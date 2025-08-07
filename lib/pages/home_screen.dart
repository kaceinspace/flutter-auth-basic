import 'package:flutter/material.dart';
import 'package:xii_rpl_3/pages/auth/login_screen.dart';
import 'package:xii_rpl_3/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: [
            IconButton(
              onPressed: () async {
                await _authService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: Center(child: Text('Selamat Datang')),
      ),
    );
  }
}
