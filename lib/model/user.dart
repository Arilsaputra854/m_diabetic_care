class UserModel {
  final int id;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String birthDate; // Tetap simpan string ISO
  final String role;
  final String gender;
  final String familyHistory;
  final int? height;
  final int? weight;
  final double? bmi;
  final String? diabetesType;
  final double? glucoseLevel;
  final String createdAt;
  final String? glucoseLevelUpdatedAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.birthDate,
    required this.role,
    required this.gender,
    required this.familyHistory,
    this.height,
    this.weight,
    this.bmi,
    this.diabetesType,
    this.glucoseLevel,
    this.glucoseLevelUpdatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      birthDate: json['birth_date'],
      role: json['role'],
      gender: json['gender'],
      familyHistory: json['family_history'],
      height: json['height'],
      weight: json['weight'],
      bmi: (json['bmi'] as num?)?.toDouble(),
      diabetesType: json['diabetes_type'],
      glucoseLevel: (json['glucose_level'] as num?)?.toDouble(),
      glucoseLevelUpdatedAt: json['glucose_level_updated_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // Getter untuk menghitung umur
  int? get age {
    try {
      final birth = DateTime.parse(birthDate);
      final now = DateTime.now();
      int years = now.year - birth.year;
      if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
        years--;
      }
      return years;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
  return {
    'id': id,
    'fullname': fullname,
    'email': email,
    'phone_number': phoneNumber,
    'birth_date': birthDate,
    'role': role,
    'gender': gender,
    'family_history': familyHistory,
    'height': height,
    'weight': weight,
    'bmi': bmi,
    'diabetes_type': diabetesType,
    'glucose_level': glucoseLevel,
    'glucose_level_updated_at' : glucoseLevelUpdatedAt,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

}
