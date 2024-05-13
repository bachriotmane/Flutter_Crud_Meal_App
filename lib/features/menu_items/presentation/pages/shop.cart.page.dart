// ignore_for_file: must_be_immutable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/presentation/controller/bloc/home_bloc.dart';
import 'package:food_app/features/menu_items/presentation/pages/home.page1.dart';
import 'package:food_app/features/menu_items/presentation/widgets/custom.cart.item.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShopCartPage extends StatefulWidget {
  const ShopCartPage({super.key});

  @override
  State<ShopCartPage> createState() => _ShopCartPageState();
}

class _ShopCartPageState extends State<ShopCartPage> {
  int qnt = 1;
  int totalQnt = 1;
  double totalPrice = 0.0;

  HomeBloc homeBloc = HomeBloc();

  @override
  initState() {
    super.initState();
    homeBloc.add(HomeInitialEvent());
  }

  Photo? getImageForMeal(Meal meal, List<Photo> images) {
    for (var i = 0; i < images.length; i++) {
      if (images[i].id == meal.imageId) {
        return images[i];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => const HomePage()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        foregroundColor: Colors.white,
        title: const Text(
          "Shoping cart",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (prev, curr) => curr is HomeActionState,
        buildWhen: (prev, curr) => curr is! HomeActionState,
        listener: (context, state) async {
          if (state is HomeMealBoughtActionState) {
            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            //     backgroundColor: Colors.green,
            //     content: Text("Order passed Succesfuly")));

            AwesomeDialog(
              context: context,
              animType: AnimType.scale,
              dialogType: DialogType.success,
              body: const Center(
                child: Text(
                  'Order passed Succesfuly',
                ),
              ),
              btnOkOnPress: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomePage()));
              },
            ).show();
          }
        },
        builder: (context, state) {
          if (state is HomeSucessState) {
            totalPrice = 0;
            for (var i = 0; i < state.meals.length; i++) {
              totalPrice += (state.meals[i].qnt * state.meals[i].mealPrice);
            }
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: state.meals.length,
                          itemBuilder: (c, index) {
                            Photo? image = getImageForMeal(
                                state.meals[index], state.images);
                            if (state.meals[index].isCarted) {
                              qnt = state.meals[index].qnt;
                              totalPrice +=
                                  (qnt * state.meals[index].mealPrice);

                              return Column(
                                children: [
                                  CustomCartItem(
                                      decrementQnt: () {
                                        setState(() {
                                          if (state.meals[index].qnt > 0) {
                                            state.meals[index].qnt--;
                                          }
                                        });
                                      },
                                      incrementQnt: () {
                                        setState(() {
                                          state.meals[index].qnt++;
                                        });
                                      },
                                      value: qnt,
                                      onRemove: () {
                                        homeBloc.add(HomeUpdateMealEvent(
                                          Meal(
                                            mealName:
                                                state.meals[index].mealName,
                                            mealPrice:
                                                state.meals[index].mealPrice,
                                            preparationTime: state
                                                .meals[index].preparationTime,
                                            cuisine: state.meals[index].cuisine,
                                            category:
                                                state.meals[index].category,
                                            imageId: state.meals[index].imageId,
                                            isCarted: false,
                                            mealId: state.meals[index].mealId,
                                          ),
                                          image!,
                                        ));
                                      },
                                      meal: state.meals[index],
                                      image: state.images[index]),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .15,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Total",
                                    style: TextStyle(fontSize: 28)),
                                Text(
                                  "\$${totalPrice.toStringAsFixed(1)}",
                                  style: const TextStyle(
                                      color: Colors.deepOrange,
                                      fontSize: 27,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              homeBloc.add(HomeMealBoughtEvent());
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * .9,
                              height: MediaQuery.of(context).size.height * .06,
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text(
                                "Buy now",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
