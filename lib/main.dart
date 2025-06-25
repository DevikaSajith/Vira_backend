import 'package:flutter/material.dart';
import 'screen/dashboard_screen.dart'; // Import your dashboard screen

void main() {
  runApp(const ViraApp());
}

class ViraApp extends StatelessWidget {
  const ViraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIRA App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      home: const DashboardScreen(), // Load your dashboard screen
    );
  }
}
