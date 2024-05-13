import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () {},
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
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 50,
          width: 40,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(Icons.shopping_cart_outlined, size: 22),
        )
      ],
    );
  }
}
