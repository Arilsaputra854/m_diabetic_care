class UserModel {
  final int id;
  final String fullname;
  final String email;
  final String phoneNumber;
  final int age;
  final String birthDate;
  final String role;
  final String gender;
  final String familyHistory;
  final int height;
  final int weight;
  final double? bmi;
  final String? diabetesType;
  final double? glucoseLevel;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.age,
    required this.birthDate,
    required this.role,
    required this.gender,
    required this.familyHistory,
    required this.height,
    required this.weight,
    this.bmi,
    this.diabetesType,
    this.glucoseLevel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullname: json['fullname'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      age: json['age'],
      birthDate: json['birth_date'],
      role: json['role'],
      gender: json['gender'],
      familyHistory: json['family_history'],
      height: json['height'],
      weight: json['weight'],
      bmi: (json['bmi'] as num?)?.toDouble(),
      diabetesType: json['diabetes_type'],
      glucoseLevel: (json['glucose_level'] as num?)?.toDouble(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'phone_number': phoneNumber,
      'age': age,
      'birth_date': birthDate,
      'role': role,
      'gender': gender,
      'family_history': familyHistory,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'diabetes_type': diabetesType,
      'glucose_level': glucoseLevel,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
