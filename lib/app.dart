import 'package:flutter/material.dart';
import 'package:untitled10/screens/login_screen.dart';
// import 'package:login_registration_screen/screens/booking_screen.dart';
// import 'package:login_registration_screen/screens/login_screen.dart';
// import 'package:login_registration_screen/screens/main_screen.dart';
// import 'screens/language_clinic_selection_screen.dart';

class BharatTeleClinicApp extends StatelessWidget {
  const BharatTeleClinicApp({super.key});
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
      home: LoginScreen(),
    );





















    

  }
}
