import 'package:flutter/material.dart';
import 'package:mirelle_kay/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadFontAndNavigate();
  }

  Future<void> _loadFontAndNavigate() async {
    // Ensure the splash screen is visible for at least 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Load fonts (simulated delay)
    await _loadFonts();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _loadFonts() async {
    // Simulate loading fonts with a delay (you can replace with actual font loading logic)
    await Future.wait([
      // Add your font loading logic here
      // Example: await GoogleFonts.openSans().load(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
