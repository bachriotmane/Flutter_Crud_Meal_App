import 'package:dartz/dartz.dart';
import 'package:food_app/common/errors/failure.dart';
import 'package:food_app/features/menu_items/data/datasource/sqflit.datasource.dart';
import 'package:food_app/features/menu_items/data/models/image.model.dart';
import 'package:food_app/features/menu_items/data/models/meal.model.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/repository/meal.repository.dart';

class MealRepositoryImpl implements MealRepository {
  final SQFlieDataSource datasource;

  MealRepositoryImpl({required this.datasource});
  @override
  Future<Either<Failure, int>> addNewMealToDatabase(
      Meal meal, Photo image) async {
    try {
      int imageId = await datasource
          .saveImageToDataBase(ImageModel(imageName: image.imageName));
      int x = await datasource.addMeal(
        MealModel(
          mealName: meal.mealName,
          mealPrice: meal.mealPrice,
          preparationTime: meal.preparationTime,
          cuisine: meal.cuisine,
          category: meal.category,
          imageId: imageId,
        ),
      );
      return right(x);
    } catch (err) {
      return left(ServerFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> getAllMeals() async {
    try {
      List<Meal> meals = await datasource.getAllMeals();
      return right(meals);
    } catch (err) {
      return left(ServerFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Meal>>> getMealByCategory(String category) async {
    try {
      final resp = await datasource.getMealByCategory(category);
      return right(resp);
    } catch (err) {
      return left(ServerFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, Meal>> getMealById(int id) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Meal>>> getMealByKeyWord(String keyword) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> removeMeal(int id) async {
    try {
      MealModel meal = await datasource.getMealById(id);
      int? imageId = meal.imageId;
      await datasource.deleteMeal(id);
      await datasource.deleteImage(imageId!);
      return right(null);
    } catch (err) {
      return left(ServerFailure(message: err.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMeal(Meal meal, Photo image) async {
    try {
      //? get old image and delete it
      ImageModel oldImage = await datasource.getImageById(meal.imageId!);
      await datasource.deleteImage(oldImage.id!);
      //? Add new Image to DataBase
      int newImageId = await datasource
          .saveImageToDataBase(ImageModel(imageName: image.imageName));
      // meal.imageId = newImageId;
      MealModel mealModel = MealModel(
        mealName: meal.mealName,
        mealPrice: meal.mealPrice,
        preparationTime: meal.preparationTime,
        cuisine: meal.cuisine,
        category: meal.category,
        imageId: newImageId,
        mealId: meal.mealId,
        isCarted: meal.isCarted,
      );
      //? Update Meal;
      await datasource.updateMeal(mealModel);
      return right(null);
    } catch (err) {
      return left(ServerFailure(message: err.toString()));
    }
  }
}
