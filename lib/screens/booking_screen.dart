import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled10/screens/payment_screen.dart';
import 'package:http/http.dart' as http;
import '../APIServices/base_api.dart';
import 'doctor_nav_screen.dart';
import 'profile_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key, required List<Doctor> doctors,
    required Function(Doctor p1, DateTime p2) onBookAppointment,

  });

  @override
  _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
}
class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  late final Doctor doctor;
  int currentStep = 0;
  bool isLoading = true;
  String? selectedSpecialty;
  bool isVideoConsultation = true;

  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  int? selectedDoctor;

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

  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> availableTimeSlots = [];


  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _initializeHive();
  }

  Future<void> _initializeHive() async {}

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  Future<void> fetchAndInitializeHive() async {
    await _initializeHive();
  }

  Future<void> saveToken(String token) async {
    var box = await Hive.openBox('userBox');
    await box.put('authToken', token);
    print('Token saved: $token');
  }

  Future<String?> getToken() async {
    try {
      var box = await Hive.openBox('userBox');
      final token = box.get('authToken');
      print('Token retrieved: $token');
      return token;
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchDoctors(int specialtyKey) async {
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

        List<Map<String, dynamic>> doctorData = (json.decode(response.body)['data'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();

        // print("!!!!!!!!!133344!!!!!!!");

        print(doctorData);

        return doctorData;
      } else if (response.statusCode == 200) {
        return [];
      } else {
        return [];
        final errorMsg = json.decode(response.body)['message'] ?? 'Failed to fetch doctors';
        throw Exception(errorMsg + 'Failed to load doctors');
      }
    } catch (e) {
      throw Exception('Error fetching doctors: $e');
    }
  }


  Future<void> fetchAvailableSlots() async {
    setState(() => isLoading = true);
    try {
      String? bearerToken = await getToken();
      final response = await http.get(
        Uri.parse('$baseapi/patient/get_slote?doctor_id=$selectedDoctor&date=${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
        headers: {
          'Authorization': 'Bearer $bearerToken',
        },
      );

      if (response.statusCode == 200) {
        print('patient/get_slote');

        print(response);
        final data = json.decode(response.body);

        // Check if the response contains any available slots
        if (data['data'] != null && data['data']['slots'] != null) {
          List<dynamic> slots = data['data']['slots'];

          // Filter the slots to only include available ones
          List<Map<String, dynamic>> availableSlots = slots
              .where((slot) => slot['available'] == true)
              .map((slot) => slot as Map<String, dynamic>)
              .toList();

          if (availableSlots.isNotEmpty) {
            setState(() {
              availableTimeSlots = availableSlots;
              errorMessage = ""; // Clear any error message
            });
          } else {
            setState(() {
              availableTimeSlots = [];
              errorMessage = "No available slots today"; // Set error message for no available slots
            });
          }
        } else {
          setState(() {
            availableTimeSlots = [];
            errorMessage = "Failed to load available slots"; // Handle if slots or data are missing
          });
        }
      } else {
        throw Exception('Failed to load available slots');
      }
    } catch (e) {
      print('Error fetching available slots');
      setState(() {
        availableTimeSlots = []; // Clear available slots on error
        errorMessage = 'Failed to load available slots'; // Set error message
      });
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to load available slots')),
      // );
    } finally {
      setState(() => isLoading = false);
    }
  }


// // 1.1 version
//   Future<void> fetchAvailableSlots() async {
//     setState(() => isLoading = true);
//     try {
//       String? bearerToken = await getToken();
//       final response = await http.get(
//         Uri.parse('$baseapi/patient/get_slote?doctor_id=$selectedDoctor&date=${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
//         headers: {
//           'Authorization': 'Bearer $bearerToken',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           availableTimeSlots = (data['data']['slots'] as List<dynamic>? ?? [])
//               .map((slot) => slot as Map<String, dynamic>)
//               .toList();
//         });
//       } else {
//         throw Exception('Failed to load available slots');
//       }
//     } catch (e) {
//       print('Error fetching available slots: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to load available slots: $e')),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }



  // Future<void> fetchAvailableSlots() async {
  //1.2 error display
  //   setState(() => isLoading = true);
  //
  //   try {
  //     String? bearerToken = await getToken();
  //     final response = await http.get(
  //       Uri.parse('$baseapi/patient/get_slote?doctor_id=$selectedDoctor&date=${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
  //       headers: {
  //         'Authorization': 'Bearer $bearerToken',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //
  //       // Check if the response contains an error message for unavailable doctors
  //       if (data[0]['error'] != null) {
  //         setState(() {
  //           availableTimeSlots = []; // No available slots
  //           errorMessage = data[0]['error']; // Display the error message from backend (e.g., "Doctor not available")
  //         });
  //       } else if (data['data']['slots'] == null || (data['data']['slots'] as List).isEmpty) {
  //         // No slots available for the selected date
  //         setState(() {
  //           availableTimeSlots = [];
  //           errorMessage = "No slots available today"; // Set error message
  //         });
  //       } else {
  //         // Available slots found
  //         setState(() {
  //           availableTimeSlots = (data['data']['slots'] as List<dynamic>? ?? [])
  //             .map((slot) => slot as Map<String, dynamic>)
  //             .toList();
  //           errorMessage = ""; // Clear any error message
  //         });
  //       }
  //     } else {
  //       // Handle other status codes or failures
  //       throw Exception('Failed to load available slots');
  //     }
  //   } catch (e) {
  //     print('Error fetching available slots');
  //     setState(() {
  //       availableTimeSlots = [];
  //       errorMessage = 'Doctor is not available'; // Set error message in case of exception
  //     });
  //   } finally {
  //     setState(() => isLoading = false);
  //   }
  // }



  Future<void> bookAppointment() async {
    setState(() => isLoading = true);
    try {
      String? bearerToken = await getToken();
      if (bearerToken == null) {
        throw Exception('Authentication token is missing');
      }

      // Creating the JSON payload

      // Dynamically constructing the URL with query parameters
      final url = Uri.parse('$baseapi/patient/book_slot');

      print('Request URL: $url');
      print('$baseapi/patient/book_slot?doctor_id=$selectedDoctor&date=${DateFormat('yyyy-MM-dd').format(selectedDate)}&start_time=$selectedTimeSlot');

      // Sending GET request with parameters in the URL
      final response = await http.post(
        url,

        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/x-www-form-urlencoded', // Form data content type
        },
       body: {
         "doctor_id": selectedDoctor.toString(),
         "date": DateFormat('yyyy-MM-dd').format(selectedDate),
         "start_time": selectedTimeSlot,
       },
      );

      print('Request URL: $url');

      if (response.statusCode == 200) {
        print('Appointment booked successfully');
        //done
        // Show a SnackBar with success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Appointment booked successfully',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF40BF78),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );

        // Navigate to the PaymentScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentScreen(
              full_name: selectedDoctor.toString(), // Replace with actual data
              doctor_id: 0, // Replace with actual doctor ID
              amount: 199.0, // Replace with actual amount
              time:selectedTimeSlot.toString(),
              date:selectedDate,

                doctors: doctors,
                selectedDoctor: selectedDoctor
            ),
          ),
        );
      } else {
        print('Failed to book appointment: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to book appointment: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error booking appointment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book appointment: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF243B6D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Book Appointment',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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

            // Show error message if availableTimeSlots is empty
            if (errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Center(
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
              ),

            const SizedBox(height: 16),
            if (currentStep == 5)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: const Size(double.infinity, 40),
                ),
                onPressed: () {
                  bookAppointment();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaymentScreen(
                      full_name: selectedDoctor.toString(), // Replace with actual data
                      doctor_id: 123, // Replace with actual doctor ID
                      amount: 199.0, // Replace with actual amount
                      time:  selectedTimeSlot.toString(),
                      date:selectedDate, doctors: [],
                    )),
                  );
                },
                child: const Text('Confirm', style: TextStyle(color: Colors.white)),
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
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
        const SizedBox(height: 1),
        content,
        const SizedBox(height: 10),
        if (currentStep == step && step < 5)
          const Text(
            'Please complete this step to proceed.',
            style: TextStyle(color: Colors.red, fontSize: 8),
          ),
      ],
    );
  }

  Widget _buildSpecialtyDropdown() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey), // Gray border
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      value: selectedSpecialty != null ? int.tryParse(selectedSpecialty!) : null,
      items: specialties.entries.map((entry) {
        return DropdownMenuItem<int>(
          value: entry.key,
          child: Text(entry.value, style: const TextStyle(fontSize: 10)),
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
          });
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
    return doctors.isEmpty
        ? const Text("No Doctors Found Please Select Other Specialty",
      style: TextStyle(color: Colors.red,fontSize: 10))
        : DropdownButtonFormField<int>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey), // Gray border
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      value: selectedDoctor,
      items: doctors.map<DropdownMenuItem<int>>((doctor) {
        return DropdownMenuItem<int>(
          value: doctor['id'],
          child: Text(doctor['full_name'],style: const TextStyle(fontSize: 10),),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedDoctor = value;
          currentStep = 2;
        });
      },
      hint: isLoading
          ? const Text('Loading...', style: TextStyle(fontSize: 10))
          : const Text('Select Doctor', style: TextStyle(fontSize: 10)),
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
        const Text('Video Consultation', style: TextStyle(fontSize: 9)),
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
            selectedTimeSlot = null;
          });
          fetchAvailableSlots(); // Fetch available slots for the selected date
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
        const SizedBox(height: 12),
        availableTimeSlots.isEmpty
            ? Center(child: Text('No available slots for this date'))
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
          ),
          itemCount: availableTimeSlots.length,
          itemBuilder: (context, index) {
            final slot = availableTimeSlots[index];
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: selectedTimeSlot == slot['time'] ? Colors.white : Colors.purple,
                backgroundColor: selectedTimeSlot == slot['time'] ? Colors.orange : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: slot['available'] ? () {
                setState(() {
                  selectedTimeSlot = slot['time'];
                  currentStep = 5;
                });
              } : null,
              child: Text(
                slot['time'],
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: slot['available'] ? null : Colors.grey,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  }

