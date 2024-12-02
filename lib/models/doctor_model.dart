// class Doctor {
//   final String fullName;
//   final String about;
//   final String email;
//   final int experience;
//   final int id;
//   final bool isApproved;
//   final bool isVerified;
//   final String qualification;
//   final int speciality;
//   final int userType;
//
//   Doctor({
//     required this.fullName,
//     required this.about,
//     required this.email,
//     required this.experience,
//     required this.id,
//     required this.isApproved,
//     required this.isVerified,
//     required this.qualification,
//     required this.speciality,
//     required this.userType,
//   });
//
//   // Factory method to create a Doctor object from JSON
//   factory Doctor.fromJson(Map<String, dynamic> json) {
//     return Doctor(
//       fullName: json['full_name'] ?? '',
//       about: json['about'] ?? '',
//       email: json['email'] ?? '',
//       experience: json['experience'] ?? 0,
//       id: json['id'] ?? 0,
//       isApproved: json['is_approved'] ?? false,
//       isVerified: json['is_verified'] ?? false,
//       qualification: json['qualification'] ?? '',
//       speciality: json['speciality'] ?? 0,
//       userType: json['user_type'] ?? 0,
//     );
//   }
// }
