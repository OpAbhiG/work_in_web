// import 'package:demo/roundrd_appbar.dart';
import 'package:flutter/material.dart';
// import 'package:untitled10/screens/roundrd_appbar.dart';
// import 'rounded_app_bar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110),  // Height of the app bar
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          child: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,  // Back arrow icon
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);  // Pop the current screen and go back one screen
              },
            ),

            automaticallyImplyLeading: false, // Remove back arrow
            title: const Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF243B6D),
            foregroundColor: Colors.white,
            toolbarHeight: 110,  // Set the height of the app bar
          ),
        ),
      ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circle Avatar with Icon
            SizedBox(height: 30,),
            Container(
              width: 80, // Diameter of the circle (radius * 2 + border width)
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF002D67), // Border color
                  width: 4, // Border width
                ),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.lock_outline,
                  size: 50,
                  color: Color(0xFF002D67),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Instruction Text
            const Text(
              'Please enter Email or Mobile Number',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF002D67),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We will send a reset link to your \nregistered Email/Mobile Number',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // TextFormField
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                // controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Email/Mobile Number',
                  labelStyle: const TextStyle(color: Color(0xFF243B6D),fontSize: 10),
                  prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF243B6D),),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF243B6D)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF243B6D),),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 12,
                  ), // Adjust padding here
                ),
                style: const TextStyle(color: Color(0xFF243B6D),),
              ),
            ),

            const SizedBox(height: 20),

            // Reset Password Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle reset password logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }


}


