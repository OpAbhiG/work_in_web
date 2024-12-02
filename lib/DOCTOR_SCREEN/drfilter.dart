class Doctor {
  final int id;
  final String full_name;

  Doctor({required this.id, required this.full_name});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      full_name: json['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': full_name,
    };
  }
}

