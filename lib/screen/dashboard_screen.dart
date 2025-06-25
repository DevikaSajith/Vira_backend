import 'package:flutter/material.dart';

void main() {
  runApp(const ViraApp());
}

class ViraApp extends StatelessWidget {
  const ViraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIRA Emergency Support',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              child: Icon(Icons.favorite, color: Colors.white),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Vira", style: TextStyle(color: Colors.black)),
                Text("Emergency Support", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
        actions: const [
          Stack(
            children: [
              Icon(Icons.notifications, color: Colors.black),
              Positioned(
                right: 0,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.red,
                  child: Text("7", style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
          SizedBox(width: 16)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _infoCard(Icons.schedule, "12", "Pending Requests", Colors.pinkAccent),
                _infoCard(Icons.check_circle, "89%", "Fulfilled Today", Colors.deepPurple),
              ],
            ),
            const SizedBox(height: 16),

            // Priority Alert Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text("High Priority Area - Zone 3 - 15 urgent requests",
                      style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tab Indicator
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Incoming Requests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("2 Pending", style: TextStyle(color: Colors.pink)),
              ],
            ),
            const SizedBox(height: 12),

            // Request Card (sample)
            _requestCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Support'),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  static Widget _requestCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person),
              SizedBox(width: 8),
              Text("Sarah M.", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Chip(label: Text("urgent"), backgroundColor: Colors.redAccent),
              Spacer(),
              Chip(label: Text("pending"), backgroundColor: Colors.orange),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.location_pin, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text("Evacuation Center A, Zone 3 - 5 mins ago", style: TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          const Text("Urgent: Need sanitary pads for 12 women. Running critically low."),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: const [
              Chip(label: Text("Sanitary Pads")),
              Chip(label: Text("Underwear")),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent),
                  child: const Text("Respond"),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text("View Details"),
              )
            ],
          )
        ],
      ),
    );
  }
}
