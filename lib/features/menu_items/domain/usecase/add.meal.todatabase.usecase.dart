import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/repository/meal.repository.dart';

class AddMealToDataBaseUseCase {
  final MealRepository repository;

  AddMealToDataBaseUseCase({required this.repository});
  call(Meal meal, Photo image) {
    repository.addNewMealToDatabase(meal, image);
  }
}
