import 'package:flutter/material.dart';


class PatientHealthDataScreen extends StatelessWidget {
  // Mock method to simulate API data fetching. Replace it with actual API logic.
  Future<List<HistoryData>> fetchHistoryData() async {
    await Future.delayed(const Duration(seconds: 2));  // Simulating network delay
    // Replace this with actual API call and parsing logic
    return [
      HistoryData(
        date: '04 Jan 2025 - 11:32 AM',
        allergy: 'None',
        disease: 'No Diseases',
        medication: 'Migraine',
        otherConditions: 'None',
      ),
      HistoryData(
        date: '17 Dec 2024 - 4:52 PM',
        allergy: 'None',
        disease: 'No Diseases',
        medication: 'Migraine',
        otherConditions: 'None',
      ),
      HistoryData(
        date: '17 Dec 2024 - 4:55 PM',
        allergy: 'None',
        disease: 'No Diseases',
        medication: 'Migraine',
        otherConditions: 'None',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Patient Health Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF243B6D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            color: const Color(0xFF243B6D),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/profile.jpg'), // Placeholder image
                  radius: 30,
                ),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Patient Name', // Replace with dynamic data
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Clinic's Patient ID : -", // Replace with dynamic Patient ID
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Aligns the button to the right
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MedicalHistoryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  child: const Text(
                    'Edit History',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // History Section - FutureBuilder to handle API data
          Expanded(
            child: FutureBuilder<List<HistoryData>>(
              future: fetchHistoryData(), // Call the method that fetches data
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No history available.'));
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final history = snapshot.data![index];
                      return HistoryCard(
                        date: history.date,
                        allergy: history.allergy,
                        disease: history.disease,
                        medication: history.medication,
                        otherConditions: history.otherConditions,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String date;
  final String allergy;
  final String disease;
  final String medication;
  final String otherConditions;

  const HistoryCard({
    required this.date,
    required this.allergy,
    required this.disease,
    required this.medication,
    required this.otherConditions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8.0),
            Text('Allergy: $allergy'),
            Text('Existing Disease (If Any): $disease'),
            Text('Current Medication: $medication'),
            Text('Other Conditions You Like To Specify: $otherConditions'),
          ],
        ),
      ),
    );
  }
}

class MedicalHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Medical History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF243B6D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form fields ready for API integration
            const MedicalInputField(label: 'Any Allergy', initialValue: ''),
            const MedicalInputField(label: 'Existing Disease (If Any)', initialValue: ''),
            const MedicalInputField(label: 'Current Medication', initialValue: ''),
            const MedicalInputField(label: 'Other Conditions You Like To Specify', initialValue: ''),

            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Save data functionality after API integration
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicalInputField extends StatelessWidget {
  final String label;
  final String initialValue;

  const MedicalInputField({
    required this.label,
    required this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF243B6D),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: TextEditingController(text: initialValue),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryData {
  final String date;
  final String allergy;
  final String disease;
  final String medication;
  final String otherConditions;

  HistoryData({
    required this.date,
    required this.allergy,
    required this.disease,
    required this.medication,
    required this.otherConditions,
  });

// You can add a method to parse data from API response here
}

