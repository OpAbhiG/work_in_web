import 'package:flutter/material.dart';
// import 'package:login_registration_screen/APIServices/api_services.dart';
// import 'package:login_registration_screen/models/model.dart';
// import 'main_screen.dart';
import '../APIServices/api_services.dart';
import '../models/model.dart';
import 'log_forgot_screen.dart';
import 'main_screen.dart';
import 'registration_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  final ApiServices apiServices = ApiServices();

  final _formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  String? _errorMessage;
  bool _isPasswordVisible = false; // Track the visibility of the password


  LoginModel loginModel = LoginModel();
  bool isReady = false;

  // void _login() async{
  //   if (_formKey.currentState!.validate()) {
  //     final email = email;
  //     final password = password;
  //
  //     LoginModel? result=await apiServices.loginWithModel(email, password);
  //
  //     if (result != null) {
  //       // Successful login
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => const MainScreen()),
  //       );
  //     } else {
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content:Text('Invalid credentials. User does not exist or password is incorrect.')),
  //       // );
  //
  //       setState(() {
  //         _errorMessage = 'Invalid credentials. User does not exist or password is incorrect.';
  //       });
  //     }
  //   }
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          SizedBox.expand(
            child: Image.asset(
              'assets/bkimg.jpg', // background img login 2nd screen
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              // padding: const EdgeInsets.all(18.0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // // Back arrow aligned to the left
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: IconButton(
                      //     icon: const Icon(Icons.arrow_back, color: Colors.black),///
                      //     onPressed: () {
                      //       Navigator.pop(context); // This pops the current screen and goes back to the previous screen
                      //     }, padding: EdgeInsets.zero,
                      //   ),
                      // ),
                      // const SizedBox(height: 30),
                      // Logo centered
                      Center(
                        child: Image.asset(
                          'assets/btclogo.png', // Logo path
                          height: 70,
                        ),
                      ),


                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'First time user?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF243B6D),
                              ),
                            ),
                            const SizedBox(width: 20), // Adds spacing between the text and button
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to registration screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min, // Shrinks the row to fit its content
                                children: const [
                                  Text(
                                    'Register Here',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8), // Adds spacing between text and icon
                                  Icon(
                                    Icons.arrow_forward, // Use any arrow icon you prefer
                                    color: Colors.white,
                                    size: 18, // Adjust size if needed
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                      const SizedBox(height: 25),
                      // Form section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Color(0xFF243B6D),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(
                              child: Text(
                                'Existing User Sign-in',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),
                            // Email/Mobile Number Field
                            TextFormField(
                              controller: email,
                              decoration: const InputDecoration(
                                labelText: 'Enter Email',
                                labelStyle: TextStyle(color: Colors.white,),
                                prefixIcon: Icon(Icons.email, color: Colors.white),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              style: TextStyle(color: Colors.white), // White text in the input field
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _errorMessage='Please fill current Email'; // Set error message
                                  });
                                }else{
                                  setState(() {
                                    _errorMessage='';
                                  });
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),
                            // Password Field
                            TextFormField(
                              controller: password,
                              obscureText: !_isPasswordVisible, // Toggle password visibility
                              decoration: InputDecoration(
                                labelText: 'Enter Password',
                                labelStyle: const TextStyle(color: Colors.white),
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
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),

                              style: TextStyle(color: Colors.white), // White text in the input field

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  setState(() {
                                    _errorMessage='Please fill current password'; // Set error message
                                  });
                                }else{
                                  setState(() {
                                    _errorMessage='';
                                  });
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start, // Optional: Centers the texts horizontally
                              children: const [
                                Text(
                                  'Please read our\t',
                                  style: TextStyle(color: Colors.grey, fontSize: 8),
                                ),
                                Text(
                                  'Privacy Policy\t',
                                  style: TextStyle(color: Colors.white, fontSize: 8),
                                ),
                                Text(
                                  'and\t',
                                  style: TextStyle(color: Colors.grey, fontSize: 8),
                                ),
                                Text(
                                  'Terms',
                                  style: TextStyle(color: Colors.white, fontSize: 8),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),
                            // Error message display
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red,fontSize: 12),
                                ),
                              ),



                            // Sign In Button
                            // ElevatedButton(
                            //   // onPressed: _login,
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.orange,
                            //     padding: const EdgeInsets.symmetric(vertical: 12),
                            //     textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            //   ),
                            //   // padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01), // 2% of screen height
                            //   onPressed: (){
                            //     if(email.text.isEmpty || password.text.isEmpty){
                            //       setState(() {
                            //         _errorMessage='Please fill in both email and password'; // Set error message
                            //       });
                            //     }else{
                            //       setState(() {
                            //         _errorMessage='';
                            //       });
                            //     }
                            //
                            //
                            //     setState(() {isReady = true;});
                            //     // With Model
                            //
                            //     ApiServices().loginWithModel(email.text.toString(), password.text.toString(),context).then((value){
                            //
                            //       setState(() {
                            //         loginModel = value!;
                            //         isReady = false;
                            //         // print(loginModel.token);
                            //         Navigator.push(context, MaterialPageRoute(builder: (context)=>MainScreen()
                            //         ));
                            //       });
                            //     }).onError((error, stackTrace){
                            //       setState(() {isReady = false;});
                            //       print(error);
                            //     });
                            //
                            //
                            //
                            //     // Without Model
                            //     // ApiServices().loginWithOutModel(email.text.toString(), password.text.toString()).then((value){
                            //     //   setState(() {
                            //     //     isReady = false;
                            //     //     print(value["token"]);
                            //     //
                            //     //     Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(
                            //     //         token : value["token"].toString()
                            //     //     )));
                            //     //
                            //     //   });
                            //     // }).onError((error, stackTrace){
                            //     //   setState(() {isReady = false;});
                            //     //   print(error);
                            //     // });
                            //
                            //
                            //   },
                            //
                            //   child: const Text('Sign In',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                            //
                            //
                            //
                            // ),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () async {
                                if (email.text.isEmpty || password.text.isEmpty) {
                                  setState(() {
                                    _errorMessage = 'Please fill in both email and password'; // Set error message
                                  });
                                } else {
                                  setState(() {
                                    _errorMessage = '';
                                    isReady = true; // Show loading
                                  });

                                  // Simulate network delay
                                  await Future.delayed(const Duration(seconds: 2));

                                  // Perform the login logic
                                  ApiServices().loginWithModel(email.text, password.text, context).then((value) {
                                    setState(() {
                                      loginModel = value!;
                                      isReady = false;
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MainScreen()),
                                      );
                                    });
                                  }).onError((error, stackTrace) {
                                    setState(() {
                                      isReady = false;
                                      _errorMessage = 'An error occurred. Please try again later.';
                                    });
                                  });
                                }
                              },
                              child: isReady
                                  ? const SizedBox(
                                  width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                                  : const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),



                            const SizedBox(height: 10),
                              // Forgot Password Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Implement forgot password logic
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(height: 300),
                      // // Footer text
                      // // const Spacer(),
                      // const Text(
                      //   '© BharatTeleClinic, 2024 - All Rights Reserved.',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(color: Color(0xFF243B6D), fontSize: 10),
                      // ),
                    ],
                  ),
                ),
              ),

          ),
          ),
             // Footer at the bottom of the screen
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

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
