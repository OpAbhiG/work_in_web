import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../APIServices/base_api.dart';
// import '../VitalsHistory/PatientDetailsForm.dimport '../main.dart';
// art';
import '../VitalsHistory/HistoryScreen.dart';
// import '../VitalsHistory/PatientDetailsForm.dart';
import '../call_page.dart';
import '../main.dart';
import 'medical/medical1.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final String section; // Add the section parameter
  const AppointmentDetailScreen({required this.appointment, required this.section,
  });

  @override
  _AppointmentDetailScreenState createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {

  bool isLoading = false;
  Future<String?> getToken() async {
    try {
      var box = await Hive.openBox('userBox');
      final token = box.get('authToken');
      print('Token retrieved: $token');  // Debug: Check the value here
      return token;
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }
  Future<void> someApiCall() async {
    String? token = await getToken();
    if (token == null) {
      print('Token not available, please login.');
      return;
    }
    var url = Uri.parse('$baseapi/user/get_profile');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('API call successful');
    } else {
      print('API call failed: ${response.body}');
    }
  }
  Future<void> cancelAppointment() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? token = await getToken(); // Fetch the token

      if (token == null) {
        print('Error: Authorization token not available');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in. Please log in to continue.")),
        );
        return;
      }

      // Construct the query parameters string
      String params = "id=${widget.appointment['slot_id']}";

      // Full URL with parameters
      final url = Uri.parse('$baseapi/patient/cancel_appoint?$params');
      print('Request URL: $url'); // Debugging



      // Make the GET request
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Optional depending on API requirements
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
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
        print('Failure: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to cancel appointment: ${response.body}")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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


  @override
//   Widget build(BuildContext context) {
//     final appointment = widget.appointment;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF243B6D),
//         title: Text('Appointment Details',style: TextStyle(fontSize: 18,color: Colors.white),),
//         foregroundColor: Colors.white,
//       ),
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: isLoading
//               ? Center(child: CircularProgressIndicator())
//               : Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 4,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Doctor's Info Section
//                   Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.network(
//                           widget.appointment['image_url'] ??
//                               "https://via.placeholder.com/50", // Replace with actual image URL
//                           height: 70.0,
//                           width: 70.0,
//                           fit: BoxFit.cover,
//                           loadingBuilder: (context, child, loadingProgress) {
//                             if (loadingProgress == null) {
//                               return child; // Image is fully loaded
//                             }
//                             return Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                               ),
//                               height: 50.0,
//                               width: 50.0,
//                               alignment: Alignment.center,
//                               child: CircularProgressIndicator(
//                                 value: loadingProgress.expectedTotalBytes != null
//                                     ? loadingProgress.cumulativeBytesLoaded /
//                                     (loadingProgress.expectedTotalBytes ?? 1)
//                                     : null,
//                               ),
//                             );
//                           },
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               height: 50.0,
//                               width: 50.0,
//                               color: Colors.grey[300],
//                               child: Icon(
//                                 Icons.person,
//                                 color: Colors.grey,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       SizedBox(width: 16),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Dr. ${appointment['full_name'] ?? 'Unknown'}',
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             specialties[appointment['speciality']] ?? 'N/A',
//                             style: TextStyle(fontSize: 9, color: Colors.grey[600]),
//                           ),
//                         ],
//                       ),
//                       // const Spacer(),
//                       Padding(
//                         padding: const EdgeInsets.only(left: 60),
//                         child: Row(
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 // Navigate to MyHomePage
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(builder: (context) => MyHomePage(
//                                     appoinmentId: appointment['slot_id'].toString(),
//                                     appointmentId: null,)),
//                                 );
//                               },
//                               icon: Container(
//                                 padding: const EdgeInsets.all(10), // Add padding to give space around the icon
//                                 decoration: const BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.green, // Set the background color to orange
//                                 ),
//                                 child: const Icon(
//                                   size: 20,
//                                   Icons.video_call,
//                                   color: Colors.white, // Set the icon color to white
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   // SizedBox(height: 20),
//                   // Appointment Info Section
//                   Divider(color: Colors.grey, thickness: 1, height: 20),
//                   ListTile(
//                     leading: Icon(Icons.calendar_today, color: Colors.blue),
//                     title: Text('Date & Time'),
//                     subtitle: Text(
//                       '${appointment['date'] ?? 'N/A'} at ${appointment['start_time'] ?? 'N/A'}',
//                     ),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.local_hospital, color: Colors.blue),
//                     title: Text('Clinic Name'),
//                     subtitle: Text(appointment['clinic_name'] ?? 'N/A'),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.tag, color: Colors.blue),
//                     title: Text('Appointment ID'),
//                     subtitle: Text('${appointment['slot_id'] ?? 'N/A'}'),
//                   ),
//
//                   SizedBox(height: 20),
//                   // Action Buttons
//                   if (widget.section != 'past' && widget.section != 'canceled')
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Add reschedule functionality here
//                             },
//                             child: Text('Reschedule',style: TextStyle(color: Colors.white),),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.indigo,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 16),
//
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Show confirmation popup
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return Dialog(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Container(
//                                       padding: const EdgeInsets.all(20),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Align(
//                                             alignment: Alignment.topRight,
//                                             child: IconButton(
//                                               icon: const Icon(Icons.close_rounded),
//                                               onPressed: () => Navigator.of(context).pop(),
//                                             ),
//                                           ),
//                                           Container(
//                                             width: 60,
//                                             height: 60,
//                                             decoration: const BoxDecoration(
//                                               shape: BoxShape.circle,
//                                               color: Colors.orange,
//                                             ),
//                                             child: const Icon(
//                                               Icons.cancel_rounded, // Change icon to indicate cancellation
//                                               color: Colors.white,
//                                               size: 35,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 15),
//                                           const Text(
//                                             'Cancel Appointment',
//                                             style: TextStyle(
//                                               fontSize: 20,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.black87,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 10),
//                                           const Text(
//                                             'Are you sure you want to cancel this appointment?',
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black54,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 20),
//                                           Row(
//                                             children: [
//                                               Expanded(
//                                                 child: ElevatedButton(
//                                                   onPressed: () => Navigator.of(context).pop(), // Close the dialog
//                                                   style: ElevatedButton.styleFrom(
//                                                     backgroundColor: Colors.grey[300],
//                                                     foregroundColor: Colors.black,
//                                                   ),
//                                                   child: const Text('No'),
//                                                 ),
//                                               ),
//                                               const SizedBox(width: 10),
//                                               Expanded(
//                                                 child: ElevatedButton(
//                                                   onPressed: () {
//                                                     Navigator.of(context).pop(); // Close the dialog
//                                                     Navigator.of(context).pop(); // Go back to previous screen
//                                                     cancelAppointment(); // Call the cancel appointment function
//                                                   },
//                                                   style: ElevatedButton.styleFrom(
//                                                     backgroundColor: Color(0xFF243B6D),
//                                                     foregroundColor: Colors.white,
//                                                   ),
//                                                   child: const Text('Yes'),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             child: Text('Cancel',style: TextStyle(color: Colors.white),),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   SizedBox(height: 20,),
//                   Column(
//                     children: [
//                       // Vitals Group Card
//                       Card(
//                         elevation: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 "Medical Records",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               ElevatedButton.icon(
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           MedicalRecordsScreen(),
//                                     ),
//                                   );
//                                 },
//                                 icon: Icon(Icons.file_upload_outlined, color: Colors.white,size: 11,), // Add upload icon here
//                                 label: Text(
//                                   "Upload",
//                                   style: TextStyle(color: Colors.white,fontSize: 12),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.orange, // Set the button color
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//
//                   //vitals
//                   SizedBox(height: 16,),
//                   // Column(
//                   //   children: [
//                   //     // Vitals Group Card
//                   //     Card(
//                   //       color: Colors.blue[50],
//                   //       elevation: 4,
//                   //       child: Padding(
//                   //         padding: const EdgeInsets.all(16.0),
//                   //         child: Row(
//                   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //           children: [
//                   //             Text(
//                   //               "Vitals Group",
//                   //               style: TextStyle(
//                   //                 fontSize: 16,
//                   //                 fontWeight: FontWeight.bold,
//                   //                 color: Colors.black,
//                   //               ),
//                   //             ),
//                   //             ElevatedButton.icon(
//                   //               onPressed: () {
//                   //                 Navigator.push(
//                   //                   context,
//                   //                   MaterialPageRoute(
//                   //                     builder: (context) => PatientDetailsForm(),
//                   //                   ),
//                   //                 );
//                   //               },
//                   //               icon: SizedBox.shrink(), // No icon before text
//                   //               label: Row(
//                   //                 mainAxisSize: MainAxisSize.min,
//                   //                 children: [
//                   //                   Text(
//                   //                     "View History",
//                   //                     style: TextStyle(color: Colors.white),
//                   //                   ),
//                   //                   SizedBox(width: 8), // Add spacing between text and icon
//                   //                   Icon(Icons.arrow_forward_ios, color: Colors.white), // Right-arrow icon
//                   //                 ],
//                   //               ),
//                   //               style: ElevatedButton.styleFrom(
//                   //                 backgroundColor: Colors.orange,
//                   //               ),
//                   //             ),
//                   //
//                   //           ],
//                   //         ),
//                   //       ),
//                   //     ),
//                   //   ],
//                   // ),
//
//                   //new code
//                   Column(
//                     children: [
//                       Card(
//                         margin: const EdgeInsets.only(bottom: 15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 2,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Header Row with View History Button
//                             Container(
//                               decoration: const BoxDecoration(
//                                 color: Colors.indigo,
//                                 borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//                               ),
//                               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                               child: Row(
//                                 children: [
//                                   const Expanded(
//                                     child: Text(
//                                       'Vitals',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                     ),
//                                   ),
//                                   // Rectangular View History Button
//                                   SizedBox(
//                                     height: 35,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(builder: (context) => HistoryScreen(historyList: [],)),
//                                         );
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.orange,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(4),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         'View History',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
// /////////////////////////////////////////////////////////////////////////
//                             const SizedBox(height: 10),
//                             // Table Layout for Vitals
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16),
//                               child: Column(
//                                 children: [
//                                   _buildVitalsRow('Temperature', 'oc'),
//                                   _buildVitalsRow('Height', 'cm'),
//                                   _buildVitalsRow('Weight', 'kg'),
//                                   _buildVitalsRow('BMI', 'kg/m2'),
//                                   _buildVitalsRow('Blood Sugar (Before meal)', 'mg/dl'),
//                                   _buildVitalsRow('Blood Sugar (After meal)', 'mg/dl'),
//                                   _buildVitalsRow('Blood Pressure', 'mmgh'),
//                                   _buildVitalsRow('Pain Intensity scale', 'g'),
//                                   _buildVitalsRow('pulse', 'bpm'),
//                                   _buildVitalsRow('Oxygen saturation', 'g'),
//                                   _buildVitalsRow('Respiratory rate', 'lb'),
//                                   _buildVitalsRow('Smoking Status', ''),
//                                   _buildVitalsRow('Head Circumference', ''),
//                                   _buildVitalsRow('Heart rate', 'beats/min'),
//                                   _buildVitalsRow('pulse Pressure', 'mmhg'),
//                                   _buildVitalsRow('AFib detection', 'beats/min'),
//                                   _buildVitalsRow('PAC', 'num'),
//                                   _buildVitalsRow('PVC', 'num'),
//                                   _buildVitalsRow('cuff Detection', ''),
//                                   _buildVitalsRow('Movement Detection', ''),
//                                   _buildVitalsRow('TACH', 'beats/min'),
//                                   _buildVitalsRow('BRAD', 'beats/min'),
//                                   _buildVitalsRow('Irregular Heartbeat', ''),
//                                   _buildVitalsRow('Activated Clotting time', 'sec'),
//                                   _buildVitalsRow('Body Fat', '%'),
//                                   _buildVitalsRow('muscle', '%'),
//                                   _buildVitalsRow('Waist Circumference', 'cm'),
//                                   _buildVitalsRow('Visceral Fat', 'rating'),
//                                   _buildVitalsRow('BMR', 'kcal/day'),
//                                 ],
//                               ),
//                             ),
//                             // const SizedBox(height: 10),
//                             SizedBox(height: 10,),
//                             // View History Button
//                             Center(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Navigator.push(
//                                   //   context,
//                                   //   MaterialPageRoute(
//                                   //     builder: (context) => HistoryScreen(historyList: historyList),
//                                   //   ),
//                                   // );
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.indigo,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                       vertical: 10, horizontal: 14),
//                                 ),
//                                 child: const Text('Submit',style: TextStyle(color: Colors.white),),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       )
//     );
//   }
//   Widget _buildVitalsRow(String title, String unit) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               title,
//               style: const TextStyle(
//                 // fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               unit,
//               style: const TextStyle(color: Colors.black54),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: TextField(
//               decoration: InputDecoration(
//                 contentPadding:
//                 const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 isDense: true,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF243B6D),
        title: const Text(
          'Appointment Details',
          style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical:8.0 ),
          child: isLoading
              ? Center(child: CircularProgressIndicator( color: Color(0xFF243B6D),))
              : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // First Card
              Card(
                elevation: 4,
                // margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF243B6D),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              '${appointment['date'] ?? 'N/A'} at ${appointment['start_time'] ?? 'N/A'}',
                              style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.appointment['image_url'] ??
                                  "https://via.placeholder.com/50", // Replace with actual image URL
                              height: 80.0,
                              width: 80.0,
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
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. ${appointment['full_name'] ?? ''}',
                                style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
                              ),
                              Text(
                                specialties[appointment['speciality']] ?? 'N/A',
                                style: TextStyle(color: Colors.grey[600],fontSize: 9),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Padding(
                            padding: const EdgeInsets.only(right: 10),

                            child: Row(
                              children: [
                                IconButton(
                                  // onPressed: () {
                                  //   // Navigate to MyHomePage
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(builder: (context) => MyHomePage(
                                  //       appoinmentId: appointment['slot_id'].toString(),
                                  //       appointmentId: null,
                                  //     )),
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
                                          id: appointment['slot_id'].toString(), // Pass slot_id directly
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(10), // Add padding to give space around the icon
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green, // Set the background color to orange
                                    ),
                                    child: const Icon(
                                      size: 20,
                                      Icons.video_call,
                                      color: Colors.white, // Set the icon color to white
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Divider(color: Colors.grey, thickness: 1, height: 20),
                    const Divider(
                      color: Colors.grey, // Divider color
                      thickness: 1, // Divider thickness
                      indent: 15, // Left indent
                      endIndent: 15, // Right indent
                    ),
                    if (widget.section != 'past' && widget.section != 'canceled')
                    Padding(
                      padding: const EdgeInsets.only(left: 10,top: 5,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start, // Align buttons to the start
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Add reschedule functionality here
                            },
                            child: const Text(
                              'Reschedule',
                              style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold), // Adjust font size here
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF243B6D),
                              padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust padding for button size
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Small rounded edges
                              ),
                            ),

                          ),
                          const SizedBox(width: 5), // Space between the buttons
                          ElevatedButton(
                            onPressed: () {
                              // Show confirmation popup
                              showDialog(

                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () => Navigator.of(context).pop(),
                                            ),
                                          ),
                                          Container(

                                            width: 60,
                                            height: 60,

                                            decoration: const
                                            BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.orange,
                                            ),

                                            child: const Icon(
                                              Icons.warning, // Change icon to indicate cancellation
                                              color: Colors.white,
                                              size: 35,

                                            ),
                                          ),
                                          const SizedBox(height: 15),
                                          const Text(
                                            'Cancel Appointment',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Are you sure you want to cancel this appointment?',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () => Navigator.of(context).pop(), // Close the dialog
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.grey[300],
                                                    foregroundColor: Colors.black,
                                                  ),
                                                  child: const Text('No'),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the dialog
                                                    Navigator.of(context).pop(); // Go back to previous screen
                                                    cancelAppointment(); // Call the cancel appointment function
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Color(0xFF243B6D),
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  child: const Text('Yes'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 10,color: Colors.white,fontWeight: FontWeight.bold), // Adjust font size here
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust padding for button size
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5), // Small rounded edges
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),




                    // SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.only(left: 10,bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        children: [
                          const Text(
                            'Appointment ID',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            '${appointment['slot_id'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 8),
                          ),
                          const SizedBox(height: 10),  // Add spacing between items
                          const Text(
                            'Clinic Name',
                            style: TextStyle(fontSize: 10),
                          ),
                          Text(
                            appointment['clinic_name'] ?? 'N/A',
                            style: const TextStyle(fontSize: 8),
                          ),
                        ],
                      ),
                    )


                  ],
                ),

              ),
              const SizedBox(height: 5),
              // Second Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Medical Records",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Add upload functionality here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MedicalRecordsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.file_upload,color: Colors.white,size: 16,),
                          label: const Text("Upload",style: TextStyle(color: Colors.white),),

                          style: ElevatedButton.styleFrom(

                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 10), // Adjust padding for button size
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Small rounded edges
                            ),
                          ),

                        ),

                      ],
                    ),
                  ),
                ),
              ),


              const SizedBox(height: 15),
              Column(
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Row with View History Button
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF243B6D),
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Vitals',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              // Rectangular View History Button
                              SizedBox(
                                height:50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Add your navigation or functionality here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => VitalHistoryScreen(slotId: appointment['slot_id'])),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min, // Ensures the row wraps tightly around its children
                                    children: const [
                                      Text(
                                        'View History',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      SizedBox(width: 5), // Space between text and icon
                                      Icon(
                                        Icons.arrow_forward_ios, // iOS-style forward arrow
                                        color: Colors.white,
                                        size: 16, // Adjust icon size to fit the text
                                      ),
                                    ],
                                  ),
                                ),

                              ),
                            ],
                          ),
                        ),
