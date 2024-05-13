import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/presentation/pages/home.page1.dart';
import 'package:food_app/features/menu_items/presentation/widgets/custom.divider.dart';
import 'package:food_app/features/menu_items/presentation/widgets/meal.card.dart';

class MealDetails extends StatelessWidget {
  const MealDetails({super.key, required this.image, required this.meal});
  final Photo image;
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => const HomePage()));
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Center(
        child: Hero(
          tag: image,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(
                          base64Decode(image.imageName),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * .3,
                          width: MediaQuery.of(context).size.width * .9,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 2),
                      child: Text(
                        meal.mealName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 3),
                      child: Text(
                        "\$${meal.mealPrice.toString()}",
                        style: const TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 26),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(FontAwesomeIcons.dollarSign,
                                  size: 17, color: Colors.white),
                              Text("Free Delevery",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.white))
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.timer_sharp,
                                  size: 20, color: Colors.white),
                              Text(" 4h ",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, size: 20, color: Colors.white),
                              Text("4",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        child: const Divider()),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 5),
                      child: const Text("Description",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: const Text(
                          "Description bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla",
                          style: TextStyle(fontSize: 17)),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: const CustomDivisionText(
                            divisonName: "Recamanded for you")),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              10,
                              (index) => MealCard(meal: meal, image: image),
                            ),
                          ),
                        )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .10,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //! -3+
                      Expanded(child: _buildLeftPart()),
                      //! Button add To Cart
                      Expanded(child: _buildRightPart()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildRightPart() {
    return Container(
      padding: const EdgeInsets.all(17),
      margin: const EdgeInsets.all(15),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
          color: Colors.deepOrange, borderRadius: BorderRadius.circular(10)),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
          ),
          Text(
            "Add to cart",
            textHeightBehavior:
                TextHeightBehavior(applyHeightToFirstAscent: false),
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  _buildLeftPart() {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: const BoxDecoration(),
            child: const Icon(Icons.add_circle_outline_rounded, size: 50),
          ),
          Container(
            decoration: const BoxDecoration(),
            child: const Text(
              "4",
              style: TextStyle(fontSize: 35),
            ),
          ),
          Container(
            decoration: const BoxDecoration(),
            child: const Icon(Icons.remove_circle_outline_rounded, size: 50),
          ),
        ],
      ),
    );
  }
}
