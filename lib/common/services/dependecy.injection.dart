import 'package:food_app/features/menu_items/data/datasource/datasourceimpl/sqflit.datasource.imp.dart';
import 'package:food_app/features/menu_items/data/datasource/sqflit.datasource.dart';
import 'package:food_app/features/menu_items/data/repository/meal.repository.impl.dart';
import 'package:food_app/features/menu_items/domain/repository/meal.repository.dart';
import 'package:food_app/features/menu_items/domain/usecase/add.meal.todatabase.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/delte.product.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/get.meal.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/get.meals.bycat.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/meal.update.usecase.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;
init() {
  serviceLocator
      .registerLazySingleton<SQFlieDataSource>(() => SQFlieDataSourceImpl());
  serviceLocator.registerLazySingleton<MealRepository>(
      () => MealRepositoryImpl(datasource: serviceLocator<SQFlieDataSource>()));

  serviceLocator.registerLazySingleton<AddMealToDataBaseUseCase>(() =>
      AddMealToDataBaseUseCase(repository: serviceLocator<MealRepository>()));
  serviceLocator.registerLazySingleton<GetMealsUseCase>(
      () => GetMealsUseCase(repo: serviceLocator<MealRepository>()));
  serviceLocator.registerLazySingleton<DeleteProductUseCase>(
      () => DeleteProductUseCase(repository: serviceLocator<MealRepository>()));
  serviceLocator.registerLazySingleton<MealUpdateUseCase>(
      () => MealUpdateUseCase(repository: serviceLocator<MealRepository>()));
  serviceLocator.registerLazySingleton<GetMealsByCategoryUseCase>(() =>
      GetMealsByCategoryUseCase(repository: serviceLocator<MealRepository>()));
}
