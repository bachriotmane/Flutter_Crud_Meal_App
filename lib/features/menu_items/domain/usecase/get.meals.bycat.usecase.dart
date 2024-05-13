// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:food_app/common/errors/failure.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/repository/meal.repository.dart';

class GetMealsByCategoryUseCase {
  MealRepository repository;
  GetMealsByCategoryUseCase({
    required this.repository,
  });
  Future<Either<Failure, List<Meal>>> call(String category) async {
    return await repository.getMealByCategory(category);
  }
}
