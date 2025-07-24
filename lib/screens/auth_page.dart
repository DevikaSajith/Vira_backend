import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin { // Added SingleTickerProviderStateMixin
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State to toggle between login and sign-up form
  bool isLogin = true;

  // Animation for the Vira text shimmer effect
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3), // Duration of one shimmer cycle
      vsync: this,
    )..repeat(reverse: true); // Repeat indefinitely, reversing direction

    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Smooth animation curve
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose(); // Dispose the animation controller
    super.dispose();
  }

  // Function to show error messages in a SnackBar
  void showError(String message) {
    if (mounted) { // Check if the widget is still mounted before showing SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  // Firebase Sign In logic
  Future<void> signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Pop the loading circle
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.of(context).pop(); // Pop the loading circle
      showError(e.message ?? "An unknown error occurred.");
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // Pop the loading circle
      showError(e.toString());
    }
  }

  // Firebase Sign Up logic
  Future<void> signUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Pop the loading circle
      if (mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.of(context).pop(); // Pop the loading circle
      showError(e.message ?? "An unknown error occurred.");
    } catch (e) {
      if (mounted) Navigator.of(context).pop(); // Pop the loading circle
      showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine if it's light or dark mode
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    // Define theme-aware colors
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).primaryColor;
    final hintColor = Theme.of(context).hintColor;

    // Define colors for the Vira text gradient based on theme
    final List<Color> viraTextGradientColors = isLightMode
        ? [const Color(0xFFDD79A3), const Color(0xFFA97AC1)] // Pink to Purple for light mode
        : [const Color(0xFFBCAAA4), const Color(0xFF8D6E63)]; // Lighter to Muted Brown for dark mode

    // Background gradient colors inspired by the provided image
    final List<Color> backgroundGradientColors = isLightMode
        ? [
            const Color(0xFFFCE4EC), // Very light pink (similar to top-left of image)
            const Color(0xFFF8BBD0), // Lighter pink
            const Color(0xFFCE93D8), // Light purple
            const Color(0xFF9C27B0), // Deeper purple (similar to bottom-right of image)
          ]
        : [
            const Color(0xFF1A0A1F), // Darker base for dark mode
            const Color(0xFF2B1038), // Mid-dark purple
            const Color(0xFF3C184C), // Slightly lighter dark purple
            const Color(0xFF4A148C), // Deepest dark purple
          ];

    return Scaffold(
      body: Container(
        // Background gradient, adapts to theme
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, // Start from top-left
            end: Alignment.bottomRight, // End at bottom-right
            colors: backgroundGradientColors,
          ),
        ),
        child: Stack( // Use Stack to position the icon
          children: [
            // Top-left Icon Placeholder
            Positioned(
              top: MediaQuery.of(context).padding.top + 16, // Safe area + padding
              left: 16,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: textColor!.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.shield_outlined, // Placeholder icon
                  color: textColor.withOpacity(0.7),
                  size: 30,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView( // Allow scrolling for smaller screens
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 50), // Adjust height to push content below icon

                    // "Welcome to" Text
                    Text(
                      'Welcome to',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // "Vira" Stylized Text with Animated Gradient
                    AnimatedBuilder( // Use AnimatedBuilder to rebuild only the text part
                      animation: _animation,
                      builder: (context, child) {
                        return ShaderMask(
                          shaderCallback: (bounds) {
                            // Animate the gradient's start and end points for shimmer effect
                            return LinearGradient(
                              colors: viraTextGradientColors,
                              begin: Alignment(_animation.value * 2 - 1, -1.0), // Sweep from left to right
                              end: Alignment(_animation.value * 2 + 1, 1.0),
                            ).createShader(bounds);
                          },
                          child: Text(
                            'Vira',
                            style: GoogleFonts.pinyonScript( // Using Pinyon Script for handwritten feel
                              fontSize: 90, // Larger size for prominence
                              fontWeight: FontWeight.bold, // Bold to make it stand out
                              color: Colors.white, // Color is masked by the shader
                              height: 1.0,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),

                    // Tagline: VOICE. IMPACT. RELIEF. ACCESS.
                    Text(
                      'VOICE. IMPACT. RELIEF. ACCESS.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2, // Spaced out as in sketch
                        color: textColor?.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 60), // Space before login section

                    // "USER LOGIN" Header
                    Text(
                      'USER LOGIN',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email Input Field (Pill-shaped) - CHANGED HERE
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300), // Max width for inputs
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress, // Set keyboard type to email
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Email', // Changed label from 'username' to 'Email'
                          labelStyle: TextStyle(color: hintColor),
                          prefixIcon: Icon(Icons.email_outlined, color: hintColor), // Changed icon to email
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), // Pill shape
                            borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), // Pill shape
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Adjust padding
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Input Field (Pill-shaped)
                    // Wrapped in ConstrainedBox for width control
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300), // Max width for inputs
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'password', // As per sketch
                          labelStyle: TextStyle(color: hintColor),
                          prefixIcon: Icon(Icons.lock_outline, color: hintColor),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), // Pill shape
                            borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30), // Pill shape
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Adjust padding
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Login/Sign Up Button
                    // Wrapped in ConstrainedBox for width control
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300), // Apply same max width
                      child: SizedBox(
                        width: double.infinity, // Make button full width within its constrained box
                        child: ElevatedButton(
                          onPressed: isLogin ? signIn : signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, // Use theme primary color
                            padding: const EdgeInsets.symmetric(vertical: 18), // Larger padding
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // Slightly rounded button
                            ),
                            elevation: 8, // More prominent shadow
                          ),
                          child: Text(
                            isLogin ? 'Login' : 'Create Account',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isLightMode ? Colors.white : Colors.black87, // Text color contrasts with primary
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Toggle Button (Sign Up / Go to Login)
                    // Wrapped in ConstrainedBox for width control
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 300), // Apply same max width
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin; // Toggle form type
                            emailController.clear();
                            passwordController.clear();
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: textColor?.withOpacity(0.7), // Muted text color for toggle
                        ),
                        child: Text(
                          isLogin ? 'Don\'t have an account? Sign Up' : 'Already have an account? Login',
                          style: GoogleFonts.inter(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}