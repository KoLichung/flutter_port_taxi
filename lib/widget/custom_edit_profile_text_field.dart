import 'package:flutter/material.dart';

import '../const/color.dart';



class CustomEditProfileTextField extends StatelessWidget {

  final TextEditingController controller;
  final bool isObscureText;


  const CustomEditProfileTextField({super.key,required this.controller,this.isObscureText = false, });


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 320,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      decoration:BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: AppColor.blue,
          width: 1,
        ),
      ),
      child: TextField(
          controller: controller,
          obscureText: isObscureText,
          decoration: const InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
    );
  }
}
