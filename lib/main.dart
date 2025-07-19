import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

import 'firebase_options.dart';
import 'screens/auth_page.dart';
import 'screens/stock_page.dart';
import 'screens/messages_page.dart';
import 'screens/contacts_page.dart';
import 'screens/support_page.dart'; // Assuming EmergencySupportPage is here
import 'theme_provider.dart'; // Import your theme provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider( // Wrap MyApp with ChangeNotifierProvider
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the theme provider to get the current theme mode
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'VIRA',
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.lightTheme(), // Define the light theme
      darkTheme: ThemeProvider.darkTheme(), // Define the dark theme
      themeMode: themeProvider.themeMode, // Control theme based on provider's state
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const HomePage(); // Revert to HomePage as the main screen
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}

// HomePage and ViraHomePage will be kept in this file,
// but their content and styling will be updated to be theme-aware.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ViraHomePage(), // This is still your custom home content
    StockPage(),
    MessagesPage(),
    ContactPage(),
    EmergencySupportPage(), // Ensure this matches your class name
  ];

  final List<String> _titles = [
    'Home',
    'Stock',
    'Messages',
    'Contacts',
    'Helpline', // Changed from Support to Helpline as per image suggestion
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access theme provider

    return Scaffold(
      extendBodyBehindAppBar: true, // Allows the body to extend behind the app bar
      appBar: AppBar(
        // Removed explicit colors here to rely on Theme.of(context).appBarTheme
        // The gradient will be handled in ViraHomePage's background.
        title: _selectedIndex == 0
            ? Text(
                'Home',
                style: GoogleFonts.inter(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color?.withOpacity(0.7), // Use theme color, slightly faded
                  fontWeight: FontWeight.normal,
                ),
              )
            : Text(
                _titles[_selectedIndex],
                style: GoogleFonts.inter(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color, // Use theme color
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          // Theme Toggle Button (Sun/Moon)
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.wb_sunny // Sun icon for light mode
                  : Icons.mode_night, // Moon icon for dark mode
              color: Theme.of(context).appBarTheme.iconTheme?.color, // Use theme icon color
            ),
            onPressed: () {
              themeProvider.toggleTheme(); // Toggle theme
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).appBarTheme.iconTheme?.color), // Use theme icon color
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
      body: _pages[_selectedIndex],
      // Bottom navigation bar will automatically pick up styles from ThemeData
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor, // Use theme color
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.black.withOpacity(0.4), // Darker shadow for dark mode
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent, // Make transparent to show container's color
          elevation: 0, // Remove default shadow
          onTap: (index) => setState(() => _selectedIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 1 ? Icons.inventory : Icons.inventory_2_outlined),
              label: 'Stock',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 2 ? Icons.message : Icons.message_outlined),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(_selectedIndex == 3 ? Icons.contact_page : Icons.contact_page_outlined),
              label: 'Contacts',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _selectedIndex == 4
                    ? BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3), // Use theme primary color
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Theme.of(context).primaryColor), // Use theme primary color
                      )
                    : null,
                child: Icon(
                  _selectedIndex == 4 ? Icons.support_agent : Icons.support_agent_outlined,
                  color: _selectedIndex == 4 ? Theme.of(context).primaryColor : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor, // Use theme colors
                ),
              ),
              label: 'Helpline', // Label updated to Helpline
            ),
          ],
        ),
      ),
    );
  }
}

class ViraHomePage extends StatelessWidget {
  const ViraHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get colors from the current theme
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final Color viraTextColor = isLightMode ? const Color(0xFF5C5470) : Colors.grey[200]!;
    final Color welcomeTextColor = isLightMode ? const Color(0xFF5C5470) : Colors.grey[300]!;
    final Color iconColor = isLightMode ? Colors.pink.withOpacity(0.2) : Colors.brown[300]!.withOpacity(0.2);
    final Color starIconColor = isLightMode ? Colors.yellow.withOpacity(0.2) : Colors.orange[300]!.withOpacity(0.2);

    return Container(
      decoration: BoxDecoration(
        gradient: isLightMode
            ? const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFF7FC), // Very light pink/white at the top
                  Color(0xFFF9E7F6), // Slightly darker pink/purple in the middle
                  Color(0xFFF5E0F0), // Even darker at the bottom
                ],
                stops: [0.0, 0.5, 1.0],
              )
            : LinearGradient( // Dark theme gradient (coffee brown shades)
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF2C1917), // Darker brown at top
                  const Color(0xFF38201E), // Mid brown
                  const Color(0xFF422B29), // Lighter brown at bottom
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
      ),
      child: Stack(
        children: [
          // Background decorative elements (stars and hearts)
          // Make these theme-aware as well
          ..._buildDecorativeElements(context),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => isLightMode
                      ? const LinearGradient(
                          colors: [
                            Color(0xFFDD79A3), // Pink
                            Color(0xFFA97AC1), // Purple
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds)
                      : const LinearGradient( // Dark theme gradient for VIRA text
                          colors: [
                            Color(0xFFBCAAA4), // Lighter brown
                            Color(0xFF8D6E63), // Muted brown
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                  child: Text(
                    'VIRA',
                    style: GoogleFonts.inter( // Use Inter font
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Color is masked by the shader
                      letterSpacing: 5,
                      height: 1.0,
                    ),
                  ),
                ),
                // Removed the SizedBox and Row containing "Welcome to your magical space!"
                // const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Welcome to your magical space!',
                //       style: GoogleFonts.inter(
                //         fontSize: 18,
                //         color: welcomeTextColor,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     const SizedBox(width: 8),
                //     Text(
                //       '🌸',
                //       style: TextStyle(fontSize: 20, color: welcomeTextColor),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDecorativeElements(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final Color heartColor = isLightMode ? Colors.pink : Colors.brown[300]!;
    final Color starColor = isLightMode ? Colors.yellow : Colors.orange[300]!;

    return [
      // Hearts
      Positioned(top: 80, left: 50, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.2), size: 30)),
      Positioned(top: 150, right: 30, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.15), size: 20)),
      Positioned(bottom: 200, left: 100, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.1), size: 25)),
      Positioned(bottom: 100, right: 80, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.25), size: 40)),
      // Stars
      Positioned(top: 50, right: 70, child: Icon(Icons.star_border, color: starColor.withOpacity(0.2), size: 35)),
      Positioned(top: 200, left: 20, child: Icon(Icons.star_border, color: starColor.withOpacity(0.1), size: 20)),
      Positioned(bottom: 50, left: 50, child: Icon(Icons.star_border, color: starColor.withOpacity(0.15), size: 30)),
      Positioned(bottom: 250, right: 50, child: Icon(Icons.star_border, color: starColor.withOpacity(0.25), size: 45)),
      // Random sparkles/shapes
      Positioned(top: 120, left: 180, child: Text('✨', style: TextStyle(fontSize: 20, color: starColor.withOpacity(0.5)))),
      Positioned(bottom: 150, left: 150, child: Text('💫', style: TextStyle(fontSize: 25, color: starColor.withOpacity(0.5)))),
    ];
  }
}
