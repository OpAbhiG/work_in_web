import 'package:flutter/material.dart';
import '../DOCTOR_SCREEN/doctor_model.dart';
import '../models/doctor.dart';
import 'booking_screen.dart';
import 'doctor_nav_screen.dart';


class DoctorDetailScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doctor.fullName),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                // backgroundImage: AssetImage(widget.doctor.imagePath),
                radius: 50,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.doctor.fullName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.doctor.specialty,
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.doctor.experience} Years of Experience',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  '₹${widget.doctor.consultationFee}',
                  style: const TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'About Doctor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // const SizedBox(height: 8),
            // Text(
            //   widget.doctor.about,
            //   style: const TextStyle(fontSize: 16),
            // ),


            Center(

            child: Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AppointmentBookingScreen()),
                  ),
                  child: const Text('Appointment'),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
