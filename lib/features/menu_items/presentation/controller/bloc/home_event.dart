// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeSearchMealsEvent extends HomeEvent {
  String keyword;
  HomeSearchMealsEvent({required this.keyword});
}

class HomeDeleteMealEvent extends HomeEvent {
  int id;
  HomeDeleteMealEvent({required this.id});
}

class HomeAddMealToShopingCart extends HomeEvent {
  Meal meal;
  HomeAddMealToShopingCart({
    required this.meal,
  });
}

class HomeUpdateMealEvent extends HomeEvent {
  final Meal meal;
  final Photo image;

  HomeUpdateMealEvent(this.meal, this.image);
}

class HomeGetMealsByCategoryEvent extends HomeEvent {
  String category;
  HomeGetMealsByCategoryEvent({
    required this.category,
  });
}

class HomeMealBoughtEvent extends HomeEvent {}
