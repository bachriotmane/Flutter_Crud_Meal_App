// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:food_app/common/utils/utility.dart';
import 'package:food_app/features/menu_items/data/datasource/datasourceimpl/sqflit.datasource.imp.dart';
import 'package:food_app/features/menu_items/data/models/image.model.dart';
import 'package:food_app/features/menu_items/data/models/meal.model.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<MealModel> meals = [];
  List<ImageModel> images = [];
  SQFlieDataSourceImpl datasource = SQFlieDataSourceImpl();
  bool addItemLoading = false;
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future getMeals() async {
    meals = await datasource.getAllMeals();
    return meals;
  }

  Future getPhotos() async {
    images = await datasource.getPhotos();
    return images;
  }

  Future addMealToDataBase(MealModel meal) async {
    await datasource.addMeal(meal);
  }

  @override
  void initState() {
    super.initState();
    getMeals().then((value) {
      setState(() {
        meals = value;
      });
    });
    getPhotos().then((value) {
      setState(() {
        images = value;
      });
    });
  }

  pickImageFromGallery() {
    ImagePicker().pickImage(source: ImageSource.gallery).then(
      (imgFile) async {
        String imgString = Utility.base64String(await imgFile!.readAsBytes());
        ImageModel img = ImageModel(imageName: imgString);
        await datasource.saveImageToDataBase(img);
        getPhotos().then((value) {
          setState(() {
            images = value;
          });
        });
      },
    );
  }

  gridView() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: images.map((photo) {
          print("photo name");
          print(photo.imageName);
          return Utility.imageFromBase64String(photo.imageName);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            addItemLoading = true;
          });
          await addMealToDataBase(
            MealModel(
              imageId: 1,
              mealName: _nameController.text,
              mealPrice: double.parse(_priceController.text),
              preparationTime: 5,
              cuisine: Cuisine.mexican,
              category: "",
            ),
          );
          getMeals().then((value) {
            meals = value;
            setState(() {
              addItemLoading = false;
            });
          });
        },
      ),
      appBar: AppBar(
        title: const Text("Meals test"),
        actions: [
          IconButton(
              onPressed: () async {
                pickImageFromGallery();
              },
              icon: const Icon(Icons.add_a_photo_outlined))
        ],
      ),
      body: Column(
        children: [
          addItemLoading ? const CircularProgressIndicator() : Container(),
          TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: "Meal Name")),
          TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(hintText: "Meal price")),
          SizedBox(
            height: MediaQuery.of(context).size.height * .2,
            child: gridView(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .6,
            child: ListView.builder(
              itemCount: meals.length,
              itemBuilder: (c, index) => ListTile(
                title: Text(meals[index].mealName),
                subtitle: Text(meals[index].mealPrice.toString()),
                trailing: IconButton(
                    onPressed: () {
                      datasource.deleteMeal(meals[index].mealId!).then((value) {
                        getMeals().then((value) {
                          setState(() {});
                        });
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
