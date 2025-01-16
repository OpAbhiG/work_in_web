// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart' as http;
//
// import '../APIServices/base_api.dart';
// import 'AppointmentDetailScreen.dart';
//
// class AppointmentScreen extends StatefulWidget {
//   final bool isFromDashboard;
//   const AppointmentScreen({this.isFromDashboard = false, Key? key}) : super(key: key);
//   @override
//   _AppointmentScreenState createState() => _AppointmentScreenState();
// }
//
// class _AppointmentScreenState extends State<AppointmentScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   Map<String, List<dynamic>> appointments = {
//     'today': [],
//     'upcoming': [],
//     'past': [],
//     'canceled': [],
//   };
//   String? token;
//   // final String baseUrl = "$baseapi/patient";
//   bool isLoading = false; // To manage the loading state
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//     fetchAppointments('today'); // Fetch "today" appointments by default
//   }
//
//   Future<String?> getToken() async {
//     try {
//       var box = await Hive.openBox('userBox');
//       final token = box.get('authToken');
//       print('Token retrieved: $token');  // Debug: Check the value here
//       return token;
//     } catch (e) {
//       print('Error retrieving token: $e');
//       return null;
//     }
//   }
//   Future<void> someApiCall() async {
//     String? token = await getToken();
//     if (token == null) {
//       print('Token not available, please login.');
//       return;
//     }
//     var url = Uri.parse('$baseapi/user/get_profile');
//     var response = await http.get(
//       url,
//       headers: {
//         'Authorization': 'Bearer $token',
//         // 'Content-Type': 'application/json',
//
//       },
//     );
//
//     print("Response Status Code: ------: ${response.statusCode}");
//     print("Response Body: --------: ${response.body}");
//
//
//     if (response.statusCode == 200) {
//       print('API call successful');
//     } else {
//       print('API call failed: ${response.body}');
//     }
//   }
//
//   Future<void> fetchAppointments(String section) async {
//     setState(() {
//       isLoading = true; // Show loading indicator
//     });
//
//     try {
//       String? bearerToken = await getToken();
//       final response = await http.get(
//         Uri.parse("http://192.168.0.116:5000/patient/list_appoint/$section"),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//           // 'Content-Type': 'application/json',
//         },
//         // body: jsonEncode({
//         //
//         // }), // Add required parameters if needed
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         // Update the appointments list for the given section
//         setState(() {
//           appointments[section] = data['data'] ?? [];
//         });
//       } else {
//         print("Error fetching $section data: ${response.body}");
//       }
//     } catch (e) {
//       print("Error: $e");
//     } finally {
//       setState(() {
//         isLoading = false; // Hide loading indicator
//       });
//     }
//   }
//
//   Future<void> fetchCanceledAppointments(String? bearerToken) async {
//     try {
//       final response = await http.get(
//         Uri.parse("http://192.168.0.116:5000/patient/cancel_list_appoint"),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//           // 'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           appointments['canceled'] = data['data'] ?? [];
//         });
//       } else {
//         print("Error fetching canceled appointments: ${response.body}");
//       }
//     } catch (e) {
//       print("Error fetching canceled appointments: $e");
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My Appointments',style: TextStyle(
//           fontSize: 18, // Adjust font size
//           fontWeight: FontWeight.bold, // Make text bold
//           // fontFamily: 'Schyler', // Optional: Set a custom font family if you have one
//         ),
//
//         ),
//
//         bottom: TabBar(
//
//           controller: _tabController,
//           indicatorColor: Colors.orange,
//
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           onTap: (index) {
//             // Fetch data based on the selected tab
//             switch (index) {
//               case 0:
//                 fetchAppointments('today');
//                 break;
//               case 1:
//                 fetchAppointments('upcoming');
//                 break;
//               case 2:
//                 fetchAppointments('past');
//                 break;
//               case 3:
//                 fetchAppointments('canceled');
//                 break;
//             }
//           },
//           tabs: [
//             Tab(text: 'Today'),
//             Tab(text: 'Upcoming'),
//             Tab(text: 'Past'),
//             Tab(text: 'canceled'),
//           ],
//         ),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//       ),
//       body: TabBarView(
//
//         controller: _tabController,
//         children: [
//
//           buildAppointmentList('today'),
//           buildAppointmentList('upcoming'),
//           buildAppointmentList('past'),
//           buildAppointmentList('canceled'),
//         ],
//       ),
//     );
//   }
//
//   Widget buildAppointmentList(String section) {
//     final List<dynamic> sectionAppointments = appointments[section] ?? [];
//
//     if (isLoading) {
//       return Center(
//         child: CircularProgressIndicator(color: Colors.blue,),
//       );
//     }
//
//     if (sectionAppointments.isEmpty) {
//       return Center(
//         child: Text('No Appointments Found'),
//       );
//     }
//
//     return ListView.builder(
//       padding: EdgeInsets.all(10.0),
//       itemCount: sectionAppointments.length,
//       itemBuilder: (context, index) {
//         final appointment = sectionAppointments[index];
//         return AppointmentCard(appointment: appointment);
//       },
//     );
//   }
// }
//
// class AppointmentCard extends StatefulWidget {
//   final Map<String, dynamic> appointment;
//
//   // const AppointmentScreen({, Key? key}) : super(key: key);
//
//   const AppointmentCard({required this.appointment,});
//
//   @override
//   State<AppointmentCard> createState() => _AppointmentCardState();
// }
//
// final Map<int, String> specialties = {
//   1: 'General Physician',
//   2: 'Dentist',
//   3: 'Child Specialist',
//   4: 'Counselling Psychologist',
// };
//
// class _AppointmentCardState extends State<AppointmentCard> {
//
//   // return Card(
//   //   margin: EdgeInsets.symmetric(vertical: 10.0),
//   //   shape: RoundedRectangleBorder(
//   //     borderRadius: BorderRadius.circular(10.0),
//   //   ),
//   //   elevation: 4.0,
//   //   child: Padding(
//   //     padding: const EdgeInsets.all(10.0),
//   //     child: Row(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         // Placeholder image (or doctor image)
//   //         ClipRRect(
//   //           borderRadius: BorderRadius.circular(10.0),
//   //           // child: Image.network(
//   //           //   "https://via.placeholder.com/15", // Replace with an actual image URL
//   //           //   height: 50.0,
//   //           //   width: 50.0,
//   //           //   fit: BoxFit.cover,
//   //           // ),
//   //         ),
//   //         SizedBox(width: 10.0),
//   //         // Appointment details
//   //         Expanded(
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.start,
//   //             children: [
//   //               Text(
//   //                 widget.appointment['full_name'] ?? 'Unknown',
//   //                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
//   //               ),
//   //               SizedBox(height: 5.0),
//   //               Text(
//   //                 'Speciality: ${widget.appointment['speciality'] ?? 'N/A'}',
//   //                 style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
//   //               ),
//   //               SizedBox(height: 10.0),
//   //               Row(
//   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                 children: [
//   //                   Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       Text(
//   //                         'Date',
//   //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
//   //                       ),
//   //                       SizedBox(height: 5.0),
//   //                       Text(
//   //                         widget.appointment['date'] ?? 'N/A',
//   //                         style: TextStyle(color: Colors.grey[700], fontSize: 10.0),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   Column(
//   //                     crossAxisAlignment: CrossAxisAlignment.start,
//   //                     children: [
//   //                       Text(
//   //                         'Time',
//   //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
//   //                       ),
//   //                       SizedBox(height: 5.0),
//   //                       Text(
//   //                         widget.appointment['start_time'] ?? 'N/A',
//   //                         style: TextStyle(color: Colors.grey[700], fontSize: 10.0),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                 ],
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       ],
//   //     ),
//   //   ),
//   // );
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//         onTap: () {
//       // Navigate to the Appointment Detail Screen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => AppointmentDetailScreen(appointment: widget.appointment),
//         ),
//       );
//     },
//       child:  Card(
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       elevation: 4.0,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           children: [
//             // Top section with doctor details and video call button
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Doctor image placeholder (or actual doctor image)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(10.0),
//                   // child: Image.network(
//                   //   widget.appointment['image_url'] ??
//                   //       "https://via.placeholder.com/50", // Replace with actual image URL
//                   //   height: 50.0,
//                   //   width: 50.0,
//                   //   fit: BoxFit.cover,
//                   // ),
//               child: Image.network(
//           widget.appointment['image_url'] ??
//               "https://via.placeholder.com/50", // Replace with actual image URL
//           height: 50.0,
//           width: 50.0,
//           fit: BoxFit.cover,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) {
//               return child; // Image is fully loaded
//             }
//             return Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//               ),
//               height: 50.0,
//               width: 50.0,
//               alignment: Alignment.center,
//               child: CircularProgressIndicator(
//                 value: loadingProgress.expectedTotalBytes != null
//                     ? loadingProgress.cumulativeBytesLoaded /
//                     (loadingProgress.expectedTotalBytes ?? 1)
//                     : null,
//               ),
//             );
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//
//               height: 50.0,
//               width: 50.0,
//
//               color: Colors.grey[300],
//               child: Icon(
//                 Icons.person,
//                 color: Colors.grey,
//               ),
//             );
//           },
//         ),
//       ),
//
//                 SizedBox(width: 10.0),
//                 // Appointment details
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         // widget.appointment['full_name'] ?? 'Unknown',
//                         'Dr. ${widget.appointment['full_name'] ?? 'Unknown'}',
//                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
//                       ),
//                       SizedBox(height: 5.0),
//                       Text(
//                         // 'Speciality: ${widget.appointment['speciality'] ?? 'N/A'}',
//                         '${specialties[widget.appointment['speciality']] ?? 'N/A'}',
//                         style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
//                       ),
//                       SizedBox(height: 5.0),
//                       Text(
//                         'Appointment ID: ${widget.appointment['slot_id'] ?? 'N/A'}',
//                         style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
//                       ),
//                     ],
//                   ),
//                 ),
//                 // Video call button
//                 IconButton(
//                   onPressed: () {
//                     // Handle video call button press
//                   },
//                   icon: Container(
//                     padding: const EdgeInsets.all(12), // Add padding to give space around the icon
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.green, // Set the background color to orange
//                     ),
//                     child: const Icon(
//                       size: 25,
//                       Icons.video_call,
//                       color: Colors.white, // Set the icon color to white
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Divider (barline design)
//             Divider(color: Colors.grey[300], thickness: 1, height: 20),
//             // Bottom section with appointment type, date, and time
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // Appointment type
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Appointment Type',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
//                     ),
//                     SizedBox(height: 5.0),
//                     Text(
//                       // widget.appointment['appointment_type'] ?? 'N/A',
//                       'Video Consultation',
//                       style: TextStyle(color: Colors.green, fontSize: 10.0),
//                     ),
//                   ],
//                 ),
//                 // Date and Time
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Date & Time',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
//                     ),
//                     SizedBox(height: 5.0),
//                     Text(
//                       '${widget.appointment['date'] ?? 'N/A'}\t${widget.appointment['start_time'] ?? 'N/A'}',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(color: Colors.grey[700], fontSize: 10.0),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//     );
//
//
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
// import 'package:untitled10/screens/dashboard_screen.dart';
import 'package:untitled10/screens/main_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../APIServices/base_api.dart';
import '../call_page.dart';
import '../main.dart';
import 'AppointmentDetailScreen.dart';

class AppointmentScreen extends StatefulWidget {
  // final bool isFromDashboard;
  const AppointmentScreen({
    // this.isFromDashboard = false,
    Key? key}) : super(key: key);

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> with SingleTickerProviderStateMixin {

  late TabController _tabController;
  Map<String, List<dynamic>> appointments = {
    'today': [],
    'upcoming': [],
    'past': [],
    'canceled': [],
  };
  String? token;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchTodayAppointments(); // Fetch "today" appointments by default
  }

  Future<String?> getToken() async {
    try {
      var box = await Hive.openBox('userBox');
      final token = box.get('authToken');
      return token;
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  Future<void> fetchTodayAppointments() async {
    setState(() {
      isLoading = true;
    });
    String? bearerToken = await getToken();
    if (bearerToken != null) {
      final response = await http.get(
        Uri.parse("$baseapi/patient/list_appoint/today"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          appointments['today'] = data['data'] ?? [];
        });
      } else {
        print("Error fetching today appointments: ${response.body}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchUpcomingAppointments() async {
    setState(() {
      isLoading = true;
    });
    String? bearerToken = await getToken();
    if (bearerToken != null) {
      final response = await http.get(
        Uri.parse("$baseapi/patient/list_appoint/upcoming"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          appointments['upcoming'] = data['data'] ?? [];
        });
      } else {
        print("Error fetching upcoming appointments: ${response.body}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchPastAppointments() async {
    setState(() {
      isLoading = true;
    });
    String? bearerToken = await getToken();
    if (bearerToken != null) {
      final response = await http.get(
        Uri.parse("$baseapi/patient/list_appoint/past"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          appointments['past'] = data['data'] ?? [];
        });
      } else {
        print("Error fetching past appointments: ${response.body}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchCanceledAppointments() async {
    setState(() {
      isLoading = true;
    });
    String? bearerToken = await getToken();
    if (bearerToken != null) {
      final response = await http.get(
        Uri.parse("$baseapi/patient/cancel_list_appoint"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          appointments['canceled'] = data['data'] ?? [];
        });
      } else {
        print("Error fetching canceled appointments: ${response.body}");
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> cancelAppointment(String appointmentId) async {
    String? bearerToken = await getToken();
    if (bearerToken != null) {
      final response = await http.post(
        Uri.parse("$baseapi/patient/cancel_appoint"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: jsonEncode({'appointment_id': appointmentId}),
      );


      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        fetchCanceledAppointments(); // Refresh the canceled appointments list
        print('Appointment canceled successfully');
        // Show a SnackBar with success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              alignment: Alignment.center,
              height: 12, // Adjust height if needed
              child: Center(
                child: Text(
                  'Appointment canceled successfully',
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
            backgroundColor: Color(0xFF40BF78), // Background color
            behavior: SnackBarBehavior.floating, // Floating SnackBar
            margin: EdgeInsets.symmetric(horizontal: 120, vertical: 10), // Adjust padding
            elevation: 0, // Remove shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Rounded corners
            ),
            duration: Duration(seconds: 2), // Visible for 2 seconds
          ),
        );
      } else {
        print("Error canceling appointment: ${response.body}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Color(0xFF243B6D),
          // automaticallyImplyLeading: false,

        leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(0xFF243B6D),),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()))),

        title: Text('My Appointments', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,

        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.orange,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            switch (index) {
              case 0:
                fetchTodayAppointments();
                break;
              case 1:
                fetchUpcomingAppointments();
                break;
              case 2:
                fetchPastAppointments();
                break;
              case 3:
                fetchCanceledAppointments();
                break;
            }
          },
          tabs: [
            // Tab(text: 'Today',),
            // Tab(text: 'Upcoming'),
            // Tab(text: 'Past'),
            // Tab(text: 'Canceled'),

            Tab(
              child: Text(
                'Today',
                style: GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Upcoming',
                style: GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Past',
                style: GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Canceled',
                style: GoogleFonts.poppins(fontSize: 10,fontWeight: FontWeight.bold),
              ),
            ),

          ],
        ),
        foregroundColor: Colors.white,

      ),

      body: TabBarView(

        controller: _tabController,
        children: [
          buildAppointmentList('today'),
          buildAppointmentList('upcoming'),
          buildAppointmentList('past'),
          buildAppointmentList('canceled'),
        ],
      ),
    );
  }

  Widget buildAppointmentList(String section) {
    final List<dynamic> sectionAppointments = appointments[section] ?? [];

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator( color: Color(0xFF243B6D),),
      );
    }

    if (sectionAppointments.isEmpty) {
      return const Center(
        child: Text('No Appointments Found'),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: sectionAppointments.length,
      itemBuilder: (context, index) {
        final appointment = sectionAppointments[index];
        return AppointmentCard(
          appointment: appointment,
          onCancel: () => cancelAppointment(appointment['slot_id']),
          section: section, // Pass section to the card
        );
      },
    );
  }

}


class AppointmentCard extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback onCancel;
  final String section;



  const AppointmentCard({
    required this.appointment,
    required this.onCancel,
    required this.section,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

final Map<int, String> specialties = {
  1: 'General Physician',
  2: 'Dentist',
  3: 'Child specialists',
  4: 'Counselling Psychologist',
  5: 'Diabetologist',
  6: 'Family Physician',
  7: 'Orthologist ',
  8: 'General Surgery',
  9: 'Gynaecologist & OB',
  10: 'Head andNeckSurgery',
};

class _AppointmentCardState extends State<AppointmentCard> {

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => AppointmentDetailScreen(appointment: widget.appointment),
  //         ),
  //       );
  //     },
  //     child: Card(
  //       margin: EdgeInsets.symmetric(vertical: 10.0),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  //       elevation: 4.0,
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Column(
  //           children: [
  //             Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Placeholder for doctor image
  //                 ClipRRect(
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   child: Image.network(
  //                     widget.appointment['image_url'] ?? "https://via.placeholder.com/50",
  //                     height: 50.0,
  //                     width: 50.0,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 SizedBox(width: 10.0),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Dr. ${widget.appointment['full_name'] ?? 'Unknown'}',
  //                         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
  //                       ),
  //                       SizedBox(height: 5.0),
  //                       Text(
  //                         '${specialties[widget.appointment['speciality']] ?? 'N/A'}',
  //                         style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
  //                       ),
  //                       SizedBox(height: 5.0),
  //                       Text(
  //                         'Appointment ID: ${widget.appointment['slot_id'] ?? 'N/A'}',
  //                         style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 IconButton(
  //                   onPressed: widget.onCancel,
  //                   icon: Icon(Icons.cancel, color: Colors.red),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //
  //   );
  //
  // }

  bool showCancelButton = false; // Track visibility of cancel button

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the Appointment Detail Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AppointmentDetailScreen(appointment: widget.appointment, section: widget.section,) // Pass the section),
          ),
        );
      },
      child:  Card(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // Top section with doctor details and video call button
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor image placeholder (or actual doctor image)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.appointment['image_url'] ??
                          "https://via.placeholder.com/50", // Replace with actual image URL
                      height: 70.0,
                      width: 70.0,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child; // Image is fully loaded
                        }
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 50.0,
                          width: 50.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Color(0xFF243B6D),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(width: 10.0),
                  // Appointment details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // widget.appointment['full_name'] ?? 'Unknown',
                          'Dr. ${widget.appointment['full_name'] ?? ''}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          // 'Speciality: ${widget.appointment['speciality'] ?? 'N/A'}',
                          '${specialties[widget.appointment['speciality']] ?? '_'}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Appointment ID: ${widget.appointment['slot_id'] ?? 'N/A'}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                        ),
                      ],
                    ),
                  ),
                  // Video call button
                  if (widget.section == 'today' || widget.section == 'upcoming')
                  IconButton(
                    // onPressed: () {
                    //   // Navigate to MyHomePage
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => MyHomePage(appoinmentId: widget.appointment['slot_id'].toString(), appointmentId: null,)),
                    //   );
                    // },
                    onPressed: () {
                      // Navigate to MyHomePage
                      Navigator.push(
                        context,
                        // MaterialPageRoute(
                        //     builder: (context) => MyHomePage(
                        //       appoinmentId: appointment['slot_id'].toString(), appointmentId: null,
                        //     )
                        // ),
                        MaterialPageRoute(
                          builder: (context) => CallPage(
                            localUserId: localUserID, // Replace with actual user ID
                            id: widget.appointment['slot_id'].toString(), // Pass slot_id directly
                          ),
                        ),
                      );
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(12), // Add padding to give space around the icon
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green, // Set the background color to orange
                      ),
                      child: const Icon(
                        size: 25,
                        Icons.video_call,
                        color: Colors.white, // Set the icon color to white
                      ),
                    ),
                  ),
                ],
              ),


              // Divider (barline design)
              Divider(color: Colors.grey[300], thickness: 1, height: 20),
              // Bottom section with appointment type, date, and time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Appointment type
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appointment Type',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        // widget.appointment['appointment_type'] ?? 'N/A',
                        'Video Consultation',
                        style: TextStyle(color: Colors.green, fontSize: 10.0),
                      ),
                    ],
                  ),
                  // Date and Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Date & Time',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '${widget.appointment['date'] ?? 'N/A'}\t${widget.appointment['start_time'] ?? 'N/A'}',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.grey[700], fontSize: 10.0),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

