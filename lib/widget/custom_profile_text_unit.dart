import 'package:flutter/material.dart';
import '../config/color.dart';

class CustomProfileTextUnit extends StatelessWidget {

  final IconData icon;
  final String title;

  const CustomProfileTextUnit({super.key, required this.icon, required this.title, });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 320,
      child: Column(
        children: [
          ListTile(
              leading: Icon(icon, size: 26.0,color: AppColor.blue,),
              title: Text(title)
          ),
          const Divider(color: AppColor.grey,),
        ],
      ),
    );
  }
}