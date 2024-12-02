import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../APIServices/base_api.dart';
import 'change_password.dart';
import 'login_screen.dart';
class Profile extends StatefulWidget {
  final VoidCallback onLogout;
  const Profile({super.key, required this.onLogout});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String fname = '';
  String lname = '';
  String aadhar_no='';
  // String blood_group='';

  String email='';
  String gender='';
  String number='';
  String dob='';
  String id='';


  bool isLoading = true;



  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  // Save the token to Hive
  Future<void> saveToken(String token) async {
    var box = await Hive.openBox('userBox');
    await box.put('authToken', token);
    print('Token saved: $token');
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

  // Fetch profile data from API
  Future<void> fetchProfile() async {
    try {

      String? bearerToken = await getToken();
      // String? bearerToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmcmVzaCI6ZmFsc2UsImlhdCI6MTczMjIwMTg0MiwianRpIjoiNDAyYzkyMDMtMTkwMS00MmMxLWEwZTAtZDRjZTlkYTBkNjYzIiwidHlwZSI6ImFjY2VzcyIsInN1YiI6MjUyLCJuYmYiOjE3MzIyMDE4NDIsImNzcmYiOiJhYzFlNmRlMC05ZTZlLTQ1MjYtYmQ5MC1lZDc0ZjAwOTdlMDciLCJleHAiOjE3MzIyMDIxNDJ9.qQ7bWDTavmTP-ugPA9z7WNdMcPBIMY6rXluDa4zXKLk";

      // print("+++++++++ token   +++++++");

      // print(bearerToken);

      if (bearerToken == null) {
        showError('Authentication token not found.');
        return;
      }

      var url = Uri.parse("$baseapi/user/get_profile");//get profile to get data from BE
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      print("================body============\n"+(response.body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          fname = data['data']['fname'] ?? '';
          lname = data['data']['lname'] ?? '';
          aadhar_no = data['data']['aadhar_no'] ?? '';
          email = data['data']['email'] ?? '';
          gender = data['data']['gender'] ?? '';
          number = data['data']['number'] ?? '';
          dob = data['data']['dob'] ?? '';
          id = data['data']['id'].toString(); // Convert id to String
          isLoading = false;
        });

        // fname = data['profile']['fname'] ?? '';
        // lname = data['profile']['lname'] ?? '';
        // id = data['profile']['id'].toString(); // Convert id to String

      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to load profile: ${response.body}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('An error occurred: $e');
    }
  }

  // Show error messages
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  // Profile Picture and User Info Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(

                        children: [
                          const CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/limg.jpg'),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '$fname $lname',
                                  style: const TextStyle(fontSize: 15, color: Colors.red),
                                ),
                              ),

                              // const SizedBox(height: 1,),
                               Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Clinics Patient ID $id' , // Replace with API data
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Profile Details Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          // _buildProfileDetail(label: 'Patient ID', value: '$id', isEditable: false, hasCalendarIcon: false),
                          _buildProfileDetail(label: 'First Name', value: '$fname', isEditable: false, hasCalendarIcon: false,),
                          _buildProfileDetail(label: 'Last Name', value: '$lname', isEditable: false, hasCalendarIcon: false),
                          // _buildProfileDetail(label: 'Date of Birth', value: 'DOB', isEditable: true, hasCalendarIcon: true),
                          _buildProfileDetail(label: 'Gender', value: '$gender', isEditable: false, hasCalendarIcon: false, isDropdown: false),
                          _buildProfileDetail(label: 'Aadhaar Number', value: '$aadhar_no', isEditable: false, hasCalendarIcon: false),
                          _buildProfileDetail(label: 'Age', value: '$dob', isEditable: false, hasCalendarIcon: false),
                          _buildProfileDetail(label: 'Email', value: '$email', isEditable: false, hasCalendarIcon: false),
                          _buildProfileDetail(label: 'Mobile Number', value: '$number', isEditable: false, hasCalendarIcon: false),
                          // _buildProfileDetail(label: 'Address', value: 'Maharashtra', isEditable: false, hasCalendarIcon: false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            ListTile(
              title: const Text(
              'Change Password',
              style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
            ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.orangeAccent,
                size: 18,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              },

            ),

            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.orange,
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2559),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Are you sure you want to logout?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1B2559),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color(0xFF1B2559),
                                      backgroundColor: Colors.white,
                                      side: const BorderSide(color: Color(0xFF1B2559)),
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.orange,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () async {
                                      var box = await Hive.openBox('userBox');
                                      await box.delete('authToken');
                                      widget.onLogout();
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => const LoginScreen(),
                                        ),
                                            (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),




            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '© BharatTeleClinic, 2024 - All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.orange, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetail({
    required String label,
    required String value,
    bool isEditable = false,
    required bool hasCalendarIcon,
    bool isDropdown = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 8, color: Colors.grey),
          ),
          const SizedBox(height: 5.0),
          Container(

            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 5,
                  offset: const Offset(0, 3),

                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal:15),
            child: isDropdown
                ? DropdownButtonHideUnderline(

              child: DropdownButton<String>(
                value: value,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: isEditable ? (String? newValue) {} : null,
              ),
            )
                : TextField(
              controller: TextEditingController(text: value),
              enabled: isEditable,
              decoration: InputDecoration(
                suffixIcon: hasCalendarIcon
                    ? const Icon(Icons.calendar_today, color: Colors.orange)
                    : null,
                border: InputBorder.none,
              ),
              style: TextStyle(color: isEditable ? Colors.black : Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}


