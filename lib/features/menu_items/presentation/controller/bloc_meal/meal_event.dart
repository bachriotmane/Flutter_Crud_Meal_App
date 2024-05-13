part of 'meal_bloc.dart';

@immutable
sealed class MealEvent {}

class InitialEvent extends MealEvent {}

class MealAddMealToDataBaseEvent extends MealEvent {
  final Meal meal;
  final Photo image;

  MealAddMealToDataBaseEvent({required this.image, required this.meal});
}

class MealDeleteMealFromDatabaseEvent extends MealEvent {}

class MealUpdateMealEvent extends MealEvent {
  final Meal meal;
  final Photo image;

  MealUpdateMealEvent({
    required this.meal,
    required this.image,
  });
}
