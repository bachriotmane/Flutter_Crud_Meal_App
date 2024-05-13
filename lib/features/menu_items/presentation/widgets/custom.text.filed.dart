import 'package:flutter/material.dart';

class MyTextFiled extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final IconButton? iconButton;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final bool isNumer;
  final String? initialValue;
  const MyTextFiled(
      {Key? key,
      this.initialValue,
      this.isNumer = false,
      required this.hintText,
      this.obscure = false,
      required this.controller,
      this.iconButton,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      // padding: const EdgeInsets.all(15),
      child: TextFormField(
        keyboardType: isNumer ? TextInputType.number : TextInputType.text,
        validator: validator,
        controller: controller,
        obscureText: obscure,
        cursorColor: const Color(0xFF2B7657),
        style: const TextStyle(fontSize: 17, height: 1.03),
        decoration: InputDecoration(
          suffixIcon: iconButton,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Color(0xFF2B7657),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusColor: const Color(0xFF2B7657),
          hintStyle: TextStyle(color: Colors.grey[600]),
          fillColor: Colors.grey[300],
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}
