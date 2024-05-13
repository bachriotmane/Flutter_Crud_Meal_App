import 'package:dartz/dartz.dart';
import 'package:food_app/common/errors/failure.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/repository/meal.repository.dart';

import '../entities/meal.dart';

class MealUpdateUseCase {
  MealRepository repository;
  MealUpdateUseCase({
    required this.repository,
  });
  Future<Either<Failure, void>> execute(Meal meal, Photo image) async {
    return await repository.updateMeal(meal, image);
  }
}
