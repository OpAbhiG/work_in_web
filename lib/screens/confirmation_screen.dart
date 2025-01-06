// import 'package:flutter/material.dart';
//
// class ConfirmationScreen extends StatefulWidget {
//
//   const ConfirmationScreen({super.key});
//
//   @override
//   State<ConfirmationScreen> createState() => _ConfirmationScreenState();
// }
//
// class _ConfirmationScreenState extends State<ConfirmationScreen> {
//   // @override
//   bool isReady = false;
//  // Define the isReady variable here
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF243B6D),
//         title: Text('Confirmation'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.check_circle_rounded, // Icon to indicate success
//               size: 100,
//               color: Colors.green,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Your appointment has been booked!',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 10),
//             Text(
//               'Thank you for choosing us. We look forward to seeing you!',
//               style: TextStyle(fontSize: 16),
//               textAlign: TextAlign.center,
//             ),
//             SizedBox(height: 30),
//             // Button to navigate back to Home
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isReady = true; // Set loading state
//                 });
//
//                 // Simulate a delay (you can replace it with actual code if needed)
//                 Future.delayed(const Duration(seconds: 2), () {
//                   setState(() {
//                     isReady = false; // Stop loading after some time
//                   });
//
//                   // Navigate back to Home Screen
//                   Navigator.popUntil(context, (route) => route.isFirst);
//                 });
//               },
//               child: isReady
//                   ? const SizedBox(
//                   width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white)) // Show small loading spinner
//                   : const Text(
//                 'Go to Home',
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
