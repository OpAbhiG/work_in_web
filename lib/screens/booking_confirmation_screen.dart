import 'package:flutter/material.dart';

import 'main_screen.dart';
// import 'package:login_registration_screen/screens/dashboard_screen.dart';
// import 'package:login_registration_screen/screens/main_screen.dart';

// import 'dashboard_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        title: Text(
          'Booking Confirmation',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 70,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'THANK YOU!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A237E),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Appointment Booked Successfully',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Appointment ID : 37832',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 32),
              _buildInfoRow('Date', 'Time', 'Nov 23, 2024', '10:10 AM',),



              SizedBox(height: 16),
              _buildInfoRow(
                'Appointment Type',
                'Dr. Kulsum Khan',
                'Video Consultation',
                'General Physician',
              ),
              SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // onPressed: () {
                  //   // Navigate to the ConfirmationScreen
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => DashboardScreen(doctors: [], appointments: [], onCancelAppointment: (Appointment ) {  }, onBookAppointment: (Doctor , DateTime ) {  },)),
                  //   );
                  // },

                  onPressed: () {
                    // Navigate to the ConfirmationScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Back to Dashboard',
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildInfoRow(String label1, String label2, String value1, String value2) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value1,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                value2,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}