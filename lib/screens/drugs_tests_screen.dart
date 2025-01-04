import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../APIServices/base_api.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'dart:convert';
import 'dart:io';
import 'package:printing/printing.dart';
// import 'appointments_nav_screen.dart';



class DrugsTestsScreen extends StatefulWidget {
  final String slotId;
  const DrugsTestsScreen({super.key, required this.slotId});

  @override
  _DrugsTestsScreenState createState() => _DrugsTestsScreenState();
}

class _DrugsTestsScreenState extends State<DrugsTestsScreen> {
  List<dynamic> prescriptions = [];
  bool isDownloading = false;
  bool isLoading = true;



  // Fetch the token from local storage (Hive)
  Future<String?> getToken() async {
    try {
      var box = await Hive.openBox('userBox');
      final token = box.get('authToken');
      return token;
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  // Fetch prescriptions from the API
  Future<void> fetchPrescriptions() async {
    try {

      String? bearerToken = await getToken();
      print(' ------------ inside tryyy ------------ ');


      if (bearerToken == null || bearerToken.isEmpty) {
        print('Error: Authentication token is missing');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token is missing')),
        );
        return;
      }
      print(http.Response);
      final url = Uri.parse(
        "$baseapi/patient/get_prescriptions?slot_id=${widget.slotId}",
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200) {

        print('-------- Drug --------');

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');



        final data = json.decode(response.body);
        setState(() {
          prescriptions = data['data']; // Assuming 'data' holds the list of prescriptions
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data. Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching prescriptions: ');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred')),
      );
    }
  }

  // Group prescriptions by date
  Map<String, List<dynamic>> _groupPrescriptionsByDate() {
    Map<String, List<dynamic>> groupedPrescriptions = {};


    for (var prescription in prescriptions) {


      String date = prescription['created_at'].split(' ')[0]; // Extract the date part (YYYY-MM-DD)
      if (groupedPrescriptions.containsKey(date)) {
        groupedPrescriptions[date]?.add(prescription);
      } else {
        groupedPrescriptions[date] = [prescription];
      }
    }

    return groupedPrescriptions;
  }

  @override
  void initState() {
    super.initState();
    fetchPrescriptions(); // Fetch prescriptions when screen loads
  }




  // Function to simulate downloading a prescription
  void downloadPrescription() {
    setState(() {
      isDownloading = true;
    });

    // Simulate a download with a delay
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isDownloading = false;
      });
    });
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
    final groupedPrescriptions = _groupPrescriptionsByDate(); // Group prescriptions by date

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Drugs & Tests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Color(0xFF243B6D),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: 'My ePrescription'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.orange,
          ),
        ),
        body: TabBarView(
          children: [
            // ePrescription Tab
            isLoading
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () async {
                fetchPrescriptions(); // Refresh data
              },
              displacement: 40,
              strokeWidth: 4,
              color: Color(0xFF243B6D),
              backgroundColor: Colors.white,
              child: ListView.builder(
                itemCount: groupedPrescriptions.keys.length,
                itemBuilder: (context, index) {
                  String date = groupedPrescriptions.keys.elementAt(index);
                  List<dynamic> prescriptionsForDate = groupedPrescriptions[date]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prescription Cards for this date
                      ListView.builder(
                        shrinkWrap: true, // To make it scrollable in the parent
                        physics: NeverScrollableScrollPhysics(), // Disable scrolling in nested list
                        itemCount: prescriptionsForDate.length,
                        itemBuilder: (context, prescriptionIndex) {
                          final prescription = prescriptionsForDate[prescriptionIndex];

                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8.0),
                              title: Text('Dr.${prescription['doctor_name']}',style: TextStyle(fontSize: 15,color: Color(0xFF243B6D),fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Speciality: ${specialties[prescription['doctor_speciality']] ?? 'Unknown Specialty'}',style: TextStyle(fontSize: 12,color: Color(0xFF243B6D),),),
                                  Text('Appointment ID: ${prescription['clinic_slot_id']}',style: TextStyle(fontSize: 12,color: Color(0xFF243B6D))),
                                  Text('Date & Time ${prescription['created_at']}',style: TextStyle(fontSize: 12,color: Color(0xFF243B6D),),),

                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right,
                                  color: Color(0xFF243B6D),
                              size: 30,), // Add iOS-style arrow
                              onTap: () {
                                // Navigate to Prescription Detail Screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PrescriptionDetailScreen(
                                      prescriptionId: prescription['prescription_id'],
                                      slotId: prescription['clinic_slot_id'].toString(),
                                      prescriptionData: {},

                                    ),
                                  ),
                                );
                              },
                            ),
                          );

                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionDetailScreen extends StatefulWidget {
  final int prescriptionId;
  // Make prescriptionId nullable
  // Map<String, dynamic> prescriptionId;
  final Map<String, dynamic> prescriptionData;



  final String slotId;
   const PrescriptionDetailScreen({super.key,

    required this.slotId, required this.prescriptionId, required this.prescriptionData

  });

  @override
  _PrescriptionDetailScreenState createState() =>
      _PrescriptionDetailScreenState();
}

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {

  Map<String, dynamic>? prescriptionId;

  // Fetch prescriptions from the API
  Future<void> fetchPrescriptions() async {
    try {
      String? bearerToken = await getToken();

      if (bearerToken == null || bearerToken.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token is missing')),
        );
        return;
      }

      final url = Uri.parse(
        "$baseapi/patient/get_prescriptions?slot_id=${widget.slotId}",
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200) {
        print('-------- prescript --------');
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        final data = json.decode(response.body);
        setState(() {
          prescriptionId = data['data']; // Assuming 'data' holds the list of prescriptions
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data. Code: ${response.statusCode}')),
        );
      }
    }
    catch (e) {
      setState(() {
        isLoading = false;
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('An error occurred: $e')),
      // );
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading=true;
    fetchPrescriptions(); // Fetch prescriptions when screen loads
  }

  // Fetch the token from local storage (Hive)
  Future<String?> getToken() async {
    try {
      var box = await Hive.openBox('userBox');
      final token = box.get('authToken');
      return token;
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
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




  bool isDownloading = false;
  late bool isLoading;
  // late final int prescriptionId;
  final Map<String, String> frequencyMapping = {
    '0-0-1': '1',
    '0-1-0': '2',
    '0-1-1': '3',
    '1-0-0': '4',
    '1-0-1': '5',
    '1-1-0': '6',
    '1-1-1': '7',
  };
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String getFrequencyPattern(dynamic frequencyValue) {
    if (frequencyValue == null) return 'Unknown Frequency';
    String frequencyString = frequencyValue.toString();

    return frequencyMapping.entries
        .firstWhere(
          (entry) => entry.value == frequencyString,
      orElse: () => const MapEntry('Unknown', 'Unknown'),
    )
        .key;
  }



  // Update prescriptionId to be a Map
  // late final Map<String, dynamic> prescriptionId;

  Future<void> downloadPrescription() async {



      // Simulate a download with a delay
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          isDownloading = false;
        });
      });


    print("Generating PDF-------------");

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Prescription', style: const pw.TextStyle(fontSize: 24)),
            pw.Divider(),
            pw.Text('Speciality: ${specialties[prescriptionId!['doctor_speciality']] ?? 'Unknown Specialty'}'),
            pw.Text('Appointment ID: ${prescriptionId!['clinic_slot_id']}'),
            pw.Text('Drug Name: ${prescriptionId?['drug_name'] ?? '---'}'),
            pw.Text('Dosage: ${prescriptionId?['dosage']} ${prescriptionId?['unit']}'),
            pw.Text('Frequency: ${getFrequencyPattern(prescriptionId?['frequency'])}'),
            pw.Text('Duration: ${prescriptionId?['duration']} days'),
            pw.Text('Instruction: ${prescriptionId?['instruction'] ?? '--'}'),
            pw.Text('Notes: ${prescriptionId?['notes'] ?? '--'}'),
          ],
        ),
      ),
    );


    try {
      print("PDF saved successfully");
      final output = await getApplicationDocumentsDirectory();
      // final file = File('${output.path}/prescription.pdf');
      final file = File('${output.path}/prescription_${widget.prescriptionId}.pdf');

      await file.writeAsBytes(await pdf.save());

      _showSnackBar('PDF saved successfully at ${file.path}');
      await Printing.layoutPdf(onLayout: (format) async {
        return pdf.save();

      });
    } catch (e) {
      print('Missing plugin exception caught');
      _showSnackBar('Error in saving file ');
    }
  }



  // // Function to simulate downloading a prescription

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
        backgroundColor: Color(0xFF243B6D),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              color: Color(0xFFD3D3D3), // Light gray color
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  children: [
                    TableRow(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text(
                            'Prescription ID',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: const Text(
                            'Action',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10), // Add spacing between cards
            // Second Card with ListView.builder
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.prescriptionId.toString(), // Display the prescription ID
                        ),
                        isDownloading
                            ? const SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            color: Color(0xFF243B6D),
                            strokeWidth: 2,
                          ),
                        )
                            : IconButton(
                          icon: const Icon(Icons.file_download_outlined, color: Colors.orange),
                          onPressed: () {
                            if (!isDownloading) {
                              downloadPrescription(); // Trigger the download

                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
