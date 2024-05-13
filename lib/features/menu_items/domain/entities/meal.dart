class Meal {
  final int? mealId;
  final int? imageId;
  final String mealName;
  final double mealPrice;
  final int preparationTime;
  final Cuisine cuisine;
  final String category;
  bool isCarted;
  int qnt;

  Meal({
    this.mealId,
    this.imageId,
    required this.mealName,
    required this.mealPrice,
    required this.preparationTime,
    required this.cuisine,
    required this.category,
    this.isCarted = false,
    this.qnt = 0,
  });
}

enum Cuisine { talian, chinese, mexican }

enum Category { breakfast, fastfood, icereams }
