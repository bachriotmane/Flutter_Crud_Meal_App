// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_app/common/services/dependecy.injection.dart';
import 'package:food_app/common/utils/app.constants.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/usecase/get.meal.usecase.dart';
import 'package:food_app/features/menu_items/presentation/controller/bloc/home_bloc.dart';
import 'package:food_app/features/menu_items/presentation/pages/add.newmeal.dart';
import 'package:food_app/features/menu_items/presentation/pages/all.meals.page.dart';
import 'package:food_app/features/menu_items/presentation/pages/meal.details.page.dart';
import 'package:food_app/features/menu_items/presentation/pages/shop.cart.page.dart';
import 'package:food_app/features/menu_items/presentation/widgets/category.item.dart';
import 'package:food_app/features/menu_items/presentation/widgets/custom.divider.dart';
import 'package:food_app/features/menu_items/presentation/widgets/custom.search.bar.dart';
import 'package:food_app/features/menu_items/presentation/widgets/draer.item.dart';
import 'package:food_app/features/menu_items/presentation/widgets/meal.card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffolfKey = GlobalKey<ScaffoldState>();

  final _bloc = HomeBloc();
  int cartedItems = 0;

  initState1() async {
    _bloc.add(HomeInitialEvent());
    serviceLocator<GetMealsUseCase>().call().then(
      (value) {
        value.fold((l) {}, (r) {
          setState(() {
            int x = 0;
            for (var i = 0; i < r.length; i++) {
              if (r[i].isCarted) {
                x++;
              }
            }
            cartedItems = x;
          });
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initState1();
  }

  @override
  Widget build(BuildContext context) {
    // initState1();
    return Scaffold(
        key: scaffolfKey,
        drawer: _buildDraer(context),
        appBar: _buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! SerachBar + Filter
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .013),
                  _buildSearchBar(),
                  CustomDivisionText(divisonName: "Categories", onTap: () {}),
                  //! Categories
                ],
              ),
            ),
            Expanded(
              flex: 11,
              child: BlocConsumer<HomeBloc, HomeState>(
                bloc: _bloc,
                buildWhen: (prev, curr) => curr is! HomeActionState,
                listenWhen: (prev, curr) => curr is HomeActionState,
                listener: (context, state) {
                  if (state is HomeMealAddedSuccesfulyToShopCartActionState) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Meal added succesfuly to shoping cart!"),
                      backgroundColor: Colors.green,
                    ));
                  } else if (state is HomeNoMealsFoundInCategoryActionState) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                builder: (context, state) {
                  if (state is HomeSucessState) {
                    cartedItems = state.cartedItems!;
                    return Column(
                      children: [
                        //! Meals
                        _buildCategories(state.selectedCategory),
                        const SizedBox(height: 15),
                        _buildMealsItems(state.meals, state.images, context),
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
                    return Center(child: Text(state.errorMessage));
                  } else {
                    return const Center(child: Text("Uknown State"));
                  }
                },
              ),
            )
          ],
        ));
  }

  _buildAppBar(context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {
          scaffolfKey.currentState!.openDrawer();
        },
        child: Container(
          margin: const EdgeInsets.all(7),
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.menu_sharp, size: 22),
        ),
      ),
      title: const Text(
        "Home",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      actions: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
            width: MediaQuery.of(context).size.width * .2,
            alignment: Alignment.centerRight,
            child: Stack(
              children: [
                Transform.rotate(
                  angle: 0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ShopCartPage()));
                    },
                    icon: const Icon(
                      FontAwesomeIcons.cartShopping,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                ),
                Positioned(
                    left: 27,
                    top: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      radius: 12,
                      child: Text(
                        "$cartedItems",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
              ],
            ))
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: MyCustomSearchBar(
              onChanged: (value) {
                _bloc.add(HomeSearchMealsEvent(keyword: value));
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.only(left: 7),
                height: 56,
                decoration: BoxDecoration(
                    color: const Color(0xFF2B7657),
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(50)),
                child: const Icon(
                  FontAwesomeIcons.sliders,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategories(int selectedCat) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              AppConstants.categories.length,
              (index) => GestureDetector(
                onTap: () {
                  _bloc.add(
                    HomeGetMealsByCategoryEvent(
                        category: AppConstants.categories[index]
                            ["categoryName"]!),
                  );
                },
                child: CategoryItem(
                  categoryName: AppConstants.categories[index]["categoryName"]!,
                  imageBase64: AppConstants.categories[index]["imageLink"]!,
                  isSelected: index == selectedCat,
                ),
              ),
            ),
          )),
    );
  }

  Widget _buildMealsItems(
      List<Meal> meals, List<Photo> images, BuildContext context) {
    Photo? getImageForMeal(int imageId) {
      for (var i = 0; i < images.length; i++) {
        if (images[i].id == imageId) {
          return images[i];
        }
      }
      return null;
    }

    return Expanded(
      child: meals.isNotEmpty
          ? GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              children: List.generate(meals.length, (index) {
                Photo? image = getImageForMeal(meals[index].imageId!);
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MealDetails(image: image, meal: meals[index]),
                      ),
                    );
                  },
                  child: Hero(
                    tag: image!,
                    child: MealCard(
                      toggleMealFromShopCart: () {
                        setState(() {
                          meals[index].isCarted = !meals[index].isCarted;
                          int x = 0;
                          for (var i = 0; i < meals.length; i++) {
                            if (meals[i].isCarted) {
                              x++;
                            }
                          }
                          cartedItems = x;
                        });
                        _bloc.add(HomeAddMealToShopingCart(meal: meals[index]));
                      },
                      image: image,
                      meal: Meal(
                        imageId: meals[index].imageId,
                        mealName: meals[index].mealName,
                        mealPrice: meals[index].mealPrice,
                        preparationTime: meals[index].preparationTime,
                        cuisine: Cuisine.chinese,
                        category: meals[index].category,
                        isCarted: meals[index].isCarted,
                        mealId: meals[index].mealId,
                      ),
                    ),
                  ),
                );
              }))
          : const Center(
              child: Text(
                "OOPS ! No meals 😵",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}

_buildDraer(context) {
  return Drawer(
    child: Column(
      children: [
        const DrawerHeader(
            child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/profile.jpg"),
              radius: 50,
            ),
            Text(
              "Otmane Bachri",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        )),
        InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => MealsPage()));
          },
          child: const DrawerItem(itemName: "Get all meals", icon: Icons.list),
        ),
        InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (c) => const AddNewMealPage()));
            },
            child: const DrawerItem(
                itemName: "Add new meal", icon: Icons.add_box_rounded)),
      ],
    ),
  );
}
