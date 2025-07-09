import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  final List<Map<String, dynamic>> contacts = [
    {
      'name': 'Police Helpline',
      'role': 'Emergency Services',
      'status': 'Available',
      'color': Colors.green,
    },
    {
      'name': 'Ambulance - 108',
      'role': 'Medical Emergency',
      'status': 'Available',
      'color': Colors.green,
    },
    {
      'name': 'City Hospital',
      'role': 'Trauma & Emergency',
      'status': 'Busy',
      'color': Colors.orange,
    },
    {
      'name': 'Women Safety Helpline - 1091',
      'role': '24x7 Support',
      'status': 'Available',
      'color': Colors.green,
    },
    {
      'name': 'Fire Department - 101',
      'role': 'Disaster Response',
      'status': 'Available',
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(title: Text('Emergency Contacts')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search contacts...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(contact['name']),
                      subtitle: Text(contact['role']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Chip(
                            label: Text(contact['status']),
                            backgroundColor: contact['color'],
                          ),
                          SizedBox(width: 6),
                          IconButton(
                            icon: Icon(Icons.call),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.pinkAccent),
            child: Text('Sisterhood Aid',
                style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
          _drawerItem(context, 'Dashboard', '/dashboard'),
          _drawerItem(context, 'Messages', '/messages'),
          _drawerItem(context, 'Stock', '/stock'),
          _drawerItem(context, 'Contacts', '/contacts'),
          _drawerItem(context, 'Support', '/support'),
          _drawerItem(context, 'Emergency', '/emergency'),
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
