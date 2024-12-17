import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../APIServices/base_api.dart';
import '../VitalsHistory/HistoryScreen.dart';
import '../models/appointment.dart';
import 'AppointmentDetailScreen.dart';
import 'appointments_nav_screen.dart';
import 'booking_screen.dart';
import 'doctor_nav_screen.dart';
import 'drugs_tests_screen.dart';
import 'invoice.dart';
import 'medical/medical1.dart';
import 'medical_history_screen.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  final Function(Doctor, DateTime) onBookAppointment;
  final List<Doctor> doctors;
  const DashboardScreen({
    super.key,
    required this.onBookAppointment,
    required this.doctors,
  });
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String fname = '';
  String lname = '';
  int id = 0 ;
  String blood_group='';
  String dob='';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
    fetchTodayAppointments();
  }

  // Save the token to Hive
  Future<void> saveToken(String token) async {
    var box = await Hive.openBox('userBox');
    await box.put('authToken', token);
    print('Token saved: $token');
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
  // Retrieve token from Hive
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
  // Fetch profile data from API
  Future<void> fetchProfile() async {
    try {

      String? bearerToken = await getToken();

      // print("+++++++++ token   +++++++");

      // print(bearerToken);

      if (bearerToken == null) {
        showError('Authentication token not found.');
        return;
      }

      var url = Uri.parse("$baseapi/user/get_profile");//get profile to get data from BE
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      // print("================body============\n"+(response.body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          fname = data['data']['fname'] ?? '';
          lname = data['data']['lname'] ?? '';
          id = data['data']['id'] ??''; // Convert id to String
          dob = data['data']['dob'] ?? '';
          blood_group=data['data']['blood_group']??'';


          isLoading = false;
        });


      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to load profile: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('An error occurred: $e');
    }
  }
  // Show error messages
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }



  Map<String, List<dynamic>> appointments = {
    'today': [],
  };
  String? token;
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
      } else {
        print("Error canceling appointment: ${response.body}");
      }
    }
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
  Future<void> fetchTodayAppointments() async {
    setState(() {
      isLoading = true;
    });
    String? bearerToken = await getToken();
    if (bearerToken == null || bearerToken.isEmpty) {
      setState(() {
        isLoading = false;
      });
      print('Token is null or empty.');
      return;
    }
    try {
      final response = await http.get(
        Uri.parse("$baseapi/patient/list_appoint/today"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          appointments['today'] = (data['data'] as List).map((item) {
            return {
              'full_name': item['full_name'] ?? 'Unknown Patient',
              'start_time': item['start_time'] ?? 'N/A',
              'speciality': item['speciality'] ?? 'Unknown Clinic',
              'image_url': item['image_url'] ?? '', // Add image URL field
              'slot_id': item['slot_id'] ?? 'N/A', // Slot ID
              'date':item['date']??'na',
            };
          }).toList();
        });
      } else {
        print("Error fetching today appointments: ${response.body}");
      }
    } catch (e) {
      print("Error during API call: $e");
    }
    setState(() {
      isLoading = false;
    });
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
    return Scaffold(
      // backgroundColor: const Color(0x80F2F2F2), // Semi-transparent light gray
      backgroundColor: Colors.grey[50],
        appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back arrow
        title: const Text('Dashboard',style: TextStyle(
          fontSize: 18, // Adjust font size
          fontWeight: FontWeight.bold, // Make text bold
          // fontFamily: 'Schyler', // Optional: Set a custom font family if you have one
        )),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(),
                  SizedBox(height: 16,),
                  _buildUpcomingAppointments(),
                  SizedBox(height: 20,),
                  _buildBookAppointmentButton(context),
                  SizedBox(height: 16,),
                  _recentInvice(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileCard() {
    return Card(
      // margin: EdgeInsets.symmetric(vertical: 10.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
             Row(
               crossAxisAlignment: CrossAxisAlignment.center,

               children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/limg.jpg'),
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       '$fname $lname',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Clinic Patient ID $id', // Show user ID
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

          // const VerticalDivider(color: Colors.grey,thickness: 1,width: 20,),
          const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem('Blood Group', '$blood_group'),
                _buildInfoItem('Weight', '-'),
                _buildInfoItem('Age', '$dob'),
              ],

            ),

            Divider(color: Colors.grey[300], thickness: 1, height: 20),

            // SizedBox(height: 20), // Add some space between info and action buttons

            // Action Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  context,
                  Icons.medical_information_rounded,
                  'Medical Record',
                      () => _onMedicalRecordTapped(context),
                ),
                _buildActionButton(
                  context,
                  Icons.history_outlined,
                  'Medical History',
                      () => _onMedicalHistoryTapped(context),
                ),
                _buildActionButton(
                  context,
                  Icons.medication,
                  'Drugs/Tests',
                      () => _onDrugsTestsTapped(context),
                ),
              ],
            ),
          ],
        ),
      ),

    );
  }


  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey,fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle( fontSize: 9),
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      IconData icon,
      String label,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap, // Execute the passed function when tapped
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  // Action for Medical Record
  void _onMedicalRecordTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MedicalRecordsScreen()),
    );
  }
  // Action for Medical History
  void _onMedicalHistoryTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HistoryScreen(historyList: [],)),
    );
  }
  // Action for Drugs/Tests
  void _onDrugsTestsTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DrugsTestsScreen()),
    );
  }

  Widget _buildUpcomingAppointments() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Appointments',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),

              TextButton(
                onPressed: () {
                  // Navigate to the AppointmentsScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AppointmentScreen(isFromDashboard: true)),
                  );
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              )
            ],
          ),
          // const SizedBox(height: 10),
          isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.blue,))
              : appointments['today']!.isEmpty
              ? const Center(child: Text('No appointments today.',style: TextStyle(fontSize: 10),))
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: appointments['today']!.length,
            itemBuilder: (context, index) {
              final appointment = appointments['today']![index];
              return GestureDetector(
                onTap: () {
                  // Navigate to appointment detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentDetailScreen(
                        appointment: appointment, section: '',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Top section with doctor details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Doctor profile image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                appointment['image_url'] ??
                                    "https://via.placeholder.com/50",
                                height: 70.0,
                                width: 70.0,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(
                                    decoration: const BoxDecoration(
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
                            SizedBox(width: 10.0),
                            // Appointment details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dr. ${appointment['full_name']}',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    // '${appointment['speciality']}',
                                    '${specialties[appointment['speciality']] ?? ''}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    'Appointment ID: ${appointment['slot_id']}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12.0),
                                  ),

                                ],

                              ),

                            ),
                            IconButton(
                              onPressed: () {
                                // Handle video call button press
                                print('Initiate Video Call');
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
                                  '${appointment['date'] ?? 'N/A'}\t${appointment['start_time']}',
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
            },
          ),


        ],
      ),
    );
  }

  Widget _buildBookAppointmentButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppointmentBookingScreen(doctors: const [], onBookAppointment: (Doctor p1, DateTime p2) {  },)),
          ),
        icon: const Icon(Icons.calendar_today,color: Colors.white,size: 18,),
        label: const Text('Book an Appointment',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,

          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _recentInvice(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Payment',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),

              TextButton(
                onPressed: () {
                  // Navigate to the AppointmentsScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  InvoiceScreen()),
                  );
                },
                child: Text(
                  'View all',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              )
            ],
          ),
        const SizedBox(height: 18,),
        isLoading
        ? Center( child: CircularProgressIndicator(color: Colors.blue,),)
        : Center(child: Text('No payment found.',style: TextStyle(fontSize: 10),))
        ],
      );
  }
}





