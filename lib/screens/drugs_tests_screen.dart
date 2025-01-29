import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart' as pw;
import 'package:pdf/pdf.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/pdf.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import '../APIServices/base_api.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'dart:io';
// import 'package:printing/printing.dart';
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

  Future<void> fetchPrescriptions() async {
    try {
      String? bearerToken = await getToken();

      if (bearerToken == null || bearerToken.isEmpty) {
        print('Error: Authentication token is missing');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token is missing')),
        );
        return;
      }
      print("$baseapi/patient/get_prescriptions?slot_id=${widget.slotId}" );
      final url = Uri.parse(
        "$baseapi/patient/get_prescriptions?slot_id=${widget.slotId}",
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200) {

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        final data = json.decode(response.body);
        setState(() {
          // Update to handle the new response format
          prescriptions = data['prescriptions'] ?? []; // Get the prescriptions array
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to fetch data. Code: ${response.statusCode}');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to fetch data. Code: ${response.statusCode}')),
        // );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching prescriptions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  Map<String, List<dynamic>> _groupPrescriptionsByDate() {
    Map<String, List<dynamic>> groupedPrescriptions = {};

    for (var prescription in prescriptions) {
      String date = prescription['created_at'].split(' ')[0];
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
    fetchPrescriptions();
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
    final groupedPrescriptions = _groupPrescriptionsByDate();

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Drugs & Tests',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF243B6D),
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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
              onRefresh: () async {
                fetchPrescriptions();
              },
              displacement: 40,
              strokeWidth: 4,
              color: const Color(0xFF243B6D),
              backgroundColor: Colors.white,
              child: prescriptions.isEmpty
                  ? const Center(
                child: Text('No prescriptions available'),
              )
                  : ListView.builder(
                itemCount: prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = prescriptions[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(
                        prescription['drug_name'] ?? 'No Name',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF243B6D),
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dosage: ${prescription['dosage']} ${prescription['unit']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF243B6D),
                            ),
                          ),
                          Text(
                            'Duration: ${prescription['duration']} days',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF243B6D),
                            ),
                          ),
                          Text(
                            'Created: ${prescription['created_at']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF243B6D),
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF243B6D),
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PrescriptionDetailScreen(
                              prescriptionId: prescription['id'],
                              slotId: prescription['slot_id'].toString(),
                              prescriptionData: prescription,
                            ),
                          ),
                        );
                      },
                    ),
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
  final String slotId;
  final Map<String, dynamic> prescriptionData;

  const PrescriptionDetailScreen({
    super.key,
    required this.prescriptionId,
    required this.slotId,
    required this.prescriptionData,
  });

  @override
  _PrescriptionDetailScreenState createState() => _PrescriptionDetailScreenState();
}

// ... Previous code remains the same until the PrescriptionDetailScreen class mobile prescription ...

