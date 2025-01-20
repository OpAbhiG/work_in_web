import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../APIServices/base_api.dart';

class EditProfileScreen extends StatefulWidget {
  final String fname, lname, email, aadhar_no, number, dob, blood_group, gender;
  final String? profileImage;

  const EditProfileScreen({
    Key? key,
    required this.fname,
    required this.lname,
    required this.email,
    required this.aadhar_no,
    required this.number,
    required this.dob,
    required this.blood_group,
    required this.gender,
    this.profileImage,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController fnameController;
  late TextEditingController lnameController;
  late TextEditingController emailController;
  late TextEditingController aadharController;
  late TextEditingController numberController;
  late TextEditingController dobController;
  String? selectedBloodGroup;
  String? selectedGender;
  File? _profileImage;
  String? _networkImageUrl;

  @override
  void initState() {
    super.initState();
    fnameController = TextEditingController(text: widget.fname);
    lnameController = TextEditingController(text: widget.lname);
    emailController = TextEditingController(text: widget.email);
    aadharController = TextEditingController(text: widget.aadhar_no);
    numberController = TextEditingController(text: widget.number);
    dobController = TextEditingController(text: widget.dob);
    selectedGender = widget.gender;
    selectedBloodGroup = widget.blood_group;
    _networkImageUrl = widget.profileImage;
  }



  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
          _networkImageUrl = null; // Clear network image when new image is picked
        });
      }
    } catch (e) {
      showError('Error picking image: $e');
    }
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

    setState(() => _isLoading = true);

    try {
      String? token = await getToken();
      if (token == null) {
        showError('Authentication token not found.');
        return;
      }

      var url = Uri.parse('$baseapi/user/update_profile');
      var request = http.MultipartRequest('POST', url);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Add text fields
      request.fields.addAll({
        'fname': fnameController.text,
        'lname': lnameController.text,
        'email': emailController.text,
        'aadhar_no': aadharController.text,
        'gender': selectedGender ?? '',
        'number': numberController.text,
        'dob': dobController.text,
        'blood_group': selectedBloodGroup ?? '',
      });

      // Add image file if selected
      if (_profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            _profileImage!.path,
            filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        //done Profile updated successfully!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Profile updated successfully!',
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
        Navigator.pop(context, true);
      } else {
        showError('Failed to update profile: ${response.body}');
      }
    } catch (e) {
      showError('An error occurred while updating profile: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

// For both Web and Mobile platforms (dart:html for Web, dart:io for Mobile)

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
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _pickImage,
      child: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              backgroundImage: _getProfileImage(),
              child: _getProfileImage() == null
                  ? const Icon(Icons.person, color: Colors.white, size: 50)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_profileImage != null) {
      return FileImage(_profileImage!);
    } else if (_networkImageUrl != null && _networkImageUrl!.isNotEmpty) {
      return NetworkImage(_networkImageUrl!);
    }
    return null;
  }

  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedGender,
        items: const [
          DropdownMenuItem(value: 'Male', child: Text('Male')),
          DropdownMenuItem(value: 'Female', child: Text('Female')),
          DropdownMenuItem(value: 'Other', child: Text('Other')),
        ],
        onChanged: (value) => setState(() => selectedGender = value),
        decoration: InputDecoration(
          labelText: 'Gender',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green),
          ),
        ),
        validator: (value) => value == null ? 'Please select gender' : null,
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      String? Function(String?)? validator, {
        TextInputType keyboardType = TextInputType.text,
        bool readOnly = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green),
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readOnly,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF243B6D),
          foregroundColor: Colors.white,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileImage(),
                        const SizedBox(height: 20),
                        _buildTextField(
                          fnameController,
                          'First Name',
                              (value) =>
                          value?.isEmpty ?? true ? 'First name is required' : null,
                        ),
                        _buildTextField(
                          lnameController,
                          'Last Name',
                              (value) =>
                          value?.isEmpty ?? true ? 'Last name is required' : null,
                        ),
                        _buildTextField(
                          emailController,
                          'Email',
                              (value) => value?.isEmpty ?? true
                              ? 'Email is required'
                              : !value!.contains('@')
                              ? 'Invalid email format'
                              : null,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _buildTextField(
                          aadharController,
                          'Aadhaar Number',
                              (value) => value?.isEmpty ?? true
                              ? 'Aadhaar number is required'
                              : value!.length != 12
                              ? 'Aadhaar number must be 12 digits'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                        _buildTextField(
                          numberController,
                          'Mobile Number',
                              (value) => value?.isEmpty ?? true
                              ? 'Mobile number is required'
                              : value!.length != 10
                              ? 'Mobile number must be 10 digits'
                              : null,
                          keyboardType: TextInputType.number,
                        ),
                        _buildTextField(
                          dobController,
                          'Date of Birth',
                              (value) =>
                          value?.isEmpty ?? true ? 'Date of birth is required' : null,
                          readOnly: true,
                        ),
                        _buildGenderDropdown(),
                        _buildBloodGroupDropdown(),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : updateProfile,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: const Color(0xFF243B6D),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
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
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}