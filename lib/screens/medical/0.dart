// Widget build(BuildContext context) {
//   final appointment = widget.appointment;
//
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: const Color(0xFF243B6D),
//       title: const Text(
//         'Appointment Details',
//         style: TextStyle(fontSize: 18, color: Colors.white),
//       ),
//       foregroundColor: Colors.white,
//     ),
//     body: SingleChildScrollView(
//       ////
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             // Appointment Details Card
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         // Doctor Image
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(10.0),
//                           child: Image.network(
//                             widget.appointment['image_url'] ?? "https://via.placeholder.com/50",
//                             height: 70.0,
//                             width: 70.0,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Dr. ${appointment['full_name'] ?? 'Unknown'}',
//                               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               specialties[appointment['speciality']] ?? 'N/A',
//                               style: TextStyle(fontSize: 9, color: Colors.grey[600]),
//                             ),
//                           ],
//                         ),
//                         const Spacer(),
//                         IconButton(
//                           onPressed: () {
//                             Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
//                           },
//                           icon: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.green,
//                             ),
//                             child: const Icon(Icons.video_call, color: Colors.white),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Divider(color: Colors.grey, thickness: 1, height: 20),
//                     ListTile(
//                       leading: const Icon(Icons.calendar_today, color: Colors.blue),
//                       title: const Text('Date & Time'),
//                       subtitle: Text('${appointment['date'] ?? 'N/A'} at ${appointment['start_time'] ?? 'N/A'}'),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.local_hospital, color: Colors.blue),
//                       title: const Text('Clinic Name'),
//                       subtitle: Text(appointment['clinic_name'] ?? 'N/A'),
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.tag, color: Colors.blue),
//                       title: const Text('Appointment ID'),
//                       subtitle: Text('${appointment['slot_id'] ?? 'N/A'}'),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Reschedule functionality
//                             },
//                             child: const Text('Reschedule', style: TextStyle(color: Colors.white)),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.indigo,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: ElevatedButton(
//                             onPressed: cancelAppointment,
//                             child: const Text('Cancel', style: TextStyle(color: Colors.white)),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             ///
//             const SizedBox(height: 20),
//             // Medical Records Card
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Medical Records",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => MedicalRecordsScreen()));
//                       },
//                       icon: const Icon(Icons.file_upload_outlined, size: 12),
//                       label: const Text("Upload", style: TextStyle(fontSize: 12)),
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             ///
//             const SizedBox(height: 20),
//             // Vitals Card
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//               child: Column(
//                 children: [
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.indigo,
//                       borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
//                     ),
//                     padding: const EdgeInsets.all(16.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Vitals',
//                           style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {},
//                           child: const Text('View History', style: TextStyle(color: Colors.white)),
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         _buildVitalsRow('Temperature', '°C'),
//                         _buildVitalsRow('Height', 'cm'),
//                         _buildVitalsRow('Weight', 'kg'),
//                         // Add more vitals as needed
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
