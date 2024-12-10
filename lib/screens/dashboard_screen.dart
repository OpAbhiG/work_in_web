import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../APIServices/base_api.dart';
import '../models/appointment.dart';
// import '../models/doctor.dart';
import 'appointments_nav_screen.dart';
import 'book_appoinment_dialog_status.dart';
import 'booking_screen.dart';
import 'doctor_nav_screen.dart';
import 'drugs_tests_screen.dart';
import 'medical/medical1.dart';
import 'medical_history_screen.dart';
// import '***medical_record_screen.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  // final List<Appointment> appointments;
  // final Function(Appointment) onCancelAppointment;
  final Function(Doctor, DateTime) onBookAppointment;
  final List<Doctor> doctors;

  const DashboardScreen({
    super.key,
    // required this.appointments,
    // required this.onCancelAppointment,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back arrow
        title: const Text('Dashboard',style: TextStyle(
          fontSize: 18, // Adjust font size
          fontWeight: FontWeight.bold, // Make text bold
          // fontFamily: 'Schyler', // Optional: Set a custom font family if you have one
        )),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,

      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                  const SizedBox(height: 16),
                  _buildUpcomingAppointments(),
                  const SizedBox(height: 16),
                  _buildBookAppointmentButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return
      Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
             Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/limg.jpg'),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       '$fname $lname',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Clinic Patient ID $id', // Show user ID
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem('Blood Group', '$blood_group'),
                _buildInfoItem('Weight', '-'),
                _buildInfoItem('Age', '$dob'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Row(
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
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.grey,fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle( fontSize: 10),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
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
      MaterialPageRoute(builder: (context) => MedicalHistoryScreen()),
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
    return Column(
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
        const SizedBox(height: 15),
        // widget.appointments.isEmpty
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No Appointments Found',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
        ),
        //      Column(
        //   children: widget.appointments
        //       .map((appointment) => _buildAppointmentCard(appointment))
        //       .toList(),
        // ),
      ],
    );
  }

  Widget _buildBookAppointmentButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppointmentBookingScreen(doctors: const [], onBookAppointment: (Doctor p1, DateTime p2) {  },)),
          ),
        icon: const Icon(Icons.calendar_today,color: Colors.white,),
        label: const Text('Book an Appointment',style: TextStyle(color: Colors.white)),
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

  // void _showBookAppointmentDialog(BuildContext context) {
  void _bookAppointmentDialog(BuildContext context, Doctor doctor) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: AppointmentBookingScreen(
            doctors: [doctor],  // Pass the selected doctor
            onBookAppointment: widget.onBookAppointment,  // Reference to the callback function
          ),
        );
      },
    );
  }

}





