import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({super.key, required this.itemName, required this.icon});
  final String itemName;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
        ),
        title: Text(
          itemName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
