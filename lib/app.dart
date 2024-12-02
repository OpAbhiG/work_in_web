import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:untitled10/screens/booking_screen.dart';
import 'package:untitled10/screens/language_clinic_selection_screen.dart';
import 'package:untitled10/screens/login_screen.dart';
import 'package:untitled10/screens/main_screen.dart';

// import 'package:untitled10/screens/login_screen.dart';
import 'package:untitled10/screens/medical/medical1.dart';

// import 'models/dr.dart';

// import 'package:login_registration_screen/screens/booking_screen.dart';
// import 'package:login_registration_screen/screens/login_screen.dart';
// import 'package:login_registration_screen/screens/main_screen.dart';
// import 'screens/language_clinic_selection_screen.dart';

class BharatTeleClinicApp extends StatefulWidget {
  const BharatTeleClinicApp({super.key});

  @override
  State<BharatTeleClinicApp> createState() => _BharatTeleClinicAppState();
}

class _BharatTeleClinicAppState extends State<BharatTeleClinicApp> {
  bool? isLogined;

  // Retrieve token from Hive
  Future verifyToken() async {
      try {
        var box = await Hive.openBox('userBox');
        final token = box.get('authToken');
        if (token != null) {
          isLogined = true;
        } else {
          isLogined = false;
        }
      } catch (e) {
        isLogined = false;
      }
  }

  @override
  void initState() {
    setState(()  {
    verifyToken();    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bharat Tele Clinic',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A237E),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: isLogined == null
          ?
      Center(child: Container(color: Colors.white, // Set the background color to white
          padding: const EdgeInsets.all(16), // Add some padding if needed
          child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
        ),
      )
          : isLogined == false
              ? const LoginScreen()
              : const MainScreen(),
    );
  }
}
