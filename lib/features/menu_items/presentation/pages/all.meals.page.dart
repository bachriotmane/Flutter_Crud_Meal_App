// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/menu_items/presentation/controller/bloc/home_bloc.dart';
import 'package:food_app/features/menu_items/presentation/pages/home.page1.dart';
import 'package:food_app/features/menu_items/presentation/widgets/meal.item.horizontal.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class MealsPage extends StatelessWidget {
  MealsPage({super.key});

  HomeBloc homeBloc = HomeBloc();
  initState() {
    homeBloc.add(HomeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    initState();
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 3,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => const HomePage()));
            },
            icon: const Icon(Icons.arrow_back_ios)),
        foregroundColor: Colors.white,
        title: const Text(
          "Meals for admin",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B7657),
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (prev, curr) => curr is HomeActionState,
        buildWhen: (prev, curr) => curr is! HomeActionState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is HomeSucessState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.meals.length,
                    itemBuilder: (c, index) => Column(
                      children: [
                        MealItemHorizontal(
                          image: state.images[index],
                          onRemove: () {
                            homeBloc.add(HomeDeleteMealEvent(
                                id: state.meals[index].mealId!));
                          },
                          meal: state.meals[index],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * .2),
                          child: const Divider(),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else if (state is HomeLoadingState) {
            return Center(
              child: LoadingAnimationWidget.flickr(
                leftDotColor: Colors.blue,
                rightDotColor: Colors.green,
                size: 60,
              ),
            );
          } else if (state is HomeErrorState) {
            return Text(state.errorMessage);
          } else {
            return const Center(
              child: Text("Other state"),
            );
          }
        },
      ),
    );
  }
}
