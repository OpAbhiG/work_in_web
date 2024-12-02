import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../APIServices/base_api.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import 'appointments_nav_screen.dart';
import 'book_appoinment_dialog_status.dart';
import 'booking_screen.dart';
import 'drugs_tests_screen.dart';
import 'medical/medical1.dart';
import 'medical_history_screen.dart';
// import '***medical_record_screen.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  final List<Appointment> appointments;
  final Function(Appointment) onCancelAppointment;
  final Function(Doctor, DateTime) onBookAppointment;
  final List<Doctor> doctors;

  const DashboardScreen({
    super.key,
    required this.appointments,
    required this.onCancelAppointment,
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

      print("================body============\n"+(response.body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          fname = data['profile']['fname'] ?? '';
          lname = data['profile']['lname'] ?? '';
          id = data['profile']['id'] ??''; // Convert id to String
          dob = data['profile']['dob'] ?? '';
          blood_group=data['profile']['blood_group']??'';


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

      body: SingleChildScrollView(
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
    );
  }

  Widget _buildProfileCard() {
    return Card(
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
                  MaterialPageRoute(builder: (context) => const AppointmentsScreen(appointments: [],)),
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
        widget.appointments.isEmpty
            ? const Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No Appointments Found',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
        )
            : Column(
          children: widget.appointments
              .map((appointment) => _buildAppointmentCard(appointment))
              .toList(),
        ),
      ],
    );
  }

  // Widget _buildAppointmentCard(Appointment appointment)
  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 1.1, horizontal: 1.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/d3.jpeg'),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,color: Colors.indigo
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "General Physician",
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigate to video call screen
                    Navigator.pushNamed(context, '/videoCallScreen');
                  },
                  icon: Icon(
                    Icons.videocam_rounded,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Divider(thickness: 1),
            // const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const Text(
                //       "Appointment ID",
                //       style: TextStyle(fontSize: 10, color: Colors.grey),
                //     ),
                //     // const SizedBox(height: 4),
                //     // Text(
                //     //   appointment.id.toString(),
                //     //   style: const TextStyle(
                //     //     fontSize: 14,
                //     //     fontWeight: FontWeight.bold,
                //     //   ),
                //     // ),
                //   ],
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(

                      "Appointment ID:",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),

                    const Text(

                      "Appointment Type:",
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    // const SizedBox(height: 4),

                    // Text(
                    //
                    //   "Video Consultation",
                    //   style: const TextStyle(
                    //     fontSize: 8,
                    //     color: Colors.green,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [

                    const Text(
                      "Date & Time",
                      style: TextStyle(fontSize: 12, color: Colors.indigo,fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy, hh:mm a')
                          .format(appointment.dateTime),
                      style: const TextStyle(
                        fontSize: 10,color: Colors.blueGrey
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Show cancel confirmation dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFF4D4D),
                              ),
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 70,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Cancel Appointment',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2559),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Are you sure?',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF1B2559),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Color(0xFF1B2559),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(color: Color(0xFF1B2559)),
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'No',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Color(0xFF1B2559),
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Trigger cancel appointment logic
                                      widget.onCancelAppointment(appointment);
                                    },
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(fontSize: 12),
                                    ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookAppointmentButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        // onPressed: () => _bookAppointmentDialog(context,doctors as Doctor),

        // onPressed: () {
        //   // Navigate to the ConfirmationScreen
        //   Nav<Doctor>igator.of(context).push(
        //     MaterialPageRoute(builder: (context) => DoctorScreen(onBookAppointment: (Doctor , DateTime ) {  }, doctors: [],)),
        //   );
        // },

        onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AppointmentBookingScreen()),
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
          child: BookAppointmentDialog(
            doctors: [doctor],  // Pass the selected doctor
            onBookAppointment: widget.onBookAppointment,  // Reference to the callback function
          ),
        );
      },
    );
  }


}




