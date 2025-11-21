class MealInputModel {
  final int id;
  final String mealType;
  final String manualName;
  final double calories;
  final String time; // Tambahkan ini

  MealInputModel({
    required this.id,
    required this.mealType,
    required this.manualName,
    required this.calories,
    required this.time, // tambahkan ini juga di konstruktor
  });

  factory MealInputModel.fromJson(Map<String, dynamic> json) {
    return MealInputModel(
      id: json['id'],
      mealType: json['meal_type'],
      manualName: json['manual_name'],
      calories: (json['calories'] as num).toDouble(),
      time: json['time'], // tambahkan ini juga
    );
  }
}
