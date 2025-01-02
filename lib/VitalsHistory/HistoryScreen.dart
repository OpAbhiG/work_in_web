import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../APIServices/base_api.dart';

class VitalHistoryScreen extends StatefulWidget {
  final int slotId;

  const VitalHistoryScreen({required this.slotId, super.key});

  @override
  _VitalHistoryScreenState createState() => _VitalHistoryScreenState();
}

class _VitalHistoryScreenState extends State<VitalHistoryScreen> {
  List<Map<String, dynamic>>? vitalDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVitalDetails();
  }
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
  Future<void> fetchVitalDetails() async {
    try {
      String? bearerToken = await getToken();

      // Check if the token is null or empty
      if (bearerToken == null || bearerToken.isEmpty) {
        print('Error: Authentication token is missing');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token is missing')),
        );
        return;
      }

      // Construct the URL with the slot_id as a query parameter
      final url = Uri.parse(
        "$baseapi/patient/get_vitals?slot_id=${widget.slotId}",
      );

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'Vitals fetched successfully') {
          setState(() {
            vitalDetails = List<Map<String, dynamic>>.from(responseData['vitals']);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'] ?? 'Error')),
          );
        }
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
      print('Error fetching vitals: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
  String _capitalizeFirstLetter(String text) {
    return text
        .split(' ') // Split the string into words
        .map((word) {
      // Capitalize the first letter of each word and join them back
      return word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '';
    })
        .join(' '); // Join all words back into a single string
  }

  // Refresh function
  Future<void> onRefresh() async {
    if (isLoading) return; // Prevent refresh if already loading
    setState(() {
      isLoading = true;
    });
    await fetchVitalDetails(); // Reload the data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Appointment Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF243B6D),
      ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          displacement: 40,
          strokeWidth: 4,
          color: Color(0xFF243B6D),
          backgroundColor: Colors.white,
          child: isLoading
              ? const Center(child: CircularProgressIndicator( color: Color(0xFF243B6D),))
              : vitalDetails == null || vitalDetails!.isEmpty
              ? const Center(child: Text('No details available'))
              : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: vitalDetails!.length,
              itemBuilder: (context, index) {
                final vital = vitalDetails![index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row for B Vital Group and Date-Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'B Vital Group',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF243B6D),
                              ),
                            ),
                            Text(
                              vital['date_time'] ?? 'N/A',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF243B6D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(thickness: 1, color: Colors.grey),
                        // Table for Vital Details
                        Table(

                          children: [
                            // Table Header Row
                            TableRow(
                              children: [
                                Text(
                                  'Vital Name',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Units',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            ...vital.entries
                                .where((entry) =>
                            ![
                              'slot_id',
                              'date_time',
                              'id',
                              'patient_id'
                            ].contains(entry.key) &&
                                entry.value != null)
                                .map(
                                  (entry) => TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      _capitalizeFirstLetter(entry.key
                                          .replaceAll('_', ' ')),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          entry.value.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _getUnits(entry.key),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                                // .toList(),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
    );
  }
  // Helper method to get units based on vital keys
  String _getUnits(String key) {
    switch (key) {
      case 'temperature':
        return '°C';
      case 'height':
        return 'cm';
      case 'weight':
        return 'kg';
      case 'bmi':
        return 'kg/m²';
      case 'blood_sugar_before_meal':
        return 'mg/dL';
      case 'blood_pressure':
        return 'mmHg';
      default:
        return '';
    }
  }
}
