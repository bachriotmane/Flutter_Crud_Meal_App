// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_app/common/utils/app.constants.dart';
import 'package:food_app/common/utils/utility.dart';
import 'package:food_app/features/menu_items/domain/entities/meal.dart';
import 'package:food_app/features/menu_items/domain/entities/image.dart';
import 'package:food_app/features/menu_items/presentation/controller/bloc_meal/meal_bloc.dart';
import 'package:food_app/features/menu_items/presentation/pages/home.page1.dart';
import 'package:food_app/features/menu_items/presentation/widgets/custom.button.dart';
import 'package:food_app/features/menu_items/presentation/widgets/custom.text.filed.dart';
import 'package:image_picker/image_picker.dart';

class UpdateMealPage extends StatefulWidget {
  const UpdateMealPage({super.key, required this.meal, required this.image});
  final Meal meal;
  final Photo image;

  @override
  State<UpdateMealPage> createState() => _UpdateMealPage();
}

class _UpdateMealPage extends State<UpdateMealPage> {
  Meal? meal;

  @override
  void initState() {
    super.initState();
    imageBase64 = widget.image.imageName;
    _bloc.add(InitialEvent());
  }

  String imageBase64 = "";
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = AppConstants.categories[0]["categoryName"]!;

  final MealBloc _bloc = MealBloc();

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.meal.mealName);
    final priceController =
        TextEditingController(text: widget.meal.mealPrice.toString());
    final preparationTimeController =
        TextEditingController(text: widget.meal.preparationTime.toString());
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const HomePage(),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          shadowColor: Colors.grey,
          elevation: 3,
          foregroundColor: Colors.white,
          title: const Text(
            "Update meal",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF2B7657)),
      body: BlocConsumer<MealBloc, MealState>(
        bloc: _bloc,
        buildWhen: (prev, curr) => curr is! MealActionState,
        listenWhen: (prev, curr) => curr is MealActionState,
        listener: (context, state) {
          if (state is MealUpdatedSucessfulyState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Congrats ! Meal updated !"),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is MealSuccessState) {
            return Form(
              key: _formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * .04),
                    //! Pick Image
                    GestureDetector(
                      onTap: () {
                        ImagePicker()
                            .pickImage(source: ImageSource.gallery)
                            .then(
                          (imgFile) {
                            if (imgFile != null) {
                              imgFile.readAsBytes().then((value) {
                                setState(() {
                                  imageBase64 = Utility.base64String(value);
                                });
                              });
                            }
                          },
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(18.0),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 2,
                                spreadRadius: 2,
                              )
                            ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            base64Decode(
                              imageBase64.isEmpty
                                  ? widget.image.imageName
                                  : imageBase64,
                            ),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .04),
                    //! Meal Name + price
                    MyTextFiled(
                      initialValue: widget.meal.mealName,
                      hintText: "meal name",
                      iconButton: IconButton(
                        icon: const Icon(Icons.food_bank_outlined),
                        onPressed: () {},
                      ),
                      controller: nameController,
                      obscure: false,
                      validator: (value) {
                        if (value == null) {
                          return "not valid";
                        } else if (value.isEmpty) {
                          return "required *";
                        } else if (value.length < 3) {
                          return "at least 4 characters";
                        }
                        return null;
                      },
                    ),
                    MyTextFiled(
                      initialValue: widget.meal.mealPrice.toString(),
                      hintText: "price",
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !_isDouble(value)) {
                          return "Not a valid value";
                        }
                        return null;
                      },
                      iconButton: IconButton(
                        icon: const Icon(Icons.monetization_on_outlined),
                        onPressed: () {},
                      ),
                      controller: priceController,
                      obscure: false,
                    ),
                    MyTextFiled(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "required *";
                        } else if (!_isIntrger(value)) {
                          return "a integer value required";
                        }
                        return null;
                      },
                      isNumer: true,
                      hintText: "preparation time",
                      iconButton: IconButton(
                        icon: const Icon(Icons.timer_outlined),
                        onPressed: () {},
                      ),
                      controller: preparationTimeController,
                      obscure: false,
                    ),
                    //! Category :
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(10),
                        padding: const EdgeInsets.all(5),
                        hint: const Text("Category"),
                        value: dropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: AppConstants.categories.map((Map value) {
                          return DropdownMenuItem<String>(
                            value: value["categoryName"],
                            child: Text(value["categoryName"]),
                          );
                        }).toList(),
                      ),
                    ),
                    MyCustomeButton(
                      textButton: "Update meal",
                      onTap: () {
                        if (imageBase64.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    "Meal image is required",
                                    style: TextStyle(color: Colors.white),
                                  )));
                          return;
                        }
                        if (_formKey.currentState!.validate() &&
                            imageBase64.isNotEmpty) {
                          Photo img = Photo(imageName: imageBase64);
                          _bloc.add(
                            MealUpdateMealEvent(
                              image: img,
                              meal: Meal(
                                imageId: widget.meal.imageId,
                                mealId: widget.meal.mealId,
                                mealName: nameController.text,
                                mealPrice: double.parse(priceController.text),
                                preparationTime:
                                    int.parse(preparationTimeController.text),
                                cuisine: Cuisine.mexican,
                                category: dropdownValue,
                              ),
                            ),
                          );
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => const HomePage()));
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          } else if (state is MealLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MealErrorState) {
            return Text(state.err);
          }
          return const Text("Uknown");
        },
      ),
    );
  }

  bool _isDouble(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final RegExp regex = RegExp(r'^-?\d+(\.\d+)?$');
    return regex.hasMatch(value);
  }

  bool _isIntrger(String? value) {
    if (value == null || value.isEmpty) {
      return false;
    }
    final RegExp regex = RegExp(r'^-?\d+$');

    return regex.hasMatch(value);
  }
}
