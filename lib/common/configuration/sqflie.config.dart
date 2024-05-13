import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQFliteConfig {
  static final SQFliteConfig instance = SQFliteConfig._init();
  static Database? _database;

  SQFliteConfig._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('meals8.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dir = await getApplicationDocumentsDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final db = openDatabase(join(dir.path, 'my_database.db'),
        version: 1, onCreate: _createDB);
    return db;
    // final dbPath = await getDatabasesPath();
    // final path = join(dbPath, filePath);
    // return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT ';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableMeals ( 
      ${MealsFileds.mealId} $idType,
      ${MealsFileds.mealName} $textType,
      ${MealsFileds.mealPrice} $textType,
      ${MealsFileds.preparationTime} $integerType,
      ${MealsFileds.category} $textType,
      ${MealsFileds.cuisine} $textType,
      ${MealsFileds.imageId} $integerType,
      ${MealsFileds.isCarted} $integerType
      )
    ''');
    await db.execute('''
        CREATE TABLE $tableImage (
          ${ImageFiled.imageId} $idType, 
          ${ImageFiled.imageString} $textType)
      ''');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

const String tableMeals = 'meals';
const String tableOrders = 'orders';
const String tableImage = 'images';

class MealsFileds {
  static final List<String> values = [
    mealId,
    mealName,
    mealPrice,
    preparationTime,
    cuisine,
    category,
    imageId,
    isCarted,
  ];
  static const String mealId = "meal_id";
  static const String mealName = "meal_name";
  static const String mealPrice = "meal_price";
  static const String preparationTime = "preparation_time";
  static const String cuisine = "cuisine";
  static const String category = "category";
  static const String imageId = "image_id";
  static const String isCarted = "is_carted";
}

class OrderFileds {
  static final List<String> values = [
    orderId,
    mealId,
    qnt,
  ];
  static const String orderId = "order_id";
  static const String mealId = "meal_id";
  static const String qnt = "qnt";
}

class ImageFiled {
  static final List<String> values = [imageId, imageString];
  static const String imageId = "image_id";
  static const String imageString = "imageString";
}
