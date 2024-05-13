// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';

import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/presentation/pages/update.meal.page.dart';

class MealItemHorizontal extends StatelessWidget {
  MealItemHorizontal({
    Key? key,
    required this.meal,
    required this.onRemove,
    required this.image,
  }) : super(key: key);
  final Meal meal;
  final Photo image;
  final GlobalKey _key = GlobalKey();
  void Function() onRemove;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) async {
        bool resp = false;
        if (direction == DismissDirection.endToStart) {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content:
                      Text("Are you sure you want to delete ${meal.mealName}?"),
                  actions: <Widget>[
                    GestureDetector(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        resp = false;
                      },
                    ),
                    GestureDetector(
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        //!Delete Item From Database
                        onRemove();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
                            content: Text("Meal ${meal.mealName} deleted !"),
                          ),
                        );
                        resp = true;
                      },
                    ),
                  ],
                );
              });
          return resp;
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => UpdateMealPage(meal: meal, image: image)));
        }
        return null;
      },
      key: _key,
      background: slideRightBackground(),
      secondaryBackground: slideLeftBackground(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(19),
                child: Image.memory(
                  base64Decode(image.imageName),
                  height: 100,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.mealName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    "Take ${meal.preparationTime.toString()}h to prepare!",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "\$ ${meal.mealPrice}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  "breakfast",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Remove  ",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
