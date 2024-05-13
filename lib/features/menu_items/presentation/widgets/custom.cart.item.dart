// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';

class CustomCartItem extends StatelessWidget {
  int value;
  CustomCartItem({
    super.key,
    required this.meal,
    required this.image,
    required this.onRemove,
    this.value = 1,
    required this.decrementQnt,
    required this.incrementQnt,
  });
  void Function()? incrementQnt;
  void Function()? decrementQnt;
  final Meal meal;
  final Photo image;
  final GlobalKey _key = GlobalKey();
  Function onRemove;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: _key,
      background: const Text(""),
      confirmDismiss: (direction) async {
        bool resp = false;
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
      },
      secondaryBackground: slideLeftBackground(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            //! Image
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64Decode(image.imageName),
                  fit: BoxFit.cover,
                  height: 80,
                ),
              ),
            ),
            //! Other Details
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.mealName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Take ${meal.preparationTime}h",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${meal.mealPrice.toString()}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildQntButtons(),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQntButtons() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          IconButton(
              onPressed: decrementQnt,
              icon: const Icon(
                Icons.remove,
                color: Colors.orange,
                size: 16,
              )),
          Text(
            meal.qnt.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          IconButton(
              onPressed: incrementQnt,
              icon: const Icon(
                Icons.add,
                size: 18,
                color: Colors.deepOrange,
              )),
        ],
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