class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
  bool isDownloading = false;
  bool isLoading = false;

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

  Future<void> printPrescription() async {
    setState(() {
      isDownloading = true;
    });

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Container(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Center(
                  child: pw.Text(
                    'PRESCRIPTION',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 20),

                // Prescription Details
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Date: ${widget.prescriptionData['created_at']}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Text(
                      'Prescription ID: ${widget.prescriptionId}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),

                // Medication Details
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Medication Details',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(),
                      pw.SizedBox(height: 10),
                      pw.Text(
                        'Drug Name: ${widget.prescriptionData['drug_name']}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Dosage: ${widget.prescriptionData['dosage']} ${widget.prescriptionData['unit']}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Frequency: ${getFrequencyPattern(widget.prescriptionData['frequency'])}',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Duration: ${widget.prescriptionData['duration']} days',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Instructions
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Instructions',
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(),
                      pw.SizedBox(height: 10),
                      if (widget.prescriptionData['instruction'] != null)
                        pw.Text(
                          'Instructions: ${widget.prescriptionData['instruction']}',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                      if (widget.prescriptionData['notes'] != null)
                        pw.Text(
                          'Notes: ${widget.prescriptionData['notes']}',
                          style: const pw.TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),

                // Footer: Doctor name, appointment, signature
                pw.SizedBox(height: 30),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Signature: ___________',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 20),
                        pw.Text(
                          'Doctor: ${widget.prescriptionData['doctor_name']}',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          'License No: ${widget.prescriptionData['license_num']}',
                          style: pw.TextStyle(fontSize: 14),
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

      // Direct printing using the printing package
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Prescription_${widget.prescriptionId}',
      );

      _showSnackBar('Prescription sent to printer');
    } catch (e) {
      print('Printing error: $e');
      _showSnackBar('Error printing prescription');
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prescription Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF243B6D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Drug: ${widget.prescriptionData['drug_name']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243B6D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Dosage: ${widget.prescriptionData['dosage']} ${widget.prescriptionData['unit']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Frequency: ${getFrequencyPattern(widget.prescriptionData['frequency'])}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Duration: ${widget.prescriptionData['duration']} days',
                      style: const TextStyle(fontSize: 16),
                    ),
                    if (widget.prescriptionData['instruction'] != null)
                      Text(
                        'Instructions: ${widget.prescriptionData['instruction']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    if (widget.prescriptionData['notes'] != null)
                      Text(
                        'Notes: ${widget.prescriptionData['notes']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isDownloading ? null : printPrescription,
                          icon: isDownloading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Icon(Icons.print),
                          label: Text(isDownloading ? 'Printing...' : 'Print Prescription'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF243B6D),
                            foregroundColor: Colors.white,
                          ),
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
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
//tablet prescription design
// class _PrescriptionDetailScreenState extends State<PrescriptionDetailScreen> {
//   bool isDownloading = false;
//   bool isLoading = false;
//
//   final Map<String, String> frequencyMapping = {
//     '0-0-1': '1',
//     '0-1-0': '2',
//     '0-1-1': '3',
//     '1-0-0': '4',
//     '1-0-1': '5',
//     '1-1-0': '6',
//     '1-1-1': '7',
//   };
//
//   void _showSnackBar(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }
//
//   String getFrequencyPattern(dynamic frequencyValue) {
//     if (frequencyValue == null) return 'Unknown Frequency';
//     String frequencyString = frequencyValue.toString();
//
//     return frequencyMapping.entries
//         .firstWhere(
//           (entry) => entry.value == frequencyString,
//       orElse: () => const MapEntry('Unknown', 'Unknown'),
//     )
//         .key;
//   }
//
//   Future<void> printPrescription() async {
//     setState(() {
//       isDownloading = true;
//     });
//
//     try {
//       final pdf = pw.Document();
//
//       // Correct page format for 3-inch roll paper (72mm * 3 = 216mm, and height is customizable)
//       final customPageFormat = pw.PdfPageFormat(72 * 3, 1000); // 3 inches wide, adjustable height
//
//       pdf.addPage(
//         pw.Page(
//           pageFormat: customPageFormat,
//           build: (context) => pw.Container(
//             padding: const pw.EdgeInsets.all(8),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 // Title: Prescription
//                 pw.Center(
//                   child: pw.Text(
//                     'PRESCRIPTION',
//                     style: pw.TextStyle(
//                       fontSize: 14,
//                       fontWeight: pw.FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 pw.SizedBox(height: 8),
//
//                 // Patient details (Patient name, date, prescription ID)
//                 pw.Text(
//                   'Patient Name: ${widget.prescriptionData['patient_name']}',
//                   style: const pw.TextStyle(fontSize: 10),
//                 ),
//                 pw.Text(
//                   'Date: ${widget.prescriptionData['created_at']}',
//                   style: const pw.TextStyle(fontSize: 10),
//                 ),
//                 pw.Text(
//                   'Prescription ID: ${widget.prescriptionId}',
//                   style: const pw.TextStyle(fontSize: 10),
//                 ),
//                 pw.Text(
//                   'age: ${widget.prescriptionId}',
//                   style: const pw.TextStyle(fontSize: 10),
//                 ),
//                 pw.SizedBox(height: 12),
//
//                 // Vitals (Only show if available)
//                 if (widget.prescriptionData['vitals'] != null)
//                   pw.Container(
//                     padding: const pw.EdgeInsets.all(8),
//                     decoration: pw.BoxDecoration(
//                       border: pw.Border.all(),
//                       borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
//                     ),
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           'Vitals',
//                           style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//                         ),
//                         pw.SizedBox(height: 8),
//                         pw.Text('BP: ${widget.prescriptionData['vitals']['bp']}', style: const pw.TextStyle(fontSize: 10)),
//                         pw.Text('Temperature: ${widget.prescriptionData['vitals']['temperature']}', style: const pw.TextStyle(fontSize: 10)),
//                         pw.Text('Heart Rate: ${widget.prescriptionData['vitals']['heart_rate']}', style: const pw.TextStyle(fontSize: 10)),
//                       ],
//                     ),
//                   ),
//                 pw.SizedBox(height: 12),
//
//                 // Instructions (If available)
//                 if (widget.prescriptionData['instruction'] != null)
//                   pw.Container(
//                     padding: const pw.EdgeInsets.all(8),
//                     decoration: pw.BoxDecoration(
//                       border: pw.Border.all(),
//                       borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
//                     ),
//                     child: pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text(
//                           'Instructions',
//                           style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
//                         ),
//                         pw.SizedBox(height: 8),
//                         pw.Text('${widget.prescriptionData['instruction']}', style: const pw.TextStyle(fontSize: 10)),
//                       ],
//                     ),
//                   ),
//                 pw.SizedBox(height: 12),
//
//                 // Doctor Details
//                 pw.Divider(thickness: 1),
//                 pw.SizedBox(height: 8),
//                 pw.Text('Doctor: ${widget.prescriptionData['doctor_name']}', style: const pw.TextStyle(fontSize: 10)),
//                 pw.Text('License No: ${widget.prescriptionData['license_num']}', style: const pw.TextStyle(fontSize: 10)),
//                 pw.Text('Signature: ___________', style: const pw.TextStyle(fontSize: 10)),
//                 pw.SizedBox(height: 12),
//
//                 // Bill Details
//                 pw.Divider(thickness: 1),
//                 pw.SizedBox(height: 8),
//                 pw.Text('Bill Details:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 8),
//                 pw.Text('Cost:${widget.prescriptionData['cost']}', style: const pw.TextStyle(fontSize: 10)),
//                 pw.Text('CST:${widget.prescriptionData['cst']}', style: const pw.TextStyle(fontSize: 10)),
//                 pw.Text('GST:${widget.prescriptionData['gst']}', style: const pw.TextStyle(fontSize: 10)),
//                 pw.Text('Total:${widget.prescriptionData['total']}', style: const pw.TextStyle(fontSize: 10)),
//               ],
//             ),
//           ),
//         ),
//       );
//
//       // Direct printing using the printing package
//       await Printing.layoutPdf(
//         onLayout: (format) async => pdf.save(),
//         name: 'Prescription_${widget.prescriptionId}',
//       );
//
//       _showSnackBar('Prescription sent to printer');
//     } catch (e) {
//       print('Printing error: $e');
//       _showSnackBar('Error printing prescription');
//     } finally {
//       setState(() {
//         isDownloading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Prescription Details',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: const Color(0xFF243B6D),
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Drug: ${widget.prescriptionData['drug_name']}',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF243B6D),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'Dosage: ${widget.prescriptionData['dosage']} ${widget.prescriptionData['unit']}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     Text(
//                       'Frequency: ${getFrequencyPattern(widget.prescriptionData['frequency'])}',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     Text(
//                       'Duration: ${widget.prescriptionData['duration']} days',
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     if (widget.prescriptionData['instruction'] != null)
//                       Text(
//                         'Instructions: ${widget.prescriptionData['instruction']}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     if (widget.prescriptionData['notes'] != null)
//                       Text(
//                         'Notes: ${widget.prescriptionData['notes']}',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: isDownloading ? null : printPrescription,
//                           icon: isDownloading
//                               ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(
//                               strokeWidth: 2,
//                               color: Colors.white,
//                             ),
//                           )
//                               : const Icon(Icons.print),
//                           label: Text(isDownloading ? 'Printing...' : 'Print Prescription'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF243B6D),
//                             foregroundColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


