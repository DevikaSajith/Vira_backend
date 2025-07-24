import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'screens/auth_page.dart';
import 'screens/stock_page.dart';
import 'screens/messages_page.dart';
import 'screens/contacts_page.dart';
import 'screens/support_page.dart'; // Assuming EmergencySupportPage is here
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'VIRA',
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider.lightTheme(),
      darkTheme: ThemeProvider.darkTheme(),
      themeMode: themeProvider.themeMode,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const AuthPage();
          }
        },
      ),
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
    'Helpline',
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      // extendBodyBehindAppBar: true, // REMOVED THIS LINE to fix overlapping
      appBar: AppBar(
        // The title now conditionally includes "Welcome" for the Home page
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titles[_selectedIndex],
              style: GoogleFonts.inter(
                fontSize: 28, // Adjusted font size for main title
                fontWeight: FontWeight.w700,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
            if (_selectedIndex == 0) // Only show "Welcome" on the Home page
              Text(
                'Welcome', // Added "Welcome" under "Home"
                style: GoogleFonts.satisfy( // Changed to a more decorative font for "Welcome"
                  fontSize: 22, // Adjusted size for new font
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).appBarTheme.toolbarTextStyle?.color,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.wb_sunny
                  : Icons.mode_night,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Theme.of(context).appBarTheme.iconTheme?.color),
            onPressed: () => FirebaseAuth.instance.signOut(),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Match background
        elevation: 0, // No shadow for a cleaner look
        toolbarHeight: _selectedIndex == 0 ? 100 : 60, // Adjust height based on title content
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: isLightMode
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.black.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
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
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Theme.of(context).primaryColor),
                      )
                    : null,
                child: Icon(
                  _selectedIndex == 4 ? Icons.support_agent : Icons.support_agent_outlined,
                  color: _selectedIndex == 4 ? Theme.of(context).primaryColor : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
                ),
              ),
              label: 'Helpline',
            ),
          ],
        ),
      ),
    );
  }
}

// ViraHomePage: The custom home screen content with branding and decorative elements.
class ViraHomePage extends StatelessWidget {
  const ViraHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get colors from the current theme for dynamic styling
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final Color viraTextColor = isLightMode ? const Color(0xFF5C5470) : Colors.grey[200]!;
    final Color welcomeTextColor = isLightMode ? const Color(0xFF5C5470) : Colors.grey[300]!;
    // Note: iconColor and starIconColor might need adjustment for the new pink gradient
    // For now, let's make them slightly adjusted based on the new background, or keep as is if they look good.
    final Color heartColor = isLightMode ? const Color(0xFFE57373) : Colors.brown[300]!; // Adjusted for new light theme
    final Color starColor = isLightMode ? const Color(0xFFFFD54F) : Colors.orange[300]!; // Adjusted for new light theme


    // Background gradient colors from the login page (image_2d53aa.png)
    // Adjusted for a more subtle pink theme
    final List<Color> lightModeBackgroundGradientColors = [
      const Color(0xFFFFFFFF), // Start with white for a very subtle top
      const Color(0xFFFDEEF7), // Very light pink
      const Color(0xFFFAD1E8), // Light pink
      const Color(0xFFF5A9D3), // Slightly deeper pink
    ];


    // Padding to push content below the AppBar on ViraHomePage specifically
    // Now that extendBodyBehindAppBar is false, this padding is crucial.
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // Adjusted padding calculation because AppBar is no longer "behind" the body.
    // We add the AppBar's height directly.
    final double topContentPadding = statusBarHeight + appBarHeight + 20; // Added extra 20 for visual spacing


    return Container(
      // The Container itself should fill all available space to show the gradient
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: isLightMode
            ? LinearGradient(
                begin: Alignment.topCenter, // Changed to top to bottom
                end: Alignment.bottomCenter, // Changed to top to bottom
                colors: lightModeBackgroundGradientColors,
                stops: const [0.0, 0.3, 0.7, 1.0], // Adjusted stops for smoother transition
              )
            : const LinearGradient( // Keep existing dark theme gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2C1917),
                  Color(0xFF38201E),
                  Color(0xFF422B29),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
      ),
      child: Stack(
        children: [
          // Decorative elements (hearts and stars) - keeping their theme-awareness
          ..._buildDecorativeElements(context),
          // Add padding to the top to account for the AppBar's height
          Padding(
            padding: EdgeInsets.only(top: topContentPadding),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // "VIRA" Text (reverted to original font)
                  ShaderMask(
                    shaderCallback: (bounds) => isLightMode
                        ? const LinearGradient(
                            colors: [
                              Color(0xFFDD79A3), // Pink from previous AuthPage gradient
                              Color(0xFFA97AC1), // Purple from previous AuthPage gradient
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds)
                        : const LinearGradient(
                            colors: [
                              Color(0xFFBCAAA4), // Lighter brown for dark mode
                              Color(0xFF8D6E63), // Muted brown for dark mode
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                    child: Text(
                      'VIRA',
                      style: GoogleFonts.inter( // Reverted to original Inter font
                        fontSize: 80, // Original size
                        fontWeight: FontWeight.w900, // Original weight
                        color: Colors.white, // Color is masked by the shader
                        height: 1.0,
                        letterSpacing: 5, // Original letter spacing
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tagline: VOICE. IMPACT. RELIEF. ACCESS. (ALL CAPS)
                  Text(
                    'VOICE. IMPACT. RELIEF. ACCESS.', // Already in ALL CAPS
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: welcomeTextColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDecorativeElements(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;
    final Color heartColor = isLightMode ? const Color(0xFFE57373) : Colors.brown[300]!; // Adjusted for new light theme
    final Color starColor = isLightMode ? const Color(0xFFFFD54F) : Colors.orange[300]!; // Adjusted for new light theme

    return [
      Positioned(top: 80, left: 50, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.2), size: 30)),
      Positioned(top: 150, right: 30, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.15), size: 20)),
      Positioned(bottom: 200, left: 100, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.1), size: 25)),
      Positioned(bottom: 100, right: 80, child: Icon(Icons.favorite_border, color: heartColor.withOpacity(0.25), size: 40)),
      Positioned(top: 50, right: 70, child: Icon(Icons.star_border, color: starColor.withOpacity(0.2), size: 35)),
      Positioned(top: 200, left: 20, child: Icon(Icons.star_border, color: starColor.withOpacity(0.1), size: 20)),
      Positioned(bottom: 50, left: 50, child: Icon(Icons.star_border, color: starColor.withOpacity(0.15), size: 30)),
      Positioned(bottom: 250, right: 50, child: Icon(Icons.star_border, color: starColor.withOpacity(0.25), size: 45)),
      Positioned(top: 120, left: 180, child: Text('✨', style: TextStyle(fontSize: 20, color: starColor.withOpacity(0.5)))),
      Positioned(bottom: 150, left: 150, child: Text('💫', style: TextStyle(fontSize: 25, color: starColor.withOpacity(0.5)))),
    ];
  }
}
