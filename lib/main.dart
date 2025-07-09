import 'package:flutter/material.dart';
import 'screens/dashboard_page.dart';
import 'screens/messages_page.dart';
import 'screens/stock_page.dart';
import 'screens/contacts_page.dart';
import 'screens/support_page.dart';
import 'screens/emergency_page.dart';

void main() {
  runApp(ViraApp());
}

class ViraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VIRA Emergency Aid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1C140D), // Coffee brown base
        primaryColor: const Color(0xFFF29D56), // Caramel orange
        cardColor: const Color(0xFF2A1D14), // Mocha brown cards
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF29D56), // Button caramel
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(90, 36),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFF29D56),
          labelStyle: const TextStyle(color: Colors.black87),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFF8F1E7)), // Soft white text
          bodySmall: TextStyle(color: Color(0xFFB3A59D)),  // Muted subtext
        ),
      ),
      initialRoute: '/dashboard',
      routes: {
        '/dashboard': (_) => DashboardPage(),
        '/messages': (_) => MessagesPage(),
        '/stock': (_) => StockPage(),
        '/contacts': (_) => ContactsPage(),
        '/support': (_) => SupportPage(),
        '/emergency': (_) => EmergencyPage(),
      },
    );
  }
}
