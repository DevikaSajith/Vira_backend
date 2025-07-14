import 'package:flutter/material.dart';

class EmergencyPage extends StatelessWidget {
  final String currentStatus = "Natural Disaster – High";

  final List<Map<String, String>> protocols = [
    {
      'step': 'Notify authorities',
      'status': 'Completed',
    },
    {
      'step': 'Evacuate affected area',
      'status': 'In Progress',
    },
    {
      'step': 'Distribute emergency kits',
      'status': 'Pending',
    },
    {
      'step': 'Conduct health checkups',
      'status': 'Pending',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Pending':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(title: const Text('Emergency Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current Emergency Status:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.pink.withOpacity(0.15),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.pinkAccent),
                title: Text(
                  currentStatus,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Response Protocol Checklist:",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: protocols.length,
                itemBuilder: (context, index) {
                  final step = protocols[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: const Icon(Icons.task),
                      title: Text(step['step']!),
                      trailing: Chip(
                        label: Text(step['status']!),
                        backgroundColor: _statusColor(step['status']!),
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
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.pinkAccent),
            child: Text(
              'VIRA',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
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
        Navigator.pop(context); // Close the drawer first
        Navigator.pushNamed(context, route);
      },
    );
  }
}
