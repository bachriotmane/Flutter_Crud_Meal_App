import 'package:food_app/common/configuration/sqflie.config.dart';
import 'package:food_app/features/menu_items/data/datasource/sqflit.datasource.dart';
import 'package:food_app/features/menu_items/data/models/image.model.dart';
import 'package:food_app/features/menu_items/data/models/meal.model.dart';
import 'package:food_app/features/menu_items/data/models/order.model.dart';
import 'package:sqflite/sqflite.dart';

class SQFlieDataSourceImpl implements SQFlieDataSource {
  @override
  Future<int> addMeal(MealModel meal) async {
    Database databse = await SQFliteConfig.instance.database;
    return await databse.insert(tableMeals, meal.toJSON());
  }

  @override
  Future<List<MealModel>> getAllMeals() async {
    Database databse = await SQFliteConfig.instance.database;
    final meals = await databse.query(tableMeals);
    return meals.map((e) => MealModel.fromJSON(e)).toList();
  }

  @override
  Future<MealModel> getMealById(int id) async {
    Database databse = await SQFliteConfig.instance.database;
    final map = await databse.query(tableMeals,
        columns: MealsFileds.values,
        where: '${MealsFileds.imageId}= ?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return MealModel.fromJSON(map.first);
    } else {
      throw Exception("Meal with id = $id not found!");
    }
  }

  @override
  Future<List<MealModel>> getMealByKeyword(String keyword) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMeal(int id) async {
    Database databse = await SQFliteConfig.instance.database;
    int deleteedRows = await databse.delete(
      tableMeals,
      where: '${MealsFileds.mealId}=?',
      whereArgs: [id],
    );
    if (deleteedRows == 0) {
      throw Exception("No row deleted");
    }
  }

  @override
  Future<void> makeOrder(OrderModel order) async {
    Database databse = await SQFliteConfig.instance.database;
    await databse.insert(tableOrders, order.toJson());
  }

  @override
  Future<int> saveImageToDataBase(ImageModel image) async {
    Database databse = await SQFliteConfig.instance.database;
    return await databse.insert(tableImage, image.toJson());
  }

  @override
  Future<List<ImageModel>> getPhotos() async {
    Database databse = await SQFliteConfig.instance.database;
    List images = await databse.query(tableImage);
    return images.map(
      (e) {
        return ImageModel.fromJson(e);
      },
    ).toList();
  }

  @override
  Future<ImageModel> getAllImages() async {
    return ImageModel(imageName: "");
  }

  @override
  Future<ImageModel> getImageById(int id) async {
    Database databse = await SQFliteConfig.instance.database;
    final map = await databse.query(
      tableImage,
      columns: ImageFiled.values,
      where: '${ImageFiled.imageId}= ?',
      whereArgs: [id],
    );
    if (map.isNotEmpty) {
      return ImageModel.fromJson(map.first);
    } else {
      throw Exception("Image with id = $id not found!");
    }
  }

  @override
  Future<List<MealModel>> getMealsByName(String name) async {
    final Database db = await SQFliteConfig.instance.database;
    List<MealModel> meals = [];
    final List maps = await db.query(
      tableMeals,
      where: "${MealsFileds.mealName} LIKE ?",
      whereArgs: ['%$name%'],
    );
    for (var i = 0; i < maps.length; i++) {
      meals.add(MealModel.fromJSON(maps[i]));
    }
    return meals;
  }

  @override
  Future<void> deleteImage(int id) async {
    Database databse = await SQFliteConfig.instance.database;
    int deleteedRows = await databse.delete(
      tableImage,
      where: '${ImageFiled.imageId}=?',
      whereArgs: [id],
    );
    if (deleteedRows == 0) {
      throw Exception("No row deleted");
    }
  }

  @override
  Future<void> updateMeal(MealModel meal) async {
    Database databse = await SQFliteConfig.instance.database;
    int updatedCount = await databse.update(
      tableMeals,
      meal.toJSON(),
      where: '${MealsFileds.mealId}=?',
      whereArgs: [meal.mealId],
    );
    if (updatedCount == 0) {
      throw Exception("Meal not updated");
    }
  }

  @override
  Future<void> updateImage(ImageModel image) async {
    Database databse = await SQFliteConfig.instance.database;
    int updatedCount = await databse.update(
      tableImage,
      image.toJson(),
      where: '${ImageFiled.imageId}=?',
      whereArgs: [image.id],
    );
    if (updatedCount == 0) {
      throw Exception("Image not updated");
    }
  }

  @override
  Future<void> updateOnlyMeal(MealModel meal) {
    throw UnimplementedError();
  }

  @override
  Future<List<MealModel>> getMealByCategory(String category) async {
    Database databse = await SQFliteConfig.instance.database;
    List<Map<String, Object?>> map = await databse.query(tableMeals,
        columns: MealsFileds.values,
        where: '${MealsFileds.category}= ?',
        whereArgs: [category]);
    if (map.isNotEmpty) {
      return map.map((e) => MealModel.fromJSON(e)).toList();
    } else {
      throw Exception("no meals for category $category");
    }
  }
}
