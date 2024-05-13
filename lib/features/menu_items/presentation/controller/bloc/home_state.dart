// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class HomeSucessState extends HomeState {
  List<Meal> meals;
  List<Photo> images;
  int? cartedItems;
  int selectedCategory;
  HomeSucessState({
    required this.meals,
    required this.images,
    this.cartedItems,
    this.selectedCategory = 0,
  });
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  String errorMessage;
  HomeErrorState({
    required this.errorMessage,
  });
}

class HomeMealAddedSuccesfulyToShopCartActionState extends HomeActionState {}

class HomeNoMealsFoundInCategoryActionState extends HomeActionState {
  String message;
  HomeNoMealsFoundInCategoryActionState({
    required this.message,
  });
}

class HomeMealBoughtActionState extends HomeActionState {}