/////////////////////////////////////////////////////////////////////////
                        const SizedBox(height: 10),
                        // Table Layout for Vitals
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          // child: Column(
                          //   children: [
                          //     _buildVitalsRow('Temperature', 'oc'),
                          //     _buildVitalsRow('Height', 'cm'),
                          //     _buildVitalsRow('Weight', 'kg'),
                          //     _buildVitalsRow('BMI', 'kg/m2'),
                          //     _buildVitalsRow('Blood Sugar (Before meal)', 'mg/dl'),
                          //     _buildVitalsRow('Blood Sugar (After meal)', 'mg/dl'),
                          //     _buildVitalsRow('Blood Pressure', 'mmgh'),
                          //     _buildVitalsRow('Pain Intensity scale', 'g'),
                          //     _buildVitalsRow('pulse', 'bpm'),
                          //     _buildVitalsRow('Oxygen saturation', 'g'),
                          //     _buildVitalsRow('Respiratory rate', 'lb'),
                          //     _buildVitalsRow('Smoking Status', ''),
                          //     _buildVitalsRow('Head Circumference', ''),
                          //     _buildVitalsRow('Heart rate', 'beats/min'),
                          //     _buildVitalsRow('pulse Pressure', 'mmhg'),
                          //     _buildVitalsRow('AFib detection', 'beats/min'),
                          //     _buildVitalsRow('PAC', 'num'),
                          //     _buildVitalsRow('PVC', 'num'),
                          //     _buildVitalsRow('cuff Detection', ''),
                          //     _buildVitalsRow('Movement Detection', ''),
                          //     _buildVitalsRow('TACH', 'beats/min'),
                          //     _buildVitalsRow('BRAD', 'beats/min'),
                          //     _buildVitalsRow('Irregular Heartbeat', ''),
                          //     _buildVitalsRow('Activated Clotting time', 'sec'),
                          //     _buildVitalsRow('Body Fat', '%'),
                          //     _buildVitalsRow('muscle', '%'),
                          //     _buildVitalsRow('Waist Circumference', 'cm'),
                          //     _buildVitalsRow('Visceral Fat', 'rating'),
                          //     _buildVitalsRow('BMR', 'kcal/day'),
                          //   ],
                          // ),

                          child: Column(

                            children: [
                              // Header Row
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'B Vital Group',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF243B6D),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                color: Colors.black12,
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: const Text(
                                        'Vital Name',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: const Text(
                                        'Units',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.now()),
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8.0), // Add spacing after header row
                              // Vitals Rows

                              Column(
                                children: [
                                  _buildVitalsRow('Temperature', 'oc'),
                                  _buildVitalsRow('Height', 'cm'),
                                  _buildVitalsRow('Weight', 'kg'),
                                  _buildVitalsRow('BMI', 'kg/m2'),
                                  _buildVitalsRow('Blood Sugar (Before meal)', 'mg/dl'),
                                  _buildVitalsRow('Blood Sugar (After meal)', 'mg/dl'),
                                  _buildVitalsRow('Blood Pressure', 'mmgh'),
                                  _buildVitalsRow('Pain Intensity scale', 'g'),
                                  _buildVitalsRow('pulse', 'bpm'),
                                  _buildVitalsRow('Oxygen saturation', 'g'),
                                  _buildVitalsRow('Respiratory rate', 'lb'),
                                  _buildVitalsRow('Smoking Status', ''),
                                  _buildVitalsRow('Head Circumference', ''),
                                  _buildVitalsRow('Heart rate', 'beats/min'),
                                  _buildVitalsRow('pulse Pressure', 'mmhg'),
                                  _buildVitalsRow('AFib detection', 'beats/min'),
                                  _buildVitalsRow('PAC', 'num'),
                                  _buildVitalsRow('PVC', 'num'),
                                  _buildVitalsRow('cuff Detection', ''),
                                  _buildVitalsRow('Movement Detection', ''),
                                  _buildVitalsRow('TACH', 'beats/min'),
                                  _buildVitalsRow('BRAD', 'beats/min'),
                                  _buildVitalsRow('Irregular Heartbeat', ''),
                                  _buildVitalsRow('Activated Clotting time', 'sec'),
                                  _buildVitalsRow('Body Fat', '%'),
                                  _buildVitalsRow('muscle', '%'),
                                  _buildVitalsRow('Waist Circumference', 'cm'),
                                  _buildVitalsRow('Visceral Fat', 'rating'),
                                  _buildVitalsRow('BMR', 'kcal/day'),
                                ],
                              ),

                            ],
                          ),



                        ),
                        // const SizedBox(height: 10),
                        const SizedBox(height: 15),
                        // View History Button
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => HistoryScreen(historyList: [],),
                                //   ),
                                // );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF243B6D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                              ),
                              child: const Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

            ],

          ),

        ),

      ),

    );

  }
  Widget _buildVitalsRow(String title, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              unit,
              style: const TextStyle(color: Colors.black54,fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }


}

