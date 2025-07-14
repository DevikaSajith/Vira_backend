import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final DatabaseReference _alertRef =
      FirebaseDatabase.instance.ref('alertMessage');

  String _alertMessage = 'No alerts yet.';

  @override
  void initState() {
    super.initState();

    _alertRef.onValue.listen((event) {
      final data = event.snapshot.value;
      setState(() {
        _alertMessage = data != null ? data.toString() : 'No alerts.';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIRA Emergency Alerts'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            _alertMessage,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
