import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../APIServices/base_api.dart';

class EditProfileScreen extends StatefulWidget {
  final String fname, lname, email, aadhar_no, number, dob;

  const EditProfileScreen({
    Key? key,
    required this.fname,
    required this.lname,
    required this.email,
    required this.aadhar_no,
    required this.number,
    required this.dob,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: fnameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value!.isEmpty ? 'First name is required' : null,
              ),
              TextFormField(
                controller: lnameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value!.isEmpty ? 'Last name is required' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                controller: aadharController,
                decoration: const InputDecoration(labelText: 'Aadhaar Number'),
              ),
              TextFormField(
                controller: numberController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                keyboardType: TextInputType.datetime,
              ),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) => setState(() => selectedGender = value),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
