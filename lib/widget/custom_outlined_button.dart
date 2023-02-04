import 'package:flutter/material.dart';

import '../config/color.dart';

class CustomOutlinedButton extends StatelessWidget {
  final Color color;
  final String title;
  final Function onPressed;

  const CustomOutlinedButton({Key? key,  required this.color, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 6),
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          )
      ),
      child: Text(title,style: TextStyle(color: color),),
      onPressed: (){
        onPressed();
      },
    );
  }
}
