import 'package:flutter/material.dart';

class CustomDivisionText extends StatelessWidget {
  const CustomDivisionText({super.key, required this.divisonName, this.onTap});
  final String divisonName;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 7),
          child: Text(
            divisonName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: const Text(
              "See all",
              style: TextStyle(
                  color: Color(0xFF2B7657),
                  fontSize: 20,
                  decoration: TextDecoration.underline,
                  decorationColor: Color(0xFF2B7657)),
            ),
          ),
        )
      ],
    );
  }
}
