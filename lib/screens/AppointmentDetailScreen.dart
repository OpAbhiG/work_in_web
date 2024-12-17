
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../APIServices/base_api.dart';
import '../VitalsHistory/PatientDetailsForm.dart';
import 'medical/medical1.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;
  final String section; // Add the section parameter

  const AppointmentDetailScreen({required this.appointment, required this.section,});

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Appointment canceled successfully")),
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
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details',style: TextStyle(fontSize: 18,color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor's Info Section
                Row(
                  children: [
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            height: 50.0,
                            width: 50.0,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
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
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${appointment['full_name'] ?? 'Unknown'}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        SizedBox(height: 4),
                        Text(
                          specialties[appointment['speciality']] ?? 'N/A',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // Handle video call button press
                        print('Initiate Video Call');
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
                // SizedBox(height: 20),
                // Appointment Info Section
                Divider(color: Colors.grey, thickness: 1, height: 20),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text('Date & Time'),
                  subtitle: Text(
                    '${appointment['date'] ?? 'N/A'} at ${appointment['start_time'] ?? 'N/A'}',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.local_hospital, color: Colors.blue),
                  title: Text('Clinic Name'),
                  subtitle: Text(appointment['clinic_name'] ?? 'N/A'),
                ),
                ListTile(
                  leading: Icon(Icons.tag, color: Colors.blue),
                  title: Text('Appointment ID'),
                  subtitle: Text('${appointment['slot_id'] ?? 'N/A'}'),
                ),

                // SizedBox(height: 20),
                // Action Buttons
                if (widget.section != 'past' && widget.section != 'canceled')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Add reschedule functionality here
                          },
                          child: Text('Reschedule',style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Show confirmation popup
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Cancel Appointment'),
                                  content: Text('Are you sure you want to cancel this appointment?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                      },
                                      child: Text('No', style: TextStyle(color: Colors.blue)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(); // Close the dialog
                                        Navigator.of(context).pop();
                                        cancelAppointment(); // Call the cancel appointment function
                                      },
                                      child: Text('Yes', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Cancel',style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    // Vitals Group Card
                    Card(
                      color: Colors.blue[50],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Medical Records",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MedicalRecordsScreen(),
                                  ),
                                );
                              },
                              icon: Icon(Icons.file_upload_outlined, color: Colors.white), // Add upload icon here
                              label: Text(
                                "Upload",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange, // Set the button color
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16,),
                Column(
                  children: [
                    // Vitals Group Card
                    Card(
                      color: Colors.blue[50],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Vitals Group",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PatientDetailsForm(),
                                  ),
                                );
                              },
                              icon: SizedBox.shrink(), // No icon before text
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "View History",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(width: 8), // Add spacing between text and icon
                                  Icon(Icons.arrow_forward_ios, color: Colors.white), // Right-arrow icon
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

        ),

      ),

    );
  }
}
