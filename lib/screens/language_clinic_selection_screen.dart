import 'package:flutter/material.dart';
import 'login_screen.dart';

class LanguageClinicSelectionScreen extends StatefulWidget {
  const LanguageClinicSelectionScreen({super.key});

  @override
  _LanguageClinicSelectionScreenState createState() {
    return _LanguageClinicSelectionScreenState();
  }
}

class _LanguageClinicSelectionScreenState extends State<LanguageClinicSelectionScreen> {
  String? selectedLanguage;
  String? selectedClinic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.indigo, // Set the AppBar background color to indigo
      //   title: const Text(
      //     'Welcome to Bharat Tele ClinicApp',
      //     style: TextStyle(color: Colors.white,fontSize: 10), // Set the text color to white
      //   ),
      // ),

      body: Stack(

        children: [
          Container(

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bkimg.jpg'), // Path to your background image 1st page
                fit: BoxFit.cover,
                // Cover the entire screen
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(

                    padding: const EdgeInsets.only(top: 160), // Adjust the top padding as needed
                    child: SizedBox(
                      height: 60, // Adjust height as needed
                      // width: 60, // Adjust width as needed

                      child: Image.asset(
                        'assets/btclogo.png',// logo 1st
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),





                  const SizedBox(height: 40),//Container adjusting point
                  // Blue container around the dropdowns and button
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildDropdownWithIcon(

                          'Language',
                          Icons.language,

                          ['English', 'Hindi (हिन्दी)', 'Bengali (বাংলা)', 'Marathi (मराठी)', 'Telugu (తెలుగు)', 'Tamil (தமிழ்)'],
                          selectedLanguage,
                              (String? newValue) {
                            setState(() {
                              selectedLanguage = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildDropdownWithIcon(

                          'Clinic',Icons.home,// Icon for clinic
                          ['GTM4Health', 'Prakash Clinic', 'Sehat +', 'Mister Hair Clinic', 'Bharat TeleClinic', 'Krishnabhi Health Point'],
                          selectedClinic,
                              (String? newValue) {
                            setState(() {
                              selectedClinic = newValue;
                            });
                          },
                        ),





                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '© BharatTeleClinic, 2024 - All Rights Reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    );
  }

  // _buildDropdownWithIcon method where icon will stay visible
  Widget _buildDropdownWithIcon(String label, IconData icon, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          // Always show the icon, whether an item is selected or not
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((String value) {
              return Row(
                children: [
                  Icon(icon, color: Colors.blue), // Keep the icon after selection
                  const SizedBox(width: 8),
                  Text(value, style: const TextStyle(color: Colors.black)),
                ],
              );
            }).toList();
          },
          hint: Row(
            children: [
              Icon(icon, color: Colors.blue), // Icon for the label
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, color: Colors.blue), // Icon for each dropdown item
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
