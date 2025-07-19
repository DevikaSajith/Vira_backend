import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State to toggle between login and sign-up form
  bool isLogin = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // Determine if it's light or dark mode
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    // Define theme-aware colors
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final primaryColor = Theme.of(context).primaryColor;
    final cardColor = Theme.of(context).cardColor;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final hintColor = Theme.of(context).hintColor;

    return Scaffold(
      body: Container(
        // Background gradient, adapts to theme
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
              : LinearGradient(
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
        child: Center(
          child: SingleChildScrollView( // Allow scrolling for smaller screens
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // "VIRA" Logo Text
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
                      : const LinearGradient(
                          colors: [
                            Color(0xFFBCAAA4), // Lighter brown
                            Color(0xFF8D6E63), // Muted brown
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                  child: Text(
                    'VIRA',
                    style: GoogleFonts.inter(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      color: Colors.white, // Color is masked by the shader
                      letterSpacing: 5,
                      height: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 40), // Increased space

                // Login/Sign Up Card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(isLightMode ? 0.8 : 0.9), // Card color with opacity
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isLightMode ? 0.1 : 0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(maxWidth: 400), // Max width for the card
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Wrap content tightly
                    children: [
                      Text(
                        isLogin ? 'Welcome Back!' : 'Join VIRA!',
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: hintColor),
                          prefixIcon: Icon(Icons.email_outlined, color: hintColor),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.transparent, // Ensure fill color adapts
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: hintColor),
                          prefixIcon: Icon(Icons.lock_outline, color: hintColor),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: hintColor.withOpacity(0.5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: primaryColor, width: 2),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.transparent,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Login/Sign Up Button
                      SizedBox(
                        width: double.infinity, // Make button full width of the card
                        child: ElevatedButton(
                          onPressed: isLogin ? signIn : signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, // Use theme primary color
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
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
                      const SizedBox(height: 20),
                      // Toggle Button (Sign Up / Go to Login)
                      TextButton(
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
                          style: GoogleFonts.inter(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}