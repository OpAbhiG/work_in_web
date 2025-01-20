import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../APIServices/api_services.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {


  final TextEditingController email=TextEditingController();
  final TextEditingController password=TextEditingController();
  final TextEditingController fname=TextEditingController();
  final TextEditingController lname=TextEditingController();

  String? gender;

  // late TextEditingController gender=TextEditingController();

  final TextEditingController dob = TextEditingController();
  final TextEditingController aadhar_no=TextEditingController();
  final TextEditingController number=TextEditingController();

  bool isLoading=false;

  bool _isPasswordVisible = false; // Track the visibility of the password


  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bkimg.jpg'), // Path to your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Image.asset(
                    'assets/btclogo.png',
                    height: screenHeight * 0.08, // 8% of screen height
                    width: screenHeight * 0.08, // 8% of screen height
                  ),


                  SizedBox(height: screenHeight * 0.03), // Adjust height as needed
                  // Blue container around the form and button
                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Color(0xFF243B6D),
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                            controller: fname,
                            decoration: const InputDecoration(
                              labelText: 'First Name',
                              labelStyle: TextStyle(color: Colors.white,fontSize: 12),
                              prefixIcon: Icon(Icons.person,color: Colors.white),
                            ),style: const TextStyle(color: Colors.white), // White text in the input field
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextFormField(
                          controller: lname,
                          decoration: const InputDecoration(
                            labelText: 'Last Name',
                            labelStyle: TextStyle(color: Colors.white,fontSize: 12),
                            prefixIcon: Icon(Icons.person,color: Colors.white),
                          ),style: const TextStyle(color: Colors.white), // White text in the input field


                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(

                                decoration: const InputDecoration(
                                  labelText: 'Gender',
                                  labelStyle: TextStyle(color: Colors.white,fontSize: 12),

                                  prefixIcon: Icon(Icons.wc,color: Colors.white),
                                ),
                                items: ['Male', 'Female'].map((String value) {
                                  return DropdownMenuItem<String>(

                                    value: value,
                                    child: Text(value,
                                    style: const TextStyle(color: Colors.white),),
                                  );
                                }).toList(),
                                onChanged: (String? newVal) {
                                    gender=newVal;
                                },
                                dropdownColor: Color(0xFF243B6D), // Set the background color of the dropdown

                              ),

                            ),
                            SizedBox(width: screenWidth * 0.04),
                            Expanded(
                              child: TextFormField(
                                controller: dob,
                                decoration: const InputDecoration(
                                  labelText: 'Age',
                                  labelStyle: TextStyle(color: Colors.white,fontSize: 12),

                                  prefixIcon: Icon(Icons.calendar_today,color: Colors.white),
                                ),style: const TextStyle(color: Colors.white), // White text in the input field


                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: screenHeight * 0.02),
                        TextFormField(
                          controller: aadhar_no,
                          decoration: const InputDecoration(
                            labelText: 'Aadhaar Number',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                            prefixIcon: Icon(Icons.credit_card, color: Colors.white),
                            counterText: '', // This hides the character counter

                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 12, // Limit to 12 digits
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Allow only digits
                          ],
                          style: const TextStyle(color: Colors.white), // Text color
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Aadhaar number';
                            } else if (value.length != 12) {
                              return 'Aadhaar number must be 12 digits';
                            }
                            return null; // Return null if valid
                          },
                        ),


                        SizedBox(height: screenHeight * 0.02),
                        TextFormField(
                          controller: number,
                          decoration: const InputDecoration(
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(color: Colors.white, fontSize: 12),
                            prefixIcon: Icon(Icons.phone, color: Colors.white),
                            counterText: '', // This hides the character counter
                          ),
                          keyboardType: TextInputType.phone, // Ensures the keyboard shows number layout
                          maxLength: 10, // Limits the input to 10 digits
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly, // Ensures only digits are allowed
                          ],
                          style: const TextStyle(color: Colors.white), // Text color
                          // Optionally, add validation if needed
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a mobile number';
                            } else if (value.length != 10) {
                              return 'Mobile number must be 10 digits';
                            }
                            return null; // Return null if valid
                          },
                        ),



                        SizedBox(height: screenHeight * 0.02),
                        TextFormField(
                          controller: email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white,fontSize: 12),

                            prefixIcon: Icon(Icons.email,color: Colors.white),
                          ),style: const TextStyle(color: Colors.white), // White text in the input field
                          keyboardType: TextInputType.emailAddress,
                        ),



                        SizedBox(height: screenHeight * 0.01),
                        TextFormField(
                          controller: password,
                          obscureText: !_isPasswordVisible, // Toggle password visibility
                          decoration: InputDecoration(
                            labelText: 'Password',

                            labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
                            prefixIcon: const Icon(Icons.lock, color: Colors.white),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible =
                                  !_isPasswordVisible; // Toggle visibility
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(color: Colors.white), // White text in the input field
                        ),


                        SizedBox(height: screenHeight * 0.02),
                        const Text(
                          'By Signing up, I agree to Terms & Conditions',
                          style: TextStyle(color: Colors.white, fontSize: 8),
                        ),

                        SizedBox(height: screenHeight * 0.02),
                        ElevatedButton(
                          onPressed: isLoading?null:RegistrationScreen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01), // 2% of screen height
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // SizedBox(height: screenHeight * 0.03),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: const Text('Existing User? Sign In',style: TextStyle(color: Color(0xFFFFFFFF),),),
                        // ),
                      ],
                    ),
                  ),
            // SizedBox(height: screenHeight * 0.01),
            // // ABHA Button
            // ElevatedButton(
            //   onPressed: _launchABHALink,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Color(0xFF243B6D),
            //     padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30),
            //     ),
            //   ),
            //   onPressed: () {
            //
            //   },
            //   child: const Text(
            //     'Register with ABHA',
            //     style: TextStyle(
            //       fontSize: 15,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                '© BharatTeleClinic, 2025 - All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF243B6D), fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

//The buildTextField method is a helper function designed to create a TextFormField with customizable properties
  Widget buildTextField({required String label, required IconData icon, bool isNumber = false, bool isEmail = false, bool isPassword = false}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
        prefixIcon: Icon(icon, color: Colors.white),
      ),
      keyboardType: isNumber
          ? TextInputType.number
          : isEmail
          ? TextInputType.emailAddress
          : TextInputType.text,
      obscureText: isPassword,
    );
  }


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25), // Elegant rounded corners
          ),
          backgroundColor: Colors.white, // Clean white background for better readability
          title: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 32,
              ), // Error icon with accent color
              SizedBox(width: 16),
              Text(
                'Incomplete Form',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600, // Slightly lighter weight for modern touch
                  fontSize: 22, // Larger title for impact
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5, // Line height for readability
              ),
              textAlign: TextAlign.center, // Centered message
            ),
          ),
          actionsAlignment: MainAxisAlignment.center, // Center the actions
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Red accent color
                foregroundColor: Colors.white, // White text for contrast
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded button edges
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14), // Spacious padding
                elevation: 8, // Higher elevation for a subtle 3D effect
                side: BorderSide(
                  color: Colors.redAccent, // Matching border color
                  width: 2, // Thin border
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // Bold text for emphasis
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> RegistrationScreen() async {
    if (
    email.text.isEmpty || password.text.isEmpty || fname.text.isEmpty || lname.text.isEmpty || gender!.isEmpty||
        aadhar_no.text.isEmpty||dob.text.isEmpty||number.text.isEmpty) {
      _showErrorDialog("All fields are required. Please ensure no field is left blank.");
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await ApiServices().RegistrationScreen(
          email.text,
          password.text,
          fname.text,
          lname.text,
          gender!,
          dob.text ,
          aadhar_no.text,
          number.text
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 12, // Adjust height if needed
            child: Center(
              child: Text(
                'Sign up successful',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // backgroundColor: Colors.black.withOpacity(0.7), // Transparent black
          backgroundColor: const Color(0xFF40BF78), // Background color
          behavior: SnackBarBehavior.floating, // Floating SnackBar
          margin: const EdgeInsets.symmetric(horizontal: 120, vertical: 10), // Adjust padding
          elevation: 0, // Remove shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Rounded corners
          ),
          duration: const Duration(seconds: 2), // Visible for 2 seconds
        ),
      );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Container(
      //       alignment: Alignment.center,
      //       height: 12, // Adjust height if needed
      //       child: Center(
      //         child: Text(
      //           'Sign up successful!',
      //           style: TextStyle(
      //             fontSize: 10,
      //             fontWeight: FontWeight.bold,
      //             color: Colors.white,
      //           ),
      //           textAlign: TextAlign.center,
      //         ),
      //       ),
      //     ),
      //     // backgroundColor: Colors.black.withOpacity(0.7), // Transparent black
      //     backgroundColor: Color(0xFF40BF78), // Background color
      //     behavior: SnackBarBehavior.floating, // Floating SnackBar
      //     margin: EdgeInsets.symmetric(horizontal: 120, vertical: 10), // Adjust padding
      //     elevation: 0, // Remove shadow
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(5), // Rounded corners
      //     ),
      //     duration: Duration(seconds: 2), // Visible for 2 seconds
      //   ),
      // );
      Navigator.pop(context);
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: ${e.toString()}')),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            alignment: Alignment.center,
            height: 12, // Adjust height if needed
            child: Center(
              child: Text(
                'Error: ${e.toString()}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // backgroundColor: Colors.black.withOpacity(0.7), // Transparent black
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating, // Floating SnackBar
          margin: EdgeInsets.symmetric(horizontal: 120, vertical: 10), // Adjust padding
          elevation: 0, // Remove shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Rounded corners
          ),
          duration: Duration(seconds: 2), // Visible for 2 seconds
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}