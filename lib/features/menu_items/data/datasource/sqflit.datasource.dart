import 'package:food_app/features/menu_items/data/models/image.model.dart';
import 'package:food_app/features/menu_items/data/models/meal.model.dart';
import 'package:food_app/features/menu_items/data/models/order.model.dart';

abstract class SQFlieDataSource {
  Future<MealModel> getMealById(int id);
  Future<int> addMeal(MealModel meal);
  Future<List<MealModel>> getAllMeals();
  Future<List<MealModel>> getMealByKeyword(String keyword);
  Future<void> deleteMeal(int id);
  Future<void> makeOrder(OrderModel order);
  Future<int> saveImageToDataBase(ImageModel image);
  Future<ImageModel> getAllImages();
  Future<ImageModel> getImageById(int id);
  Future<List<ImageModel>> getPhotos();
  Future<List<MealModel>> getMealsByName(String name);
  Future<void> deleteImage(int id);
  Future<void> updateMeal(MealModel meal);
  Future<void> updateImage(ImageModel image);
  Future<void> updateOnlyMeal(MealModel meal);
  Future<List<MealModel>> getMealByCategory(String category);
}
