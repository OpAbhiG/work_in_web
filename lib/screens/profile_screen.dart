import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../APIServices/base_api.dart';
import 'change_password.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  final VoidCallback onLogout;
  const Profile({super.key, required this.onLogout});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String fname = '',lname = '', aadhar_no='', blood_group = '', email='', gender='', number='', dob='', id='';
  bool isLoading = true;
  String? profileImage;

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

      // print("================body============\n"+(response.body));

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
          blood_group=data['data']['blood_group']?? '';
          profileImg = data['data']['profile_img'] ?? ''; // Fetch the profile image URL

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
  String profileImg = ''; // To hold the profile image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,

        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF243B6D),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Fixed Profile Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    // ClipRRect(
                    //   borderRadius: BorderRadius.circular(10.0),
                    //   child: CachedNetworkImage(
                    //     // imageUrl: profileImg ?? 'https://via.placeholder.com/150', // Replace with the actual image URL
                    //     // imageUrl: profileImg,
                    //     imageUrl: profileImg.isEmpty ? 'https://via.placeholder.com/150' : profileImg,
                    //
                    //     fit: BoxFit.cover,
                    //     width: 70, // Adjust size as needed
                    //     height: 70, // Adjust size as needed
                    //     placeholder: (context, url) => Center(
                    //       child: CircularProgressIndicator(),
                    //     ),
                    //     errorWidget: (context, url, error) {
                    //       return Container(
                    //         width: 70,
                    //         height: 70,
                    //         decoration: BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: Colors.grey[300],
                    //         ),
                    //         alignment: Alignment.center,
                    //         child: Icon(
                    //           Icons.person,
                    //           color: Colors.grey,
                    //         ),
                    //       );
                    //     },
                    //     // imageUrl: '',
                    //   ),
                    // ),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: profileImg.replaceFirst('https://', 'http://'),// Convert HTTPS to HTTP if needed
                          fit: BoxFit.cover,
                          width: 70,
                          height: 70,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) {
                            if (kDebugMode) {
                              print('Error loading profile image: $error');
                            }
                            return Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[300],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              fname: fname,
                              lname: lname,
                              email: email,
                              aadhar_no: aadhar_no,
                              number: number,
                              dob: dob,
                              gender: gender,
                              blood_group: blood_group,
                              profileImage: profileImage,
                            ),
                          ),
                        );
                        if (result == true) {
                          fetchProfile(); // Refresh profile data
                        }
                      },
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFF243B6D),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$fname $lname',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243B6D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Clinics Patient ID $id',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Scrollable Section
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title
                    Text(
                      'Personal Information',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF243B6D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Information Cards
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.drive_file_rename_outline, color:Color(0xFF243B6D),),
                        title: Text(
                          'First Name',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '$fname',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Information Cards
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.drive_file_rename_outline, color: Color(0xFF243B6D),),
                        title: Text(
                          'Last Name',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '$lname',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Information Cards
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.email, color: Color(0xFF243B6D),),
                        title: Text(
                          'Email ID',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '$email',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.phone, color: Color(0xFF243B6D),),
                        title: Text(
                          'Phone',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '$number',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Color(0xFF243B6D),),
                        title: Text(
                          'Adhar Card',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '$aadhar_no',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),

                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: const Icon(Icons.bloodtype, color: Color(0xFF243B6D),),
                          title: Text(
                            'Blood Group',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '$blood_group',
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Age
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: const Icon(Icons.cake, color: Color(0xFF243B6D),),
                              title: Text(
                                'Age',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '$dob',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Gender
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: const Icon(Icons.male, color: Color(0xFF243B6D),),
                              title: Text(
                                'Gender',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '$gender',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Age
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 4,
                            child: ListTile(
                              leading: const Icon(Icons.location_city, color: Color(0xFF243B6D),),
                              title: Text(
                                'City',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Solapur',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 10),
                        // Gender
                        // Expanded(
                        //   child:
                        // ),
                      ],
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.location_city, color: Color(0xFF243B6D),),
                        title: Text(
                          'State',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Maharashtra',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.location_on, color: Color(0xFF243B6D),),
                        title: Text(
                          'Location',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Mumbai, India',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.family_restroom, color: Color(0xFF243B6D),),
                        title: Text(
                          'Family Members',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            // Add Family Member logic
                          },
                          tooltip: 'Add Family Member',

                        ),
                        subtitle: Text(
                          'no member added',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),
                    // Change Password Option
                    ListTile(
                      // tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.orangeAccent,
                        size: 18,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    // Logout Button
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
                                        icon: const Icon(Icons.cancel),
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.orange,
                                      ),
                                      child: const Icon(
                                        Icons.logout_rounded,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Are you sure you want to logout?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.grey[300],
                                              foregroundColor: Colors.black,
                                            ),
                                            child: const Text('Cancel'),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              var box =
                                              await Hive.openBox('userBox');
                                              await box.delete('authToken');
                                              widget.onLogout();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Container(
                                                    alignment: Alignment.center,
                                                    height: 12, // Adjust height if needed
                                                    child: Center(
                                                      child: Text(
                                                        'Logout successfully',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  // backgroundColor: Colors.black.withOpacity(0.7), // Transparent black
                                                  backgroundColor: Color(0xFF40BF78), // Background color
                                                  behavior: SnackBarBehavior.floating, // Floating SnackBar
                                                  margin: EdgeInsets.symmetric(horizontal: 120, vertical: 10), // Adjust padding
                                                  elevation: 0, // Remove shadow
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5), // Rounded corners
                                                  ),
                                                  duration: Duration(seconds: 2), // Visible for 2 seconds
                                                ),
                                              );
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()),);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF243B6D),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Logout'),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),


            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                '© BharatTeleClinic, 2025 - All Rights Reserved.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF243B6D), fontSize: 10),
              ),
            ),
          ),
        ],
      ),

    );

  }


  // Widget _buildProfileDetail({
  //   required String label,
  //   required String value,
  //   bool isEditable = false,
  //   required bool hasCalendarIcon,
  //   bool isDropdown = false,
  // }) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 5.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           label,
  //           style: const TextStyle(fontSize: 10, color: Colors.grey),
  //         ),
  //         const SizedBox(height: 5.0),
  //         Container(
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey),  // Add a gray border
  //             // color: Colors.grey[100],
  //             borderRadius: BorderRadius.circular(10),
  //             boxShadow: [
  //               // BoxShadow(
  //               //   color: Colors.grey.withOpacity(0.2),
  //               //   blurRadius: 5,
  //               //   offset: const Offset(0, 3),
  //               // ),
  //             ],
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal:15),
  //           child: isDropdown
  //               ? DropdownButtonHideUnderline(
  //             child: DropdownButton<String>(
  //               value: value,
  //               items: const [
  //                 DropdownMenuItem(value: 'Male', child: Text('Male')),
  //                 DropdownMenuItem(value: 'Female', child: Text('Female')),
  //               ],
  //               onChanged: isEditable ? (String? newValue) {} : null,
  //             ),
  //           )
  //               : TextField(
  //             controller: TextEditingController(text: value),
  //             enabled: isEditable,
  //             decoration: InputDecoration(
  //               suffixIcon: hasCalendarIcon
  //                   ? const Icon(Icons.calendar_today, color: Colors.orange)
  //                   : null,
  //               border: InputBorder.none,
  //             ),
  //             style: TextStyle(color: isEditable ? Colors.grey[800] : Colors.grey[600]),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}


