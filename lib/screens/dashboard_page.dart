import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  final requests = [
    {
      'title': 'Sanitary Products',
      'sender': 'Sarah Johnson',
      'ip': '192.168.1.45',
      'time': '2024-01-15 14:30:22',
      'status': 'Pending',
    },
    {
      'title': 'Medical Attention',
      'sender': 'Maria Rodriguez',
      'ip': '192.168.1.78',
      'time': '2024-01-15 14:25:10',
      'status': 'In Progress',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text(
          'Emergency Aid Dashboard',
          style: TextStyle(color: Color(0xFFF8F1E7)),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Color(0xFFF8F1E7)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text("Emergency Aid Dashboard",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Color(0xFFF8F1E7),
                      )),
              SizedBox(height: 20),
              _buildSummaryCards(),
              SizedBox(height: 20),
              Text("Recent Emergency Requests",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Color(0xFFF8F1E7),
                      )),
              SizedBox(height: 10),
              ...requests.map((req) => _buildRequestCard(req)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _summaryCard("Total Requests", "3", Icons.report, Colors.pink),
        _summaryCard("Pending", "1", Icons.access_time, Colors.redAccent),
        _summaryCard("In Progress", "1", Icons.sync, Colors.orange),
        _summaryCard("Resolved", "1", Icons.check_circle, Colors.green),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, color: color),
              SizedBox(height: 8),
              Text(value,
                  style: TextStyle(fontSize: 20, color: Color(0xFFF8F1E7))),
              Text(title, style: TextStyle(color: Color(0xFFB3A59D))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(Map req) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LEFT SIDE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(req['title'],
                      style: TextStyle(
                          color: Color(0xFFF8F1E7),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text("Sender: ${req['sender']}",
                      style:
                          TextStyle(color: Color(0xFFB3A59D), fontSize: 13)),
                  Text("IP: ${req['ip']}",
                      style:
                          TextStyle(color: Color(0xFFB3A59D), fontSize: 13)),
                  Text("Time: ${req['time']}",
                      style:
                          TextStyle(color: Color(0xFFB3A59D), fontSize: 13)),
                ],
              ),
            ),

            // RIGHT SIDE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Chip(
                  label: Text(req['status'],
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: req['status'] == 'Pending'
                      ? Colors.red
                      : Colors.orangeAccent,
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size(0, 30),
                  ),
                  child: Text("View", style: TextStyle(fontSize: 12)),
                ),
              ],
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
            child: Text('Vira',
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
      title: Text(title, style: TextStyle(color: Color(0xFFF8F1E7))),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}
