import 'dart:async';
import 'dart:math'; // To use Random class
import 'dart:ui';
import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool user;

  const SplashScreen({required this.user, Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  String _quote = '';  // Variable to hold the dynamic quote

  // List of health quotes
  final List<String> healthQuotes = [
        "Health is the greatest wealth.",
        "Your body deserves the best.",
        "Take care of your body, it’s the only place you have to live.",
        "A healthy outside starts from the inside.",
        "Invest in your health.",
        "Wellness is the natural state of my body.",
        "Good health is a crown worn by the healthy.",
        "Healthy mind, healthy body.",
        "Eat well, live well.",
        "Health is a journey, not a destination.",
  ];

  @override
  void initState() {
    super.initState();
    // Get a random quote when the app starts
    _quote = _getRandomQuote();
    startSplashScreen();
  }

  // Function to get a random quote from the list
  String _getRandomQuote() {
    final random = Random();
    int index = random.nextInt(healthQuotes.length);
    return healthQuotes[index];
  }

  void startSplashScreen() {
    var duration = const Duration(seconds: 5);
    _timer = Timer(duration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image with blurred effect
          Positioned.fill(
            child: Image.asset(
              'assets/bkimg.jpg', // Ensure you have the image in your assets folder
              fit: BoxFit.cover,
            ),
          ),
          // Blurred Background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the dynamic health quote
                Text(
                  _quote,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.indigo,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 100),
                CircularProgressIndicator(color: Colors.indigo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
