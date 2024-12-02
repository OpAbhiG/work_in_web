// class Doctor {
//   final int id;
//   final String name;
//   final String about;
//   final String email;
//   final int experience;
//   final String qualification;
//   final String specialty;
//   final bool isApproved;
//   final bool isVerified;
//
//   Doctor({
//     required this.id,
//     required this.name,
//     required this.about,
//     required this.email,
//     required this.experience,
//     required this.qualification,
//     required this.specialty,
//     required this.isApproved,
//     required this.isVerified,
//   });
//
//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       id: json['id'],
//       name: json['full_name'],
//       about: json['about'],
//       email: json['email'],
//       experience: json['experience'],
//       qualification: json['qualification'],
//       specialty: json['speciality'].toString(),
//       isApproved: json['is_approved'],
//       isVerified: json['is_verified'],
//     );
//   }
//
//
// }
