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

class AddNewMealPage extends StatefulWidget {
  const AddNewMealPage({super.key});

  @override
  State<AddNewMealPage> createState() => _AddNewMealPageState();
}

class _AddNewMealPageState extends State<AddNewMealPage> {
  Meal? meal;
  @override
  void initState() {
    super.initState();
    _bloc.add(InitialEvent());
  }

  String imageBase64 = "";
  //! Controllers
  final _nameController = TextEditingController();

  final _priceController = TextEditingController();

  final _preparationTimeController = TextEditingController();

  //! -------
  final _formKey = GlobalKey<FormState>();
  String? dropdownValue;

  final MealBloc _bloc = MealBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (c) => const HomePage()));
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        shadowColor: Colors.grey,
        elevation: 3,
        foregroundColor: Colors.white,
        title: const Text(
          "Add new meal",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2B7657),
      ),
      body: BlocConsumer<MealBloc, MealState>(
        bloc: _bloc,
        buildWhen: (prev, curr) => curr is! MealActionState,
        listenWhen: (prev, curr) => curr is MealActionState,
        listener: (context, state) {
          if (state is MealAddedSucessfulyState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Congrats ! Product saved !"),
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .04),
                      //! Pick Image
                      GestureDetector(
                        onTap: () {
                          ImagePicker()
                              .pickImage(source: ImageSource.gallery)
                              .then(
                            (imgFile) async {
                              if (imgFile != null) {
                                imageBase64 = Utility.base64String(
                                    await imgFile.readAsBytes());
                                setState(() {});
                              }
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)),
                          child: imageBase64.isEmpty
                              ? const Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 80,
                                  color: Colors.black,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      // Image.memory(base64Decode(imageBase64)),
                                      Image.memory(
                                    base64Decode(imageBase64),
                                    height: 150,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * .04),
                      //! Meal Name + price
                      MyTextFiled(
                        hintText: "meal name",
                        iconButton: IconButton(
                          icon: const Icon(Icons.food_bank_outlined),
                          onPressed: () {},
                        ),
                        controller: _nameController,
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
                        controller: _priceController,
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
                        controller: _preparationTimeController,
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
                              dropdownValue = newValue;
                            });
                          },
                          items: AppConstants.categories
                              .map<DropdownMenuItem<String>>((Map value) {
                            return DropdownMenuItem<String>(
                              value: value["categoryName"],
                              child: Text(value["categoryName"]),
                            );
                          }).toList(),
                        ),
                      ),
                      MyCustomeButton(
                        textButton: "Save to database",
                        onTap: () {
                          if (imageBase64.isEmpty) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Meal image is required",
                                      style: TextStyle(color: Colors.white),
                                    )));
                          }
                          if (_formKey.currentState!.validate() &&
                              imageBase64.isNotEmpty) {
                            Photo img = Photo(imageName: imageBase64);

                            _bloc.add(
                              MealAddMealToDataBaseEvent(
                                image: img,
                                meal: Meal(
                                  mealName: _nameController.text,
                                  mealPrice:
                                      double.parse(_priceController.text),
                                  preparationTime: int.parse(
                                      _preparationTimeController.text),
                                  cuisine: Cuisine.mexican,
                                  category: dropdownValue!,
                                ),
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          } else if (state is MealLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MealErrorState) {
            return const Text("Error");
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
