// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';

class MealCard extends StatelessWidget {
  MealCard({
    super.key,
    required this.meal,
    required this.image,
    this.toggleMealFromShopCart,
  });
  final Meal meal;
  // String? imageBase64;
  final Photo image;
  void Function()? toggleMealFromShopCart;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * .4,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        children: [
          //! Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            // child: image,
            child: Image.memory(
              base64Decode(image.imageName),
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * .12,
              width: MediaQuery.of(context).size.width * .4,
            ),
          ),
          //! Name + add to cart
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  meal.mealName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ),
              Container(
                height: 30,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                    color: meal.isCarted
                        ? const Color(0xFF2B7657)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(17)),
                child: IconButton(
                    onPressed: toggleMealFromShopCart,
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: meal.isCarted ? Colors.white : Colors.black,
                      size: 20,
                    )),
              )
            ],
          ),
          //! price + 2 hours
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$ ${meal.mealPrice.toString()}",
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Flexible(
                  child: Text(
                    "Take ${meal.preparationTime} hours",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
