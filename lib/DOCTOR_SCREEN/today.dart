// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../APIServices/base_api.dart';
// import '../screens/AppointmentDetailScreen.dart';
//
//
// class DashboardScree extends StatefulWidget {
//   @override
//   _DashboardScreenState createState() => _DashboardScreenState();
// }
//
// class _DashboardScreenState extends State<DashboardScree> {
//
//
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchTodayAppointments(); // Fetch "today" appointments by default
//   }
//
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
//   Map<String, List<dynamic>> appointments = {
//     'today': [],
//   };
//   String? token;
//   Future<void> cancelAppointment(String appointmentId) async {
//     String? bearerToken = await getToken();
//     if (bearerToken != null) {
//       final response = await http.post(
//         Uri.parse("$baseapi/patient/cancel_appoint"),
//         headers: {'Authorization': 'Bearer $bearerToken'},
//         body: jsonEncode({'appointment_id': appointmentId}),
//       );
//
//
//       print("Response Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         fetchCanceledAppointments(); // Refresh the canceled appointments list
//         print('Appointment canceled successfully');
//       } else {
//         print("Error canceling appointment: ${response.body}");
//       }
//     }
//   }
//   Future<void> fetchCanceledAppointments() async {
//     setState(() {
//       isLoading = true;
//     });
//     String? bearerToken = await getToken();
//     if (bearerToken != null) {
//       final response = await http.get(
//         Uri.parse("$baseapi/patient/cancel_list_appoint"),
//         headers: {'Authorization': 'Bearer $bearerToken'},
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           appointments['canceled'] = data['data'] ?? [];
//         });
//       } else {
//         print("Error fetching canceled appointments: ${response.body}");
//       }
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//   Future<void> fetchTodayAppointments() async {
//     setState(() {
//       isLoading = true;
//     });
//     String? bearerToken = await getToken();
//     if (bearerToken == null || bearerToken.isEmpty) {
//       setState(() {
//         isLoading = false;
//       });
//       print('Token is null or empty.');
//       return;
//     }
//     try {
//       final response = await http.get(
//         Uri.parse("$baseapi/patient/list_appoint/today"),
//         headers: {'Authorization': 'Bearer $bearerToken'},
//       );
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           appointments['today'] = (data['data'] as List).map((item) {
//             return {
//               'full_name': item['full_name'] ?? 'Unknown Patient',
//               'start_time': item['start_time'] ?? 'N/A',
//               'speciality': item['speciality'] ?? 'Unknown Clinic',
//               'image_url': item['image_url'] ?? '', // Add image URL field
//               'slot_id': item['slot_id'] ?? 'N/A', // Slot ID
//               'date':item['date']??'na',
//             };
//           }).toList();
//         });
//       } else {
//         print("Error fetching today appointments: ${response.body}");
//       }
//     } catch (e) {
//       print("Error during API call: $e");
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }
//   final Map<int, String> specialties = {
//     1: 'General Physician',
//     2: 'Dentist',
//     3: 'Child Specialist',
//     4: 'Counselling Psychologist',
//   };
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Today's Appointments",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : appointments['today']!.isEmpty
//                   ? Center(child: Text('No appointments for today.'))
//                   : ListView.builder(
//                 itemCount: appointments['today']!.length,
//                 itemBuilder: (context, index) {
//                   final appointment = appointments['today']![index];
//                   return GestureDetector(
//                     onTap: () {
//                       // Navigate to appointment detail screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AppointmentDetailScreen(
//                             appointment: appointment, section: '', appointmentId: null,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       margin: EdgeInsets.symmetric(vertical: 10.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       elevation: 4.0,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           children: [
//                             // Top section with doctor details
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 // Doctor profile image
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                   child: Image.network(
//                                     appointment['image_url'] ??
//                                         "https://via.placeholder.com/50",
//                                     height: 70.0,
//                                     width: 70.0,
//                                     fit: BoxFit.cover,
//                                     loadingBuilder: (context, child, loadingProgress) {
//                                       if (loadingProgress == null) {
//                                         return child;
//                                       }
//                                       return Container(
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                         ),
//                                         height: 50.0,
//                                         width: 50.0,
//                                         alignment: Alignment.center,
//                                         child: CircularProgressIndicator(
//                                           value: loadingProgress.expectedTotalBytes != null
//                                               ? loadingProgress.cumulativeBytesLoaded /
//                                               (loadingProgress.expectedTotalBytes ?? 1)
//                                               : null,
//                                         ),
//                                       );
//                                     },
//                                     errorBuilder: (context, error, stackTrace) {
//                                       return Container(
//                                         height: 50.0,
//                                         width: 50.0,
//                                         color: Colors.grey[300],
//                                         child: Icon(
//                                           Icons.person,
//                                           color: Colors.grey,
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.0),
//                                 // Appointment details
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Dr. ${appointment['full_name']}',
//                                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
//                                       ),
//                                       SizedBox(height: 5.0),
//                                       Text(
//                                         // '${appointment['speciality']}',
//                                         '${specialties[appointment['speciality']] ?? ''}',
//                                         style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
//                                       ),
//                                       SizedBox(height: 5.0),
//                                       Text(
//                                         'Appointment ID: ${appointment['slot_id']}',
//                                         style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
//                                       ),
//
//                                     ],
//
//                                   ),
//
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     // Handle video call button press
//                                     print('Initiate Video Call');
//                                   },
//                                   icon: Container(
//                                     padding: const EdgeInsets.all(12), // Add padding to give space around the icon
//                                     decoration: const BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Colors.green, // Set the background color to orange
//                                     ),
//                                     child: const Icon(
//                                       size: 25,
//                                       Icons.video_call,
//                                       color: Colors.white, // Set the icon color to white
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Divider(color: Colors.grey[300], thickness: 1, height: 20),
//                             // Bottom section with appointment type, date, and time
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 // Appointment type
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Appointment Type',
//                                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
//                                     ),
//                                     SizedBox(height: 5.0),
//                                     Text(
//                                       'Video Consultation',
//                                       style: TextStyle(color: Colors.green, fontSize: 10.0),
//                                     ),
//                                   ],
//                                 ),
//                                 // Date and Time
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       'Date & Time',
//                                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
//                                     ),
//                                     SizedBox(height: 5.0),
//                                     Text(
//                                       '${appointment['date'] ?? 'N/A'}\t${appointment['start_time']}',
//                                       textAlign: TextAlign.right,
//                                       style: TextStyle(color: Colors.grey[700], fontSize: 10.0),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }
