import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';
import 'appointments_nav_screen.dart';
import 'dashboard_screen.dart';
import 'doctor_nav_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'treatment_screen.dart';

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Appointment> appointments = [];

  final List<Doctor> doctors = [
    // Doctor(
    //     name: 'Dr. Shaikh',
    //     specialty: 'General Physician',
    //     // backgroundImage: AssetImage('assets/d4.jpeg'),
    //     imagePath: 'assets/d3.jpeg', // Replace with actual image asset
    //     experience: 7,
    //     consultationFee: 199,
    //     license: '66841',
    //     about: 'Experienced general physician specializing in primary care and preventive medicine.',
    // ),
    // Doctor(
    //   name: 'Dr. Sutar',
    //   specialty: 'General Physician',
    //   // backgroundImage: AssetImage('assets/d3.jpeg'),
    //     imagePath: 'https://th.bing.com/th/id/OIP.APjmKmC7pAwcvBCbKoxVmgHaGO?rs=1&pid=ImgDetMain',
    //   experience: 12,
    //   consultationFee: 199,
    //   license: 'I-60654-E',
    //   about: 'Seasoned doctor with expertise in managing chronic diseases and providing comprehensive healthcare.'
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardScreen(
            appointments: appointments,
            onCancelAppointment: _cancelAppointment,
            onBookAppointment: _bookAppointment,
            doctors: doctors,
          ),
          DoctorScreen(doctors: doctors, onBookAppointment: _bookAppointment),
          Profile(onLogout: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=> LoginScreen()),
            );
          },),
          AppointmentsScreen(appointments: appointments),
          TreatmentScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),

    );
  }

  Widget _buildBottomNavBar() {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;

          });
        },

        type: BottomNavigationBarType.fixed,

        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0165FC),
        unselectedItemColor: const Color.fromARGB(255, 75, 75, 75),
        // Customize the text size for selected and unselected labels
        selectedLabelStyle: TextStyle(
          fontSize: 13,  // Adjust text size for selected item
          fontWeight: FontWeight.bold,  // Optional: Make it bold for selected item
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,  // Adjust text size for unselected items
        ),

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.monitor_heart), label: 'Doctors'),

          // BottomNavigationBarItem(icon: Icon(Icons.manage_accounts), label: 'Profile'),

          BottomNavigationBarItem(icon: _buildImage('assets/Bharat Icon.jpg'),label: 'Profile'),

          BottomNavigationBarItem(icon: Icon(Icons.date_range), label: 'Appointment'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Treatment'),
        ],
      ),
    );
  }
  Widget _buildImage(String assetPath) {
    return SizedBox(
      width: 35,  // Adjust the width of the image
      height: 35, // Adjust the height of the image
      child:  Image.asset(
        assetPath,

        fit: BoxFit.contain, // Ensures the image fits well within the box
      ),
    );
  }


  void _bookAppointment(Doctor doctor, DateTime dateTime) {
    setState(() {
      appointments.add(Appointment(doctorName: doctor.name, dateTime: dateTime,));
    });
  }
  void _cancelAppointment(Appointment appointment) {
    setState(() {
      appointments.remove(appointment);
    });
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}