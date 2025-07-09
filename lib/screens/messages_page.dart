import 'package:flutter/material.dart';

class MessagesPage extends StatelessWidget {
  final List<Map<String, dynamic>> requests = [
    {
      'name': 'Maria Rodriguez',
      'type': 'Medical Attention',
      'status': 'In Progress',
    },
    {
      'name': 'Sarah Johnson',
      'type': 'Sanitary Products',
      'status': 'Pending',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text('Emergency Requests',
            style: TextStyle(color: Color(0xFFF8F1E7))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Color(0xFFF8F1E7)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildStatusFilter(),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final req = requests[index];
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
                                Text(req['type'],
                                    style: TextStyle(
                                        color: Color(0xFFF8F1E7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 6),
                                Text(req['name'],
                                    style: TextStyle(
                                        color: Color(0xFFB3A59D),
                                        fontSize: 13)),
                              ],
                            ),
                          ),

                          // RIGHT SIDE
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Chip(
                                label: Text(
                                  req['status'],
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                backgroundColor: req['status'] == 'Pending'
                                    ? Colors.red
                                    : Colors.orange,
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: Size(0, 30),
                                    ),
                                    child: Text("Accept",
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                  SizedBox(width: 6),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: Size(0, 30),
                                    ),
                                    child: Text("Resolve",
                                        style: TextStyle(fontSize: 12)),
                                  ),
                                ],
                              ),
                            ],
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

  Widget _buildStatusFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilterChip(
          label: Text("All", style: TextStyle(color: Color(0xFFF8F1E7))),
          onSelected: (_) {},
        ),
        FilterChip(
          label: Text("Pending", style: TextStyle(color: Color(0xFFF8F1E7))),
          onSelected: (_) {},
        ),
        FilterChip(
          label: Text("In Progress", style: TextStyle(color: Color(0xFFF8F1E7))),
          onSelected: (_) {},
        ),
        FilterChip(
          label: Text("Resolved", style: TextStyle(color: Color(0xFFF8F1E7))),
          onSelected: (_) {},
        ),
      ],
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
