// import 'package:flutter/material.dart';
//
// class MedicalRecordScreen extends StatelessWidget {
//   const MedicalRecordScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Medical Record'),
//         backgroundColor: const Color(0xFF1A237E),
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildPatientInfo(),
//             const SizedBox(height: 20),
//             _buildRecordsList(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPatientInfo() {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Patient Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildInfoRow('Name', 'Abhishek Gholap'),
//             _buildInfoRow('Age', '23 Years'),
//             _buildInfoRow('Blood Group', '-'),
//             _buildInfoRow('Weight', '-'),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Text(
//             '$label: ',
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.grey,
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecordsList() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Medical Records',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 16),
//         _buildRecordCard(
//           date: '15 Mar 2024',
//           title: 'General Checkup',
//           doctor: 'Dr. Shaikh',
//           type: 'Consultation',
//         ),
//         _buildRecordCard(
//           date: '10 Mar 2024',
//           title: 'Blood Test Report',
//           doctor: 'Dr. Sutar',
//           type: 'Laboratory',
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRecordCard({
//     required String date,
//     required String title,
//     required String doctor,
//     required String type,
//   }) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   date,
//                   style: const TextStyle(
//                     color: Colors.grey,
//                     fontSize: 14,
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: Colors.orange.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     type,
//                     style: const TextStyle(
//                       color: Colors.orange,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(doctor),
//               TextButton(
//                 onPressed: () {
//                   // Implement view details logic
//                 },
//                 child: const Text(
//                   'View Details',
//                   style: TextStyle(color: Colors.orange,fontSize: 14),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//
// }