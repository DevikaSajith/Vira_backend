import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final DatabaseReference _messagesRef = FirebaseDatabase.instance.ref('messages');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _messagesRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading messages'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No messages yet'));
          }

          final data = snapshot.data!.snapshot.value as Map;
          final messages = data.entries.toList()
            ..sort((a, b) => a.value['timestamp'].compareTo(b.value['timestamp'])); // sort by time

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final msg = messages[index].value;
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.message, color: Colors.amber),
                  title: Text(msg['content'] ?? ''),
                  subtitle: Text('From: ${msg['sender'] ?? 'Unknown'}'),
                  trailing: Text(msg['timestamp']?.toString().split('T').last ?? ''),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.amber),
            child: Text('VIRA Menu', style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
          _drawerItem(context, 'Emergency', '/emergency'),
          _drawerItem(context, 'Stock', '/stock'),
          _drawerItem(context, 'Messages', '/messages'),
          _drawerItem(context, 'Contacts', '/contacts'),
          _drawerItem(context, 'Support', '/support'),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
