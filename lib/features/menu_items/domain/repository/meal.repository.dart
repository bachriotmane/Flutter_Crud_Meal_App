import 'package:dartz/dartz.dart';
import 'package:food_app/common/errors/failure.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';

abstract class MealRepository {
  Future<Either<Failure, int>> addNewMealToDatabase(Meal meal, Photo image);
  Future<Either<Failure, Meal>> getMealById(int id);
  Future<Either<Failure, void>> removeMeal(int id);
  Future<Either<Failure, void>> updateMeal(Meal meal, Photo image);

  Future<Either<Failure, List<Meal>>> getAllMeals();
  Future<Either<Failure, List<Meal>>> getMealByKeyWord(String keyword);
  Future<Either<Failure, List<Meal>>> getMealByCategory(String category);
}
