import 'package:flutter/material.dart';
import 'package:food_app/common/services/dependecy.injection.dart';
import 'package:food_app/features/menu_items/presentation/pages/home.page1.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  init();
  sqfliteFfiInit();
  databaseFactoryOrNull = null;
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
