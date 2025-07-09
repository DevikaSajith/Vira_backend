import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  final List<Map<String, String>> supportContacts = [
    {
      'title': 'Mental Health Support',
      'desc': '24/7 Crisis Helpline',
      'status': '24/7',
    },
    {
      'title': 'Women’s Rights Helpline',
      'desc': 'Legal & Emotional Aid',
      'status': 'Active',
    },
    {
      'title': 'Child Welfare Services',
      'desc': 'Child abuse & trafficking',
      'status': 'Available',
    },
    {
      'title': 'National Disaster Relief',
      'desc': 'Coordination & Assistance',
      'status': 'Hotline',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text('Emergency Support',
            style: TextStyle(color: Color(0xFFF8F1E7))),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Color(0xFFF8F1E7)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: supportContacts.length,
          itemBuilder: (context, index) {
            final support = supportContacts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT: Text Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(support['title']!,
                              style: TextStyle(
                                  color: Color(0xFFF8F1E7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text(support['desc']!,
                              style: TextStyle(
                                  color: Color(0xFFB3A59D), fontSize: 13)),
                        ],
                      ),
                    ),

                    // RIGHT: Chip + Buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Chip(
                          label: Text(support['status']!,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                          backgroundColor: Colors.pinkAccent,
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
                              child: Icon(Icons.call, size: 16),
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
                              child: Icon(Icons.chat, size: 16),
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
