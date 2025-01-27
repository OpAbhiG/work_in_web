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

      final url = Uri.parse(
        "$baseapi/patient/get_prescriptions?slot_id=${widget.slotId}",
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch data. Code: ${response.statusCode}')),
        );
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

  Future<void> downloadPrescription() async {
    setState(() {
      isDownloading = true;
    });

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Prescription', style: const pw.TextStyle(fontSize: 24)),
              pw.Divider(),
              pw.Text('Drug Name: ${widget.prescriptionData['drug_name']}'),
              pw.Text('Dosage: ${widget.prescriptionData['dosage']} ${widget.prescriptionData['unit']}'),
              pw.Text('Frequency: ${getFrequencyPattern(widget.prescriptionData['frequency'])}'),
              pw.Text('Duration: ${widget.prescriptionData['duration']} days'),
              pw.Text('Instructions: ${widget.prescriptionData['instruction'] ?? '--'}'),
              pw.Text('Notes: ${widget.prescriptionData['notes'] ?? '--'}'),
              pw.Text('Created At: ${widget.prescriptionData['created_at']}'),
            ],
          ),
        ),
      );

      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/prescription_${widget.prescriptionId}.pdf');
      await file.writeAsBytes(await pdf.save());

      _showSnackBar('PDF saved successfully');
      await Printing.layoutPdf(onLayout: (format) async {
        return pdf.save();
      });
    } catch (e) {
      _showSnackBar('Error in saving file');
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
                          onPressed: isDownloading ? null : downloadPrescription,
                          icon: isDownloading
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Icon(Icons.download),
                          label: Text(isDownloading ? 'Downloading...' : 'Download PDF'),
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
