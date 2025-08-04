class FoodModel {
  final int id;
  final String name;
  final String? brand;
  final double carbs;
  final double sugar;
  final double calories;
  final double protein;
  final double fat;
  final String category;

  FoodModel({
    required this.id,
    required this.name,
    this.brand,
    required this.carbs,
    required this.sugar,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.category,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      carbs: (json['carbs'] as num).toDouble(),
      sugar: (json['sugar'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      category: json['category'],
    );
  }
}
