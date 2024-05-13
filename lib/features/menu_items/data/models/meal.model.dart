import 'package:food_app/common/configuration/sqflie.config.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';

class MealModel extends Meal {
  MealModel({
    super.imageId,
    super.mealId,
    required super.mealName,
    required super.mealPrice,
    required super.preparationTime,
    required super.cuisine,
    required super.category,
    super.isCarted,
  });

  Map<String, dynamic> toJSON() => {
        MealsFileds.mealId: mealId,
        MealsFileds.mealName: mealName,
        MealsFileds.mealPrice: mealPrice,
        MealsFileds.preparationTime: preparationTime,
        MealsFileds.category: category,
        MealsFileds.cuisine: cuisine.toString(),
        MealsFileds.imageId: imageId,
        MealsFileds.isCarted: isCarted ? 1 : 0
      };
  factory MealModel.fromJSON(Map<String, dynamic> json) => MealModel(
        mealId: json[MealsFileds.mealId],
        mealName: json[MealsFileds.mealName],
        mealPrice: double.parse(json[MealsFileds.mealPrice]),
        preparationTime: json[MealsFileds.preparationTime],
        cuisine: Cuisine.chinese,
        category: json[MealsFileds.category],
        imageId: json[MealsFileds.imageId],
        isCarted: json[MealsFileds.isCarted] == 1 ? true : false,
      );
}
