// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../APIServices/base_api.dart';

class EditProfileScreen extends StatefulWidget {
  final String fname, lname, email, aadhar_no, number, dob,blood_group, gender;

  const EditProfileScreen({
    Key? key,
    required this.fname,
    required this.lname,
    required this.email,
    required this.aadhar_no,
    required this.number,
    required this.dob,
    // required String gender,
    required this.blood_group,
    required this.gender,

  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController fnameController;
  late TextEditingController lnameController;
  late TextEditingController emailController;
  late TextEditingController aadharController;
  late TextEditingController numberController;
  late TextEditingController dobController;
  String? selectedBloodGroup;


  String? selectedGender;

  @override
  void initState() {
    super.initState();
    fnameController = TextEditingController(text: widget.fname);
    lnameController = TextEditingController(text: widget.lname);
    emailController = TextEditingController(text: widget.email);
    aadharController = TextEditingController(text: widget.aadhar_no);
    numberController = TextEditingController(text: widget.number);
    dobController = TextEditingController(text: widget.dob);

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

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    String? token = await getToken();
    if (token == null) {
      showError('Authentication token not found.');
      return;
    }

    try {
      var url = Uri.parse('$baseapi/user/update_profile');
      var response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'fname': fnameController.text,
          'lname': lnameController.text,
          'email': emailController.text,
          'aadhar_no': aadharController.text,
          'gender': selectedGender ?? '',
          'number': numberController.text,
          'dob': dobController.text,
          'blood_group': selectedBloodGroup ?? '',
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        showError('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      showError('An error occurred while updating profile: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    fnameController.dispose();
    lnameController.dispose();
    emailController.dispose();
    aadharController.dispose();
    numberController.dispose();
    dobController.dispose();
    super.dispose();
  }



  Widget _buildBloodGroupDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedBloodGroup,
        items: const [
          DropdownMenuItem(value: 'A+', child: Text('A+')),
          DropdownMenuItem(value: 'A-', child: Text('A-')),
          DropdownMenuItem(value: 'B+', child: Text('B+')),
          DropdownMenuItem(value: 'B-', child: Text('B-')),
          DropdownMenuItem(value: 'O+', child: Text('O+')),
          DropdownMenuItem(value: 'O-', child: Text('O-')),
          DropdownMenuItem(value: 'AB+', child: Text('AB+')),
          DropdownMenuItem(value: 'AB-', child: Text('AB-')),
        ],
        onChanged: (value) => setState(() => selectedBloodGroup = value),
        decoration: InputDecoration(
          labelText: 'Blood Group',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(  // To handle keyboard appearance on smaller screens
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(fnameController, 'First Name', (value) => value!.isEmpty ? 'First name is required' : null),
                    _buildTextField(lnameController, 'Last Name', (value) => value!.isEmpty ? 'Last name is required' : null),
                    _buildTextField(emailController, 'Email', (value) => value!.isEmpty ? 'Email is required' : null, keyboardType: TextInputType.emailAddress),
                    _buildTextField(aadharController, 'Aadhaar Number', _validateAadhar, keyboardType: TextInputType.number),
                    _buildTextField(numberController, 'Mobile Number',_validateMobile, keyboardType: TextInputType.number),
                    _buildTextField(dobController, 'Date of Birth', null, keyboardType: TextInputType.datetime),
                    _buildDropdown(),
                    _buildBloodGroupDropdown(),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: updateProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String? Function(String?)? validator, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Gray border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue), // Gray border when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Gray border when focused
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
        ],
        onChanged: (value) => setState(() => selectedGender = value),
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey), // Gray border
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blue), // Gray border when enabled
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green), // Gray border when focused
          ),
        ),
        // validator: validator,
        // keyboardType: keyboardType,
      ),
    );
  }
  String? _validateAadhar(String? value) {
    if (value == null || value.isEmpty) {
      return 'Aadhaar number is required';
    }
    if (value.length != 12) {
      return 'Aadhaar number must be 12 digits';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

}
