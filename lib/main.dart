import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'screens/stock_page.dart';
import 'screens/messages_page.dart';
import 'screens/contacts_page.dart';
import 'screens/support_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIRA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFFF7FA), // soft pastel background
        primaryColor: const Color(0xFFF5C8E0), // cute pinkish primary
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFE0F0), // pastel pink app bar
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5C5470), // soft grayish-purple title
          ),
          iconTheme: IconThemeData(color: Color(0xFF5C5470)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFF8E8EE), // soft navbar background
          selectedItemColor: Color(0xFFDD79A3), // pastel pink active icon
          unselectedItemColor: Color(0xFFAAA0C2), // muted gray inactive icons
        ),
        cardColor: const Color(0xFFFEEFF7),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFDD79A3),
          secondary: Color(0xFFA97AC1),
          background: Color(0xFFFFF7FA),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ViraHomePage(),
    StockPage(),
    MessagesPage(),
    ContactPage(),
    EmergencySupportPage(),
  ];

  final List<String> _titles = [
    'Home',
    'Stock',
    'Messages',
    'Contacts',
    'Support',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Stock'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_page), label: 'Contacts'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Support'),
        ],
      ),
    );
  }
}

class ViraHomePage extends StatelessWidget {
  const ViraHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'VIRA',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w900,
          color: Colors.pinkAccent,
          letterSpacing: 3,
        ),
      ),
    );
  }
}
