import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_app/common/services/dependecy.injection.dart';
import 'package:food_app/common/utils/app.constants.dart';
import 'package:food_app/features/menu_items/data/datasource/sqflit.datasource.dart';
import 'package:food_app/features/menu_items/data/models/meal.model.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/usecase/delte.product.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/get.meal.usecase.dart';
import 'package:food_app/features/menu_items/domain/usecase/meal.update.usecase.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeSearchMealsEvent>(homeSearchMealsEvent);
    on<HomeDeleteMealEvent>(homeDeleteMealEvent);
    on<HomeAddMealToShopingCart>(homeAddMealToShopingCart);
    on<HomeGetMealsByCategoryEvent>(homeGetMealsByCategoryEvent);
    on<HomeUpdateMealEvent>(homeUpdateMealEvent);
    on<HomeMealBoughtEvent>(homeMealBoughtEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    List<Meal> meals = [];
    List<Photo> images = [];
    emit(HomeLoadingState());
    final resp = await serviceLocator<GetMealsUseCase>().call();
    final imagesResp = await serviceLocator<SQFlieDataSource>().getPhotos();
    resp.fold(
      (l) {
        emit(HomeErrorState(errorMessage: l.message));
      },
      (r) {
        meals = r;
      },
    );
    for (var i = 0; i < imagesResp.length; i++) {
      images
          .add(Photo(imageName: imagesResp[i].imageName, id: imagesResp[i].id));
    }
    int cartedItems = 0;
    for (var i = 0; i < meals.length; i++) {
      if (meals[i].isCarted) {
        cartedItems++;
      }
    }
    emit(HomeSucessState(
        meals: meals, images: images, cartedItems: cartedItems));
  }

  FutureOr<void> homeSearchMealsEvent(
      HomeSearchMealsEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    List<MealModel> meals =
        await serviceLocator<SQFlieDataSource>().getMealsByName(event.keyword);
    final imagesResp = await serviceLocator<SQFlieDataSource>().getPhotos();

    List<Meal> realMeals = [];
    List<Photo> images = [];
    for (var i = 0; i < meals.length; i++) {
      realMeals.add(
        Meal(
          imageId: meals[i].imageId,
          mealId: meals[i].mealId,
          isCarted: meals[i].isCarted,
          mealName: meals[i].mealName,
          mealPrice: meals[i].mealPrice,
          preparationTime: meals[i].preparationTime,
          cuisine: meals[i].cuisine,
          category: meals[i].category,
        ),
      );
    }
    int x = 0;
    for (var i = 0; i < imagesResp.length; i++) {
      for (var j = 0; j < meals.length; j++) {
        if (meals[j].isCarted) {
          x++;
        }
        if (meals[j].imageId == imagesResp[i].id) {
          images.add(
              Photo(imageName: imagesResp[i].imageName, id: imagesResp[i].id));
        }
      }
    }

    emit(HomeSucessState(meals: realMeals, images: images, cartedItems: x));
  }

  FutureOr<void> homeDeleteMealEvent(
      HomeDeleteMealEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    final resp1 = await serviceLocator<DeleteProductUseCase>().call(event.id);
    List<Meal> meals = [];
    List<Photo> images = [];
    final resp = await serviceLocator<GetMealsUseCase>().call();
    final imagesResp = await serviceLocator<SQFlieDataSource>().getPhotos();
    int x = 0;
    resp.fold(
      (l) {
        emit(HomeErrorState(errorMessage: l.message));
      },
      (r) {
        meals = r;
        for (var i = 0; i < r.length; i++) {
          x++;
        }
      },
    );
    for (var i = 0; i < imagesResp.length; i++) {
      images
          .add(Photo(imageName: imagesResp[i].imageName, id: imagesResp[i].id));
    }

    resp1.fold(
      (l) => emit(HomeErrorState(errorMessage: l.message)),
      (r) {
        emit(HomeSucessState(meals: meals, images: images, cartedItems: x));
      },
    );
  }

  FutureOr<void> homeAddMealToShopingCart(
      HomeAddMealToShopingCart event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await serviceLocator<SQFlieDataSource>().updateMeal(
      MealModel(
        mealId: event.meal.mealId,
        imageId: event.meal.imageId,
        isCarted: event.meal.isCarted,
        mealName: event.meal.mealName,
        mealPrice: event.meal.mealPrice,
        preparationTime: event.meal.preparationTime,
        cuisine: event.meal.cuisine,
        category: event.meal.category,
      ),
    );
    List<Meal> meals = [];
    List<Photo> images = [];
    final resp = await serviceLocator<GetMealsUseCase>().call();
    final imagesResp = await serviceLocator<SQFlieDataSource>().getPhotos();
    int x = 0;
    resp.fold(
      (l) {
        emit(HomeErrorState(errorMessage: l.message));
      },
      (r) {
        meals = r;
        for (var i = 0; i < r.length; i++) {
          x++;
        }
      },
    );
    for (var i = 0; i < imagesResp.length; i++) {
      images
          .add(Photo(imageName: imagesResp[i].imageName, id: imagesResp[i].id));
    }

    emit(HomeSucessState(meals: meals, images: images, cartedItems: x));
    emit(HomeMealAddedSuccesfulyToShopCartActionState());
  }

  FutureOr<void> homeGetMealsByCategoryEvent(
      HomeGetMealsByCategoryEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    List<Photo> images = [];
    List<Meal> meals = [];
    int cartedItems = 0;
    int selectedIndex = 0;
    // Get IMAGES
    final respImages = await serviceLocator<SQFlieDataSource>().getPhotos();
    for (var i = 0; i < respImages.length; i++) {
      images
          .add(Photo(imageName: respImages[i].imageName, id: respImages[i].id));
    }
    final resp = await serviceLocator<GetMealsUseCase>().call();
    resp.fold(
      (l) {
        emit(HomeErrorState(errorMessage: l.message));
      },
      (r) {
        meals = r;
      },
    );
    for (var i = 0; i < meals.length; i++) {
      if (meals[i].isCarted) {
        cartedItems++;
      }
    }
    if (event.category == "All") {
      emit(HomeSucessState(
        meals: meals,
        images: images,
        selectedCategory: 0,
        cartedItems: cartedItems,
      ));
    } else {
      meals.removeWhere((meal) => meal.category != event.category);
      int i = 0;
      for (var element in AppConstants.categories) {
        String s = element["categoryName"]!;
        if (event.category == s) {
          selectedIndex = i;
        }
        i++;
      }
      emit(HomeSucessState(
        meals: meals,
        images: images,
        cartedItems: cartedItems,
        selectedCategory: selectedIndex,
      ));
    }
  }

  FutureOr<void> homeUpdateMealEvent(
      HomeUpdateMealEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    final resp = await serviceLocator<MealUpdateUseCase>()
        .execute(event.meal, event.image);
    List<Photo> images = [];
    List<Meal> meals = [];

    // Get IMAGES
    final respImages = await serviceLocator<SQFlieDataSource>().getPhotos();
    for (var i = 0; i < respImages.length; i++) {
      images
          .add(Photo(imageName: respImages[i].imageName, id: respImages[i].id));
    }
    final resp1 = await serviceLocator<GetMealsUseCase>().call();
    resp1.fold(
      (l) {
        emit(HomeErrorState(errorMessage: l.message));
      },
      (r) {
        meals = r;
      },
    );

    resp.fold(
      (l) {
        emit(HomeErrorState(errorMessage: l.message));
      },
      (r) {
        emit(HomeSucessState(images: images, meals: meals));
      },
    );
  }

  FutureOr<void> homeMealBoughtEvent(
      HomeMealBoughtEvent event, Emitter<HomeState> emit) {
    emit(HomeMealBoughtActionState());
  }
}
