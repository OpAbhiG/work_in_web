import 'package:flutter/material.dart';
import '../models/doctor.dart';
import 'book_appoinment_dialog_status.dart';
// import 'book_appointment_dialog.dart';
// import '../widgets/doctor_detail_screen.dart';
import 'booking_confirmation_screen.dart';
import 'doctor_detail_screen.dart';


class DoctorScreen extends StatelessWidget {
  final Function(Doctor, DateTime) onBookAppointment;

  DoctorScreen({super.key, required this.onBookAppointment, required List<Doctor> doctors});

  // Define two unique doctor instances
  final List<Doctor> doctors = [
    Doctor(
      name: "Dr. John Smith",
      specialty: "Cardiologist",
      experience: 10,
      consultationFee: 500,
      license: '11235',
      about: "Dr. John Smith is a highly experienced cardiologist specializing in cardiovascular diseases.",
      imagePath: 'assets/d3.jpeg', // Replace with actual image asset
    ),
    Doctor(
      name: "Dr. Sarah Johnson",
      specialty: "Dermatologist",
      experience: 5,
      consultationFee: 300,
      license: '105h2',
      about: "Dr. Sarah Johnson focuses on skin health and offers cosmetic dermatology services.",
      imagePath: 'assets/d5.jpeg', // Replace with actual image asset
    ),

    Doctor(
      name: "Dr. atish",
      specialty: "brain",
      experience: 4,
      consultationFee: 200,
      license: '021458d',
      about: "Dr. atish is a highly experienced cardiologist specializing in brain diseases.",
      imagePath: 'assets/d4.jpeg', // Replace with actual image asset
    ),




  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Doctors", style: TextStyle(
          fontSize: 18, // Adjust font size
          fontWeight: FontWeight.bold, // Make text bold
          // fontFamily: 'Schyler', // Optional: Set a custom font family if you have one
        )),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(doctor.imagePath),
                          radius: 35,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                doctor.specialty,
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
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
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
                              '₹${doctor.consultationFee}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // Navigate to DoctorDetailScreen with the selected doctor
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DoctorDetailScreen(doctor: doctor),
                                ),
                              );
                            },
                            child: const Text('View Profile',style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              _bookAppointmentDialog(context, doctor);



                            },
                            child: const Text('Appointment',style: TextStyle(color: Colors.white),),
                          ),
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
    );
  }

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
            onBookAppointment: onBookAppointment,  // Reference to the callback function
          ),
        );
      },
    );
  }
}




