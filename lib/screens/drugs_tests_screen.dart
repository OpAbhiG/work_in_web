import 'package:flutter/material.dart';

class DrugsTestsScreen extends StatelessWidget {
  const DrugsTestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drugs & Tests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

          ),
          backgroundColor: const Color(0xFF1A237E),
          foregroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.receipt_long), text: 'My ePrescription'),
              Tab(icon: Icon(Icons.science), text: 'Lab Test'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.orange,

          ),
        ),
        body: TabBarView(
          children: [
            _buildDrugsTab(),
            _buildTestsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrugsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDrugCard(
          date: '15 Mar 2024',
          drugName: 'Paracetamol',
          dosage: '500mg',
          frequency: 'Twice daily',
          duration: '5 days',
          doctor: 'Dr. Shaikh',
        ),
        _buildDrugCard(
          date: '15 Mar 2024',
          drugName: 'Azithromycin',
          dosage: '250mg',
          frequency: 'Once daily',
          duration: '3 days',
          doctor: 'Dr. Shaikh',
        ),
      ],
    );
  }

  Widget _buildTestsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTestCard(
          date: '10 Mar 2024',
          testName: 'Complete Blood Count',
          status: 'Completed',
          doctor: 'Dr. Sutar',
          result: 'Normal',
        ),
        _buildTestCard(
          date: '10 Mar 2024',
          testName: 'Blood Sugar Fasting',
          status: 'Pending',
          doctor: 'Dr. Sutar',
          result: null,
        ),
      ],
    );
  }

  Widget _buildDrugCard({
    required String date,
    required String drugName,
    required String dosage,
    required String frequency,
    required String duration,
    required String doctor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              drugName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildDrugInfo('Dosage', dosage),
            _buildDrugInfo('Frequency', frequency),
            _buildDrugInfo('Duration', duration),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Prescribed by: $doctor',
                  style: const TextStyle(
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Implement view details logic
                  },
                  child: const Text(
                    'View Details',

                    style: TextStyle(color: Colors.orange,fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard({
    required String date,
    required String testName,
    required String status,
    required String doctor,
    String? result,
  }

  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status == 'Completed'
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: status == 'Completed' ? Colors.green : Colors.orange,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              testName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (result != null) _buildDrugInfo('Result', result),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended by: $doctor',
                  style: const TextStyle(
                    color: Color(0xFF1A237E),
                    fontWeight: FontWeight.w500,
                    fontSize: 13
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Implement view details logic
                  },
                  child: const Text(
                    'View Details',
                    style: TextStyle(color: Colors.orange,fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrugInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}