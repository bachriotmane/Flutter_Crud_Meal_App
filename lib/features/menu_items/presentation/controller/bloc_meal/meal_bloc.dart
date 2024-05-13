import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:food_app/common/services/dependecy.injection.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/usecase/add.meal.todatabase.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/get.meal.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/meal.update.usecase.dart';
import 'package:meta/meta.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  MealBloc() : super(MealInitial()) {
    on<MealEvent>((event, emit) {});
    on<InitialEvent>(initialEvent);
    on<MealAddMealToDataBaseEvent>(addMealToDataBaseEvent);
    on<MealUpdateMealEvent>(mealUpdateMealEvent);
  }

  FutureOr<void> initialEvent(
      InitialEvent event, Emitter<MealState> emit) async {
    emit(MealLoadingState());
    final resp = await serviceLocator<GetMealsUseCase>().call();
    resp.fold(
      (l) {
        emit(MealErrorState(err: l.message));
      },
      (r) {
        emit(MealGetAllMelasState(meals: r));
      },
    );
    emit(MealSuccessState());
  }

  FutureOr<void> addMealToDataBaseEvent(
      MealAddMealToDataBaseEvent event, Emitter<MealState> emit) async {
    AddMealToDataBaseUseCase addMeal =
        serviceLocator<AddMealToDataBaseUseCase>();
    emit(MealLoadingState());
    await addMeal.call(event.meal, event.image);
    emit(MealAddedSucessfulyState());
    emit(MealSuccessState());
  }

  FutureOr<void> mealUpdateMealEvent(
      MealUpdateMealEvent event, Emitter<MealState> emit) async {
    emit(MealLoadingState());
    final resp = await serviceLocator<MealUpdateUseCase>()
        .execute(event.meal, event.image);
    resp.fold(
      (l) {
        emit(MealErrorState(err: l.message));
      },
      (r) {
        emit(MealSuccessState());
        emit(MealUpdatedSucessfulyState());
      },
    );
  }
}
