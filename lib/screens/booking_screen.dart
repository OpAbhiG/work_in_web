import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled10/screens/payment_screen.dart';
// import 'package:login_registration_screen/screens/payment_screen.dart';
import 'package:http/http.dart' as http;
import '../APIServices/base_api.dart';
import '../models/doctor.dart';
import 'doctor_nav_screen.dart';
import 'profile_screen.dart';


class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key});

  @override
  _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  late final Doctor doctor;
  // Box doctorCacheBox = Hive.box('doctorCache');
  int currentStep = 0;// for select step by step option
  bool isLoading = false;
  String? selectedSpecialty;
  int? selectedDoctor;

  bool isVideoConsultation = true;

  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;

  // Dummy data - replace with API calls later
  final Map<int, String> specialties = {
    1: 'Physician',
    2: 'Dentist',
    3: 'Child Specialist',
    4: 'Counselling Psychologist',
  };

  List<Map<String,dynamic>> doctors = [];//i get dynamic doctor name as per key mention in map above

  @override
  void initState() {
    super.initState();

    _initializeHive();

  }

  Future<void> _initializeHive() async {

  }

  @override
  void dispose() {
    // doctorCacheBox.close();
    Hive.close();
    super.dispose();
  }

  Future<void> fetchAndInitializeHive() async {
    await _initializeHive();
  }
  // Future<String> getDocumentsDirectoryPath() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   return directory.path;
  // }

  //old dr api 1.1
  // Future<List<String>> fetchDoctors(int specialtyKey) async {
  //   final response = await http.get(Uri.parse('$baseapi/patient/filter_doctor?speciality=$specialtyKey'));
  //
  //   if (response.statusCode == 200) {
  //
  //     // print(response);
  //
  //     // Assuming the response is a JSON array of doctor names
  //     List<dynamic> doctorData = json.decode(response.body);
  //     return List<String>.from(doctorData);
  //   } else {
  //     throw Exception('Failed to load doctors');
  //   }
  // }


  //old api 1.2
  // Future<List<String>> fetchDoctors(int specialtyKey) async {
  //   try {
  //     print("-------------------------");
  //     final response = await http.get(
  //       Uri.parse('$baseapi/patient/filter_doctor?speciality=$specialtyKey'),
  //     );
  //
  //     print("++++++++++++++++++++");
  //
  //     if (response.statusCode == 200) {
  //
  //       List<dynamic> doctorData = json.decode(response.body);
  //       return List<String>.from(doctorData);
  //     } else {
  //       print(response.body);
  //       throw Exception('Failed to load doctors');
  //     }
  //     print(response.body);
  //   } catch (e) {
  //     throw Exception('Error fetching doctors: $e');
  //
  //   }
  //
  // }



  // Save the token to Hive
  Future<void> saveToken(String token) async {
    var box = await Hive.openBox('userBox');
    await box.put('authToken', token);
    print('Token saved: $token');
  }
  // Retrieve token from Hive
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




  Future<List<Map<String, dynamic>>?> fetchDoctors(int specialtyKey) async {

    // if (doctorCacheBox.containsKey(specialtyKey)) {
    //   var a=doctorCacheBox.get(specialtyKey);
    //   print(a);
    //   return List<String>.from(a);
    //
    // }
    // if (doctorCacheBox.containsKey(specialtyKey)) {
    //   // Use cached data
    //   final cachedDoctors = doctorCacheBox.get(specialtyKey);
    //   return List<String>.from(cachedDoctors);
    // }

    try {
      String? bearerToken = await getToken();

      final response = await http.get(
        Uri.parse('$baseapi/patient/filter_doctor?speciality=$specialtyKey'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );
      print('$baseapi/patient/filter_doctor?speciality=$specialtyKey');
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {

        print("!!!!!!!!!!!!!!!!");
        print(response.body);


        // List<Map<String, dynamic>> doctorData = json.decode(response.body)['data'];

        // Safely cast the data to a list of maps
        List<Map<String, dynamic>> doctorData = (json.decode(response.body)['data'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();



        print("!!!!!!!!!133344!!!!!!!");
        print(doctorData);



        return doctorData;
      }else if (response.statusCode == 200) {

        return [];
      }

      else {
        return  [];
        final errorMsg = json.decode(response.body)['message'] ?? 'Failed to fetch doctors';

        throw Exception(errorMsg+'Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }




  final List<String> timeSlots = List.generate(73, (index) {
    final time = DateTime(2024, 1, 1, 0, index * 5);
    return DateFormat('h:mm a').format(time);
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Book Appointment',
            style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStep(0, 'Speciality', _buildSpecialtyDropdown()),
            if (currentStep >= 0) _buildStep(1, 'Doctor', _buildDoctorDropdown()),
            if (currentStep >= 2) _buildStep(2, 'Consultation Type', _buildConsultationType()),
            if (currentStep >= 0) _buildStep(3, '', _buildDateSelection()),
            if (currentStep >= 4) _buildStep(4, 'Available Time Slots', _buildTimeSlots()),

            const SizedBox(height: 16),
            if (currentStep == 5)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 40),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentScreen(),
                    ),
                  );
                },
                child: const Text('Confirm', style: TextStyle(color: Colors.white),),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int step, String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.black)),
        const SizedBox(height: 1),
        content,
        const SizedBox(height: 10),
        if (currentStep == step && step < 5)
          const Text(
            'Please complete this step to proceed.',
            style: TextStyle(color: Colors.red,fontSize: 8),
          ),
        // const SizedBox(height: 1),
      ],
    );
  }

  // Widget _buildSpecialtyDropdown() {
  //old drop down code 1.1
  //   return DropdownButtonFormField<String>(
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //         borderSide: BorderSide(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(12.0),  // Rounded edges
  //
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     ),
  //     value: selectedSpecialty,
  //     items: specialties.map((String item) {
  //       return DropdownMenuItem<String>(
  //         value: item,
  //         child: Text(item,
  //           style: const TextStyle(color: Colors.purple,fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (value) {
  //       setState(() {
  //         selectedSpecialty = value;
  //         currentStep = 1;
  //         selectedDoctor = null;  // Reset doctor when specialty changes
  //       });
  //     },
  //     hint: isLoading
  //         ? const Text('Loading...', style: TextStyle(fontSize: 10))
  //         : const Text('Select Specialty', style: TextStyle(fontSize: 10)),
  //   );
  // }
  // Widget _buildDoctorDropdown() {
  //   return DropdownButtonFormField<String>(
  //     decoration:  InputDecoration(
  //       border: OutlineInputBorder(
  //
  //         borderSide: const BorderSide(color: Colors.grey),
  //
  //         borderRadius: BorderRadius.circular(12.0),  // Rounded edges
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     ),
  //     value: selectedDoctor,
  //     items: doctors.map((String item) {
  //       return DropdownMenuItem<String>(
  //         value: item,
  //         child: Text(item,
  //           style: const TextStyle(color: Colors.purple,fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (value) {
  //       setState(() {
  //         selectedDoctor = value;
  //         currentStep = 2;
  //       });
  //     },
  //     hint: isLoading
  //         ? const Text('Loading...', style: TextStyle(fontSize: 10))
  //         : const Text('Select Doctor', style: TextStyle(fontSize: 10)),
  //   );
  // }

  // old 1.2
  // Widget _buildSpecialtyDropdown() {
  //   return DropdownButtonFormField<int>(
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //         borderSide: const BorderSide(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(12.0),
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     ),
  //     value: selectedSpecialty != null ? int.tryParse(selectedSpecialty!) : null,
  //     items: specialties.entries.map((entry) {
  //       return DropdownMenuItem<int>(
  //         value: entry.key,
  //         child: Text(
  //           entry.value,
  //           style: const TextStyle(color: Colors.purple, fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (value) async {
  //       setState(() {
  //         selectedSpecialty = value.toString();
  //         currentStep = 1;
  //         selectedDoctor = null; // Reset doctor when specialty changes
  //         isLoading = true;
  //       });
  //       try {
  //         final doctorList = await fetchDoctors(value!);
  //         setState(() {
  //           doctors.clear();
  //           doctors.addAll(doctorList);
  //         });
  //       } catch (e) {
  //         // Handle error
  //         print('Error fetching doctors: $e');
  //       } finally {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       }
  //     },
  //     hint: isLoading
  //         ? const Text('Loading...', style: TextStyle(fontSize: 10))
  //         : const Text('Select Specialty', style: TextStyle(fontSize: 10)),
  //   );
  // }
  // Widget _buildDoctorDropdown() {
  //   return DropdownButtonFormField<String>(
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(
  //         borderSide: const BorderSide(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(12.0),
  //       ),
  //       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //     ),
  //     value: selectedDoctor,
  //     items: doctors.map((String item) {
  //       return DropdownMenuItem<String>(
  //         value: item,
  //         child: Text(
  //           item,
  //           style: const TextStyle(color: Colors.purple, fontSize: 11),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (value) {
  //       setState(() {
  //         selectedDoctor = value;
  //         currentStep = 2;
  //       });
  //     },
  //     hint: const Text('Select Doctor', style: TextStyle(fontSize: 10)),
  //   );
  // }

  Widget _buildSpecialtyDropdown() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      value: selectedSpecialty != null ? int.tryParse(selectedSpecialty!) : null,
      items: specialties.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value, style: const TextStyle(fontSize: 11)),
        );
      }).toList(),
      onChanged: (value) async {
        setState(() {
          selectedSpecialty = value.toString();
          currentStep = 1;
          isLoading = true;
        });

        try {
          final doctorList = await fetchDoctors(value!);
          print("***********************");
          print(doctorList);
          setState(() {
            doctors = doctorList!;
            selectedDoctor = null; // Reset doctor selection

          })
          ;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      hint: isLoading
          ? const Text('Loading...', style: TextStyle(fontSize: 10))
          : const Text('Select Specialty', style: TextStyle(fontSize: 10)),
    );
  }
  Widget _buildDoctorDropdown() {
    return  doctors.length  == 0 ? const Text("No Doctors Found Please Select Other Specialty",style: TextStyle(color: Colors.red),):   DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      value: selectedDoctor,
      items: doctors.map<DropdownMenuItem<int>>((doctor) {
        return DropdownMenuItem<int>(
          value: doctor['id'],
          child: Text(doctor['full_name']),
        );
      }).toList(),


      onChanged: (value) {
        setState(() {
          selectedDoctor = value;
          currentStep = 2;
        });
      },
      hint: const Text('Select Doctor', style: TextStyle(fontSize: 10)),
    );
  }

  Widget _buildConsultationType() {
    return Row(
      children: [

        Radio<bool>(
          value: true,
          groupValue: isVideoConsultation,
          onChanged: (value) {
            setState(() {
              isVideoConsultation = value!;
              currentStep = 3;
            });
          },
        ),

        const Text('Video Consultation',style: TextStyle(fontSize: 9),),
        // Radio<bool>(
        //   value: false,
        //   groupValue: isVideoConsultation,
        //   onChanged: (value) {
        //     setState(() {
        //       isVideoConsultation = value!;
        //       currentStep = 3;
        //     });
        //   },
        // ),
        // const Text('In-person Consultation'),
      ],
    );
  }

  Widget _buildDateSelection() {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null && picked != selectedDate) {
          setState(() {
            selectedDate = picked;
            currentStep = 4;
            selectedTimeSlot = null;  // Reset time slot when date changes
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const Text(
              'Date of Appointment',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.calendar_month_outlined, color: Colors.orange, size: 40),
                Text(
                  DateFormat('d').format(selectedDate),
                  style: const TextStyle(color: Colors.orange, fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      DateFormat('EEEE').format(selectedDate),
                      style: const TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                    Text(
                      DateFormat('MMMM').format(selectedDate),
                      style: const TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  DateFormat('yyyy').format(selectedDate),
                  style: const TextStyle(color: Colors.orange, fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Available Time Slots', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: selectedTimeSlot == timeSlots[index] ? Colors.white : Colors.purple,
                backgroundColor: selectedTimeSlot == timeSlots[index] ? Colors.orange : Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),


              ),
              onPressed: () {
                setState(() {
                  selectedTimeSlot = timeSlots[index];
                  currentStep = 5;
                });
              },
              child: Text(timeSlots[index], style: const TextStyle(fontSize: 11,fontWeight: FontWeight.bold)),
            );

          },
        ),
      ],
    );
  }
}