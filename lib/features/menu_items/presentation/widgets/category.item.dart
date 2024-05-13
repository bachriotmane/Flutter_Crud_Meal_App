// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  CategoryItem(
      {super.key,
      required this.categoryName,
      required this.imageBase64,
      this.isSelected = false});
  final String categoryName;
  final String imageBase64;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageBase64,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            categoryName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Container(
            height: isSelected ? 2.5 : 1,
            width: 65,
            color: isSelected ? Colors.red : Colors.grey,
          )
        ],
      ),
    );
  }
}


// Container(
//       width: 120,
//       height: 40,
//       margin: const EdgeInsets.symmetric(horizontal: 3),
//       decoration: BoxDecoration(
//         color: isSelected ? const Color(0xFF2B7657) : Colors.grey[200],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//               flex: 2,
//               child: Image.asset(
//                 "assets/fatsfood.png",
//                 height: 30,
//               )),
//           Expanded(
//               flex: 3,
//               child: Text(
//                 "Breakfats",
//                 style: TextStyle(
//                     color: isSelected ? Colors.white : Colors.black,
//                     fontSize: 15),
//               )),
//         ],
//       ),
//     )