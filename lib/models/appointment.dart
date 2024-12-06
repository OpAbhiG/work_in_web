

class Appointment {
  final String fullName;
  final DateTime date;
  // final String imagePath;

  Appointment({
    required this.fullName,
    required this.date,
  });
}




// class Appointment {
//   final String clinicName;
//   final String fullName;
//   final String date;
//   final String startTime;
//   final int doctorId;
//   final int slotId;
//   final int? speciality;
//
//   Appointment({
//     required this.clinicName,
//     required this.fullName,
//     required this.date,
//     required this.startTime,
//     required this.doctorId,
//     required this.slotId,
//     this.speciality,
//   });
//
//   factory Appointment.fromJson(Map<String, dynamic> json) {
//     return Appointment(
//       clinicName: json['clinic_name'] ?? '',
//       fullName: json['full_name'],
//       date: json['date'],
//       startTime: json['start_time'],
//       doctorId: json['doctor_id'],
//       slotId: json['slot_id'],
//       speciality: json['speciality'],
//     );
//   }
// }

