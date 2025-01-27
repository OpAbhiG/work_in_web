import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../APIServices/base_api.dart';
import 'drugs_tests_screen.dart';

class TreatmentScreen extends StatefulWidget {
  const TreatmentScreen({super.key});

  @override
  State<TreatmentScreen> createState() => _TreatmentScreenState();
}

class _TreatmentScreenState extends State<TreatmentScreen> {
  List<dynamic> pastAppointments = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchPastAppointments();
  }

  Future<String?> getToken() async {
    try {
      var box = await Hive.openBox('userBox');
      return box.get('authToken');
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  Future<void> fetchPastAppointments() async {
    setState(() {
      isLoading = true;
    });

    String? bearerToken = await getToken();
    if (bearerToken != null) {
      try {
        final response = await http.get(
          Uri.parse("$baseapi/patient/list_appoint/past"),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          setState(() {
            pastAppointments = data['data'] ?? [];
          });
        } else {
          print("Error fetching past appointments: ${response.body}");
        }
      } catch (e) {
        print("Error: $e");
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF243B6D),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Treatment History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF243B6D),
        ),
      )
          : pastAppointments.isEmpty
          ? const Center(
        child: Text('No Past Appointments Found'),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: pastAppointments.length,
        itemBuilder: (context, index) {
          return PastAppointmentCard(
            appointment: pastAppointments[index],
          );
        },
      ),
    );
  }
}

class PastAppointmentCard extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const PastAppointmentCard({
    required this.appointment,
    Key? key,
  }) : super(key: key);

  static final Map<int, String> specialties = {
    1: 'General Physician',
    2: 'Dentist',
    3: 'Child specialists',
    4: 'Counselling Psychologist',
    5: 'Diabetologist',
    6: 'Family Physician',
    7: 'Orthologist',
    8: 'General Surgery',
    9: 'Gynaecologist & OB',
    10: 'Head and Neck Surgery',
  };

  @override
  State<PastAppointmentCard> createState() => _PastAppointmentCardState();
}

class _PastAppointmentCardState extends State<PastAppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TreatmentDetailScreen(appointment: widget.appointment),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.appointment['image_url'] ?? "https://via.placeholder.com/50",
                      height: 70.0,
                      width: 70.0,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 50.0,
                          width: 50.0,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: Color(0xFF243B6D),
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 50.0,
                          width: 50.0,
                          color: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${widget.appointment['full_name'] ?? ''}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          PastAppointmentCard.specialties[widget.appointment['speciality']] ?? '_',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Appointment ID: ${widget.appointment['slot_id'] ?? 'N/A'}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(color: Colors.grey[300], thickness: 1, height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consultation Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        'Video Consultation',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Date & Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '${widget.appointment['date'] ?? 'N/A'} ${widget.appointment['start_time'] ?? 'N/A'}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentDetailScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const TreatmentDetailScreen({
    required this.appointment,
    Key? key,
  }) : super(key: key);

  @override
  State<TreatmentDetailScreen> createState() => _TreatmentDetailScreenState();
}

class _TreatmentDetailScreenState extends State<TreatmentDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF243B6D),
        title: Text('Treatment Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Doctor Info Card
            Card(
              margin: EdgeInsets.all(16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Doctor Image and Name
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            widget.appointment['image_url'] ?? "https://via.placeholder.com/60",
                          ),
                          onBackgroundImageError: (_, __) {
                            Icon(Icons.person, size: 60);
                          },
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. ${widget.appointment['full_name'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF243B6D),
                                ),
                              ),
                              Text(
                                'Video Consultation',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Appointment Details
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Appointment ID',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                widget.appointment['slot_id']?.toString() ?? '',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF243B6D),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Date & Time',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${widget.appointment['date']} ${widget.appointment['start_time']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF243B6D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    SizedBox(height: 5),
                    // EMR and Prescription Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircularButton(
                          icon: Icons.description_outlined,
                          label: 'EMR',
                          onTap: () {
                            // Handle EMR button tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EMRScreen(slotId: widget.appointment['slot_id'], bearerToken: '',)),
                            );

                          },
                        ),
                        _buildCircularButton(
                          icon: Icons.medical_services_outlined,
                          label: 'Prescription',
                          onTap: () {
                            // Handle Prescription button tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DrugsTestsScreen(
                                  // slotId: slotId.toString(), // Pass slotId as a string
                                  slotId: widget.appointment['slot_id'].toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Medical Records Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF243B6D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Medical Records',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildRecordsSection('Uploaded by Patient'),
                  SizedBox(height: 16),
                  _buildRecordsSection('Uploaded by Doctor/Clinic'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildCircularButton({
  Widget _buildCircularButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () async {  // Modified to handle async operation
            String? bearerToken = await getToken();
            if (bearerToken != null) {
              if (label == 'EMR') {  // Check if it's the EMR button
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EMRScreen(
                      slotId: widget.appointment['slot_id'].toString(),
                      bearerToken: bearerToken,
                    ),
                  ),
                );
              } else {
                onTap();  // For other buttons, execute the original onTap
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Authentication error. Please login again.'),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF243B6D),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

// Add this function in your TreatmentDetailScreen class
  Future<String?> getToken() async {
    try {
      var box = await Hive.openBox('userBox');
      return box.get('authToken');
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  Widget _buildRecordsSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF243B6D),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'No Records Found',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class EMRScreen extends StatefulWidget {
  final String slotId;
  final String bearerToken;

  const EMRScreen({
    required this.slotId,
    required this.bearerToken,
    Key? key,
  }) : super(key: key);

  @override
  State<EMRScreen> createState() => _EMRScreenState();
}

class _EMRScreenState extends State<EMRScreen> {
  bool isLoading = true;
  Map<String, dynamic>? emrData;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchEMRData();
  }


// var emr='http://192.168.0.150:5000';

  Future<void> fetchEMRData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseapi/patient/get_all_emr?slot_id=${widget.slotId}'),
        headers: {'Authorization': 'Bearer ${widget.bearerToken}'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          emrData = data;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load EMR data';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF243B6D),
        title: const Text(
          'EMR Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF243B6D),
        ),
      )
          : error != null
          ? Center(
        child: Text(
          error!,
          style: const TextStyle(color: Colors.red),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow('Appointment ID', emrData?['slot_id']?.toString() ?? 'N/A'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Diagnosis', emrData?['diagnosis'] ?? 'N/A'),
                  const SizedBox(height: 16),
                  _buildInfoRow('Observations', emrData?['observations'] ?? 'N/A'),
                  const SizedBox(height: 16),
                  // if (emrData?['private_notes']?.isNotEmpty ?? false) ...[
                  //   _buildInfoRow('Private Notes', emrData?['private_notes']),
                  //   const SizedBox(height: 16),
                  // ],
                  // _buildInfoRow('Patient ID', emrData?['user_id']?.toString() ?? 'N/A'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF243B6D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}