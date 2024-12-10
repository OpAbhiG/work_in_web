
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../APIServices/base_api.dart';
class AppointmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetailScreen({required this.appointment});

  @override
  _AppointmentDetailScreenState createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  bool isLoading = false;



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

  Future<void> cancelAppointment() async {
    setState(() {
      isLoading = true;
    });

    try {
      String? token = await getToken(); // Fetch the token
      final response = await http.post(
        Uri.parse('$baseapi/patient/cancel_appoint?patient_id=${widget.appointment['patient_id']}&appointment_id=${widget.appointment['appointment_id']}'),
        headers: {
          'Authorization': 'Bearer $token',
          // 'Content-Type': 'application/json',
        },



        body: jsonEncode({
          // 'patient_id': widget.appointment['patient_id'],
          // 'appointment_id': widget.appointment['appointment_id'],
        }),
      );



      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');



      if (response.statusCode == 200) {
        print(response.body);

        // Handle success
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Appointment canceled successfully")));
      } else {
        // Handle failure
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to cancel appointment")));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occurred")));
    } finally {
      setState(() {
        isLoading = false;
      });
    }

  }

  final Map<int, String> specialties = {
    1: 'General Physician',
    2: 'Dentist',
    3: 'Child Specialist',
    4: 'Counselling Psychologist',
  };


  @override
  Widget build(BuildContext context) {
    final appointment = widget.appointment;
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text('Dr. ${appointment['full_name'] ?? 'Unknown'}',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 10),
              Text('${specialties[widget.appointment['speciality']] ?? 'N/A'}',),
              SizedBox(height: 10),
              Text('Appointment ID: ${appointment['slot_id'] ?? 'N/A'}'),
              SizedBox(height: 10),
              Text('Date: ${appointment['date'] ?? 'N/A'}'),
              SizedBox(height: 10),
              Text('Time: ${appointment['start_time'] ?? 'N/A'}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: cancelAppointment,
                child: Text('Cancel Appointment',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
                        ],
                      ),
            ),
      ),
    );
  }
}
