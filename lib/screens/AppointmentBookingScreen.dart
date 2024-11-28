// import 'package:flutter/material.dart';
// import '../models/doctor.dart';
// import 'payment_screen.dart';
//
// class AppointmentBookingScreen extends StatefulWidget {
//   final Doctor doctor;
//
//   const AppointmentBookingScreen({Key? key, required this.doctor}) : super(key: key);
//
//   @override
//   _AppointmentBookingScreenState createState() => _AppointmentBookingScreenState();
// }
//
// class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Book Appointment'),
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Select Date and Time',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: DateTime.now(),
//                   firstDate: DateTime.now(),
//                   lastDate: DateTime.now().add(Duration(days: 365)),
//                 );
//                 if (picked != null && picked != selectedDate) {
//                   setState(() {
//                     selectedDate = picked;
//                   });
//                 }
//               },
//               child: Text(selectedDate != null
//                   ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
//                   : 'Select Date'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 final TimeOfDay? picked = await showTimePicker(
//                   context: context,
//                   initialTime: TimeOfDay.now(),
//                 );
//                 if (picked != null && picked != selectedTime) {
//                   setState(() {
//                     selectedTime = picked;
//                   });
//                 }
//               },
//               child: Text(selectedTime != null
//                   ? selectedTime!.format(context)
//                   : 'Select Time'),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: (selectedDate != null && selectedTime != null)
//                   ? () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => PaymentScreen(
//                     doctor: widget.doctor,
//                     date: selectedDate!,
//                     time: selectedTime!,
//                   ),
//                 ),
//               )
//                   : null,
//               child: Text('Confirm Date and Time'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }