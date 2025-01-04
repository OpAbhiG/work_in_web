import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../APIServices/api_services.dart';
import '../APIServices/base_api.dart';
// import '../models/doctor.dart';
// import 'book_appoinment_dialog_status.dart';
// import 'book_appointment_dialog.dart';
// import '../widgets/doctor_detail_screen.dart';
// import 'booking_confirmation_screen.dart';
import 'booking_screen.dart';
import 'doctor_detail_screen.dart';



class Doctor {
  final String fullName;
  final String about;
  final String qualification;
  final int speciality;
  final int experience;

  Doctor({
    required this.fullName,
    required this.about,
    required this.qualification,
    required this.speciality,
    required this.experience,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      fullName: json['full_name'] ?? '',
      about: json['about'] ?? '',
      qualification: json['qualification'] ?? '',
      speciality: json['speciality'] ?? 0,
      experience: json['experience'] ?? 0,
    );
  }
}


class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> doctors = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }
  Future<void> fetchDoctors() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
    try {
      var box = await Hive.openBox('userBox');
      String? token = box.get('authToken');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await http.get(
        Uri.parse('$baseapi/patient/filter_doctor'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null && jsonData['data'] is List) {
          setState(() {
            doctors = List<Doctor>.from(jsonData['data'].map((x) => Doctor.fromJson(x)));
            isLoading = false;
          });
        } else {
          throw Exception('Invalid data format received from the server');
        }
      } else if (response.statusCode == 401) {
        // await ApiServices().logout(context);
        throw Exception('Authentication failed. Please log in again.');
      } else {
        throw Exception('Failed to load doctors. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF243B6D),
        automaticallyImplyLeading: false, // Remove back arrow
        centerTitle: true,

        title: const Text('Doctors',
          style: TextStyle(
          fontSize: 18, // Adjust font size
          fontWeight: FontWeight.bold, // Make text bold
          // fontFamily: 'Schyler', // Optional: Set a custom font family if you have one
        )),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: fetchDoctors,
        displacement: 40,
        strokeWidth: 4,
        color: Color(0xFF243B6D),
        backgroundColor: Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue,))
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : doctors.isEmpty
            ? const Center(child: Text('No doctors found'))
            : ListView.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              // widget.appointment['image_url'] ??
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
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.fullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  specialties[doctor.speciality] ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Video Consult',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 9,
                                    ),
                                  ),

                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  '${doctor.experience} Y. Exp',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                ),

                              ),
                              const SizedBox(height: 8),
                              Text(
                                // '₹${doctor.consultationFee}',
                                '₹ 100',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey, thickness: 1, height: 20),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to DoctorDetailScreen with the selected doctor
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => DoctorDetailScreen(doctor: doctor, appointment: {},),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF243B6D),
                                padding: const EdgeInsets.symmetric(vertical: 5), // Reduced padding for smaller height
                                // padding: const EdgeInsets.symmetric(vertical: 18), // Padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Rounded corners
                                ),
                              ),
                              child: const Text('View Profile',
                                style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => AppointmentBookingScreen(doctors: const [], onBookAppointment: (Doctor p1, DateTime p2) {},)),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFF29200),
                                padding: const EdgeInsets.symmetric(vertical: 5), // Reduced padding for smaller height
                                // padding: const EdgeInsets.symmetric(vertical: 18), // Padding
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5), // Rounded corners
                                ),
                              ),
                              child: const Text('Book Appointment',
                                style: TextStyle(fontSize: 12,color: Colors.white,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ],                            // onBookAppointment: (Doctor p1, DateTime p2) {  },
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




