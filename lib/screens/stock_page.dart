import 'package:flutter/material.dart';

class StockPage extends StatelessWidget {
  final List<Map<String, dynamic>> stockItems = [
    {
      'category': 'Sanitary Products',
      'itemsAvailable': 120,
      'lastUpdated': '2025-07-07',
    },
    {
      'category': 'Aid for Pregnant Women',
      'itemsAvailable': 45,
      'lastUpdated': '2025-07-06',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: Text(
          'Emergency Stock',
          style: TextStyle(color: Color(0xFFF8F1E7)),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Color(0xFFF8F1E7)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: stockItems.length,
          itemBuilder: (context, index) {
            final item = stockItems[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT SIDE
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['category'],
                              style: TextStyle(
                                  color: Color(0xFFF8F1E7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text('Available: ${item['itemsAvailable']}',
                              style: TextStyle(
                                  color: Color(0xFFB3A59D), fontSize: 13)),
                          Text('Last Updated: ${item['lastUpdated']}',
                              style: TextStyle(
                                  color: Color(0xFFB3A59D), fontSize: 13)),
                        ],
                      ),
                    ),

                    // RIGHT SIDE
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size(0, 30),
                      ),
                      child: Text('Update Stock',
                          style: TextStyle(fontSize: 12)),
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
