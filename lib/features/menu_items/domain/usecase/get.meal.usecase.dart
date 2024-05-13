import 'package:dartz/dartz.dart';
import 'package:food_app/common/errors/failure.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/repository/meal.repository.dart';

class GetMealsUseCase {
  final MealRepository repo;

  GetMealsUseCase({required this.repo});
  Future<Either<Failure, List<Meal>>> call() async {
    return await repo.getAllMeals();
  }
}
