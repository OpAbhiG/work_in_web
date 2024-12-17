import 'package:flutter/material.dart';
// import '../DOCTOR_SCREEN/doctor_model.dart';
// import '../models/doctor.dart';
import 'booking_screen.dart';
import 'doctor_nav_screen.dart';


class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;
  final Map<String, dynamic> appointment;
  const DoctorDetailScreen({super.key, required this.doctor, required this.appointment});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {

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
    // final appointment = widget.appointment;
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns at the top
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
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns at the top
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5,left: 5),
                      child: Text(
                        widget.doctor.fullName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5,left: 5),
                      child: Text(
                        specialties[widget.doctor.speciality] ?? 'Speciality Not Available',

                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5,left: 5),
                      child: Text(
                        '${widget.doctor.experience} Years of Experience',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],

            ),



             SizedBox(height: 24),
             Text(
              'License Number',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
             Text(
              '1105Cd89',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
             SizedBox(height: 8),
             Text(
              widget.doctor.about,
              style: const TextStyle(fontSize: 13),
            ),
             Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppointmentBookingScreen(
                      doctors: const [],
                      onBookAppointment: (Doctor p1, DateTime p2) {
                      },
                    ),
                  ),
                ),
                icon: const Icon(
                  size: 13,
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                label: const Text(
                  'Book an Appointment',
                  style: TextStyle(color: Colors.white,fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Background color
                  padding: const EdgeInsets.symmetric(vertical: 14,horizontal: 14), // Padding
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
