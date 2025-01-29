import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled10/APIServices/base_api.dart';
import 'package:hive/hive.dart';

import 'main_screen.dart';


Future<bool> sendOtp(String phoneNumber) async {
  final String apiUrl = "$baseapi/user/send-otp";
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"number": phoneNumber}),
    );

    if (response.statusCode == 200) {
      print('sent otp');
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      final data = jsonDecode(response.body);
      if (data["message"] == "OTP generated successfully") {
        return true;
      }
    }
  } catch (e) {
    print("Error sending OTP: $e");
  }
  return false;
}

Future<Map<String, dynamic>?> verifyOtp(String phoneNumber, String otp) async {
  final String apiUrl = "$baseapi/user/verify-otp";
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"number": phoneNumber, "otp": otp}),
    );

    if (response.statusCode == 200) {
      print('verify otp');
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      final data = jsonDecode(response.body);
      if (data["message"] == "OTP verified successfully") {
        return data; // Return full response for token storage
      }
    }
  } catch (e) {
    print("Error verifying OTP: $e");
  }
  return null;
}

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({super.key});

  @override
  _OtpLoginScreenState createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void handleSendOtp() async {
    final phoneNumber = phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    setState(() => isLoading = true);
    final success = await sendOtp(phoneNumber);
    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP')),
      );
    }
  }

  void handleVerifyOtp() async {
    final phoneNumber = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (phoneNumber.isEmpty || otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both phone number and OTP')),
      );
      return;
    }

    setState(() => isLoading = true);
    final responseData = await verifyOtp(phoneNumber, otp);
    setState(() => isLoading = false);

    if (responseData != null) {
      final token = responseData["access_token"];
      if (token != null) {
        final box = await Hive.openBox('authBox');
        await box.put('token', token);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );

        // Navigate to the main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save token')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP verification failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/btclogo.png',
                  height: 70,
                ),
              ),
              const SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF243B6D),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Login with OTP',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.phone, color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Enter OTP',
                              labelStyle: TextStyle(color: Colors.grey),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: isLoading ? null : handleSendOtp,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange),
                          child: isLoading
                              ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            'Get OTP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : handleVerifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '© GoodLeven. 2024 - All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

