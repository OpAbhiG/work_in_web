import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:untitled10/screens/booking_screen.dart';
import 'package:untitled10/screens/language_clinic_selection_screen.dart';
import 'package:untitled10/screens/login_screen.dart';
import 'package:untitled10/screens/main_screen.dart';
import 'package:untitled10/screens/splash_screen.dart';


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
    verifyToken();});
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
          const SplashScreen(user:true)
          : isLogined == false
              ? const LoginScreen()
              : const MainScreen(),
    );
  }
}
