// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:food_app/common/errors/failure.dart';
import 'package:food_app/features/menu_items/domain/repository/meal.repository.dart';

class DeleteProductUseCase {
  MealRepository repository;
  DeleteProductUseCase({
    required this.repository,
  });
  Future<Either<Failure, void>> call(int id) async {
    return await repository.removeMeal(id);
  }
}
