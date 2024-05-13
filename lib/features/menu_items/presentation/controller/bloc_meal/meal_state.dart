// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'meal_bloc.dart';

@immutable
sealed class MealState {}

class MealActionState extends MealState {}

final class MealInitial extends MealState {}

class MealSuccessState extends MealState {}

class MealLoadingState extends MealState {}

class MealErrorState extends MealState {
  String err;
  MealErrorState({
    required this.err,
  });
}

final class MealGetAllMelasState extends MealState {
  List<Meal> meals;
  MealGetAllMelasState({
    required this.meals,
  });
}

class MealNavigateToMealDetailsPageActionState extends MealActionState {}

class MealAddedSucessfulyState extends MealActionState {}

class MealUpdatedSucessfulyState extends MealActionState {}
