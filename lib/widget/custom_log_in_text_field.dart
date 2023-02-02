import 'package:flutter/material.dart';

import '../const/color.dart';
class CustomLogInTextField extends StatelessWidget {

  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;

  const CustomLogInTextField({super.key, required this.icon, required this.hintText, required this.controller, this.isObscureText = false, });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 320,
      height: 50,
      padding: const EdgeInsets.fromLTRB(10,0,10,12),
      decoration:BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColor.blue,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Icon(icon, size: 26.0,color: AppColor.blue,),
        ),

        title: TextField(
          controller: controller,
          obscureText: isObscureText,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintText == 'email' ? const TextStyle(height: 1.5) : null,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}