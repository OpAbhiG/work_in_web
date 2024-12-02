// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:untitled10/DOCTOR_SCREEN/doctor_model.dart';
// import '../models/doctor.dart';
//
// class DoctorService {
//   static const String baseUrl = 'https://api.bharatteleclinic.co';
//
//   Future<List> fetchDoctors() async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/patient/filter_doctor'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({}), // Sending empty parameters
//     );
//
//     if (response.statusCode == 200) {
//       final jsonData = jsonDecode(response.body);
//       final doctors = (jsonData['data'] as List)
//           .map((doctor) => Doctor.fromJson(doctor))
//           .toList();
//       return doctors;
//     } else {
//       throw Exception('Failed to load doctors');
//     }
//   }
// }
