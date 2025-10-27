// m_diabetic_care/model/food.dart

class FoodModel {
  final int id;
  final String name;
  final String? brand; // Ini sudah benar (boleh null)
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

  /// Factory constructor yang lebih aman untuk parsing JSON
  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      // Asumsikan 'id' tidak akan pernah null. Jika bisa, tambahkan '?? 0'
      id: json['id'], 
      
      // Beri nilai default jika 'name' null
      name: json['name'] ?? 'Nama Makanan T/A', 
      
      // 'brand' sudah boleh null, jadi ini aman
      brand: json['brand'], 
      
      // Konversi aman untuk angka, beri default 0.0 jika null
      carbs: (json['carbs'] as num?)?.toDouble() ?? 0.0,
      sugar: (json['sugar'] as num?)?.toDouble() ?? 0.0,
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      protein: (json['protein'] as num?)?.toDouble() ?? 0.0,
      fat: (json['fat'] as num?)?.toDouble() ?? 0.0,
      
      // Beri nilai default jika 'category' null
      category: json['category'] ?? 'Lainnya', 
    );
  }
}