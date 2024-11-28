import 'package:flutter/material.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical History',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHistoryTimeline(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTimeline() {
    return Column(
      children: [
        _buildTimelineItem(
          date: 'March 2024',
          items: [
            TimelineRecord(
              day: '15',
              title: 'Fever and Cold',
              description: 'Prescribed antibiotics and rest',
              doctor: 'Dr. Shaikh',
            ),
            TimelineRecord(
              day: '10',
              title: 'Follow-up Checkup',
              description: 'Recovery progress satisfactory',
              doctor: 'Dr. Sutar',
            ),
          ],
        ),
        _buildTimelineItem(
          date: 'February 2024',
          items: [
            TimelineRecord(
              day: '25',
              title: 'Routine Health Checkup',
              description: 'All parameters normal',
              doctor: 'Dr. Shaikh',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required String date,
    required List<TimelineRecord> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            date,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A237E),
            ),
          ),
        ),
        ...items.map((item) => _buildHistoryCard(item)).toList(),
      ],
    );
  }

  Widget _buildHistoryCard(TimelineRecord record) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  record.day,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    record.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        record.doctor,
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
                          'View Detail',
                          style: TextStyle(color: Colors.orange,fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimelineRecord {
  final String day;
  final String title;
  final String description;
  final String doctor;

  TimelineRecord({
    required this.day,
    required this.title,
    required this.description,
    required this.doctor,
  });
}