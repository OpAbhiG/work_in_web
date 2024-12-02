// import 'dart:convert';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
//
// import '../APIServices/base_api.dart';
//
// // import 'base_api.dart';
// // import '../APIServices/base_api.dart';
//
// class DoctorProfile extends StatefulWidget {
//   const DoctorProfile({super.key});
//
//   @override
//   State<DoctorProfile> createState() => _DoctorProfileState();
// }
//
// class _DoctorProfileState extends State<DoctorProfile> {
//   String fullName = '';
//   String email = '';
//   String qualification = '';
//   int experience = 0;
//   bool isApproved = false;
//   bool isVerified = false;
//   String speciality = '';
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDoctorProfile();
//   }
//
//   // Retrieve token from Hive
//   Future<String?> getToken() async {
//     try {
//       var box = await Hive.openBox('userBox');
//       final token = box.get('authToken');
//       return token;
//     } catch (e) {
//       print('Error retrieving token: $e');
//       return null;
//     }
//   }
//
//   // Fetch doctor profile data from API
//   Future<void> fetchDoctorProfile() async {
//     try {
//       String? bearerToken = await getToken();
//       if (bearerToken == null) {
//         showError('Authentication token not found.');
//         return;
//       }
//
//       var url = Uri.parse("$baseapi/doctor/get_profile"); // Update the endpoint
//       var response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           fullName = data['full_name'] ?? '';
//           email = data['email'] ?? '';
//           qualification = data['qualification'] ?? '';
//           experience = data['experience'] ?? 0;
//           isApproved = data['is_approved'] ?? false;
//           isVerified = data['is_verified'] ?? false;
//           speciality = data['speciality'].toString(); // Assuming speciality is an ID or string
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//         showError('Failed to load profile: ${response.body}');
//       }
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       showError('An error occurred: $e');
//     }
//   }
//
//   // Show error messages
//   void showError(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: const Text(
//           'Doctor Profile',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             Center(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Doctor Information Card
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 4,
//                     margin: const EdgeInsets.symmetric(horizontal: 15),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Row(
//                         children: [
//                           const CircleAvatar(
//                             radius: 40,
//                             backgroundImage: AssetImage('assets/doctor.png'),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   fullName,
//                                   style: const TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   'Speciality: $speciality',
//                                   style: const TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 5),
//                   // Profile Details Card
//                   Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     elevation: 4,
//                     margin: const EdgeInsets.symmetric(horizontal: 15),
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: Column(
//                         children: [
//                           _buildProfileDetail(
//                             label: 'Email',
//                             value: email,
//                           ),
//                           _buildProfileDetail(
//                             label: 'Qualification',
//                             value: qualification,
//                           ),
//                           _buildProfileDetail(
//                             label: 'Experience',
//                             value: '$experience years',
//                           ),
//                           _buildProfileDetail(
//                             label: 'Approval Status',
//                             value: isApproved ? 'Approved' : 'Not Approved',
//                           ),
//                           _buildProfileDetail(
//                             label: 'Verification Status',
//                             value: isVerified ? 'Verified' : 'Not Verified',
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileDetail({
//     required String label,
//     required String value,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 10, color: Colors.grey),
//           ),
//           const SizedBox(height: 5.0),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             padding: const EdgeInsets.all(12),
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 14, color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