// class BookAppointmentDialogState extends State<BookAppointmentDialog> {
//   Doctor? selectedDoctor;
//   DateTime selectedDate = DateTime.now();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const Text(
//             'Book an Appointment',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           _buildDoctorDropdown(),
//           const SizedBox(height: 16),
//           _buildDateTimePicker(),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: selectedDoctor != null
//                 ? () {
//               widget.onBookAppointment(selectedDoctor!, selectedDate);
//               Navigator.of(context).pop();
//             }
//                 : null,
//             child: const Text('Book Appointment'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildDoctorDropdown() {
//     return DropdownButton<Doctor>(
//       value: selectedDoctor,
//       onChanged: (Doctor? newValue) {
//         setState(() {
//           selectedDoctor = newValue;
//         });
//       },
//       hint: const Text('Select Doctor'),
//       isExpanded: true,
//       items: widget.doctors.map((Doctor doctor) {
//         return DropdownMenuItem<Doctor>(
//           value: doctor,
//           child: Text(doctor.name),
//         );
//       }).toList(),
//     );
//   }
//   Widget _buildDateTimePicker() {
//     return InkWell(
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime.now().add(const Duration(days: 365)),
//         );
//         if (pickedDate != null) {
//           setState(() {
//             selectedDate = pickedDate;
//           });
//           // Call the time picker after selecting the date
//           await _selectTime(context);
//         }
//       },
//       child: InputDecorator(
//         decoration: const InputDecoration(
//           labelText: 'Select Date',
//           border: OutlineInputBorder(),
//         ),
//         child: Text(DateFormat('yyyy-MM-dd HH:mm').format(selectedDate)), // Update this line to show both date and time
//       ),
//     );
//   }
//   Future<void> _selectTime(BuildContext context) async {
//     TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (pickedTime != null) {
//       setState(() {
//         selectedDate = DateTime(
//           selectedDate.year,
//           selectedDate.month,
//           selectedDate.day,
//           pickedTime.hour,
//           pickedTime.minute,
//         );
//       });
//     }
//   }
//
// }
// class BookAppointmentDialog extends StatefulWidget {
//   final List<Doctor> doctors;
//   final Function(Doctor, DateTime) onBookAppointment;
//
//   const BookAppointmentDialog({
//     super.key,
//     required this.doctors,
//     required this.onBookAppointment,
//
//   });
//
//   @override
//   BookAppointmentDialogState createState() => BookAppointmentDialogState();
// }





// class MedicalRecordScreen extends StatelessWidget {
//   const MedicalRecordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       appBar: AppBar(title: const Text('Medical Record'),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//
//
//       ),
//
//       body: Center(
//         child: const Text('Medical Record Content'),
//       ),
//     );
//   }
// }
// class MedicalHistoryScreen extends StatelessWidget {
//   const MedicalHistoryScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Medical History'),
//         backgroundColor: Theme.of(context).primaryColor,
//         foregroundColor: Colors.white,
//
//       ),
//       body: Center(
//         child: const Text('Medical Record Content'),
//       ),
//     );
//   }
// }
// class DrugsTestsScreen extends StatelessWidget {
//   const DrugsTestsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Drug & Lab Tests'),
//           backgroundColor: Theme.of(context).primaryColor,
//           foregroundColor: Colors.white,
//           bottom: const TabBar(
//
//             labelColor: Colors.white, // Active tab color
//             unselectedLabelColor: Colors.white54, // Inactive tab color
//             indicatorColor: Colors.orange, // Line under the active tab
//
//             labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold), // Active tab text style
//             unselectedLabelStyle: TextStyle(fontSize: 10.0), // Inactive tab text style
//
//             tabs: [
//               Tab(icon: Icon(Icons.receipt_long), text: 'My ePrescription'),
//               Tab(icon: Icon(Icons.science), text: 'Lab Test'),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             Center(child: Text('ePrescription Content', style: TextStyle(fontSize: 18))),
//             Center(child: Text('Lab Test Content', style: TextStyle(fontSize: 18))),
//           ],
//         ),
//       ),
//     );
//   }
// }



