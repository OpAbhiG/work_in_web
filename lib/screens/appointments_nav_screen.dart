import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:login_registration_screen/screens/main_screen.dart';
import '../models/appointment.dart';
import 'main_screen.dart';
// import 'doctor_nav_screen.dart';


class AppointmentsScreen extends StatefulWidget {
  final List<Appointment> appointments;

  const AppointmentsScreen({super.key, required this.appointments});

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this); // Four tabs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
      // Navigate to the AppointmentsScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),);
    }


        ),
        title: const Text(
          'Appointments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor, // Set your desired background color here
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Today'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
                Tab(text: 'Cancel'),
              ],
              labelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.orange,
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList(widget.appointments),
                _buildAppointmentList(widget.appointments),
                _buildAppointmentList(widget.appointments),
                _buildAppointmentList(widget.appointments),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAppointmentList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return const Center(child: Text('No Appointments Found'));
    }
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return _buildAppointmentCard(appointments[index]);
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 28,
            //   // backgroundImage: AssetImage(appointment.imagePath), // Accessing instance member
            //
            // ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctorName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   appointment.specialization,
                  //   style: const TextStyle(fontSize: 14, color: Colors.grey),
                  // ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Video Consultation',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy, hh:mm a').format(appointment.dateTime),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
