import 'package:flutter/material.dart';

class CustomFixedWidthElevatedButton extends StatelessWidget {

  final String title;
  final Color color;
  final Function onPressed;
  const CustomFixedWidthElevatedButton({Key? key, required this.title, required this.color, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 320,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 6),
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25)
          ),),
        child: Center(child: Text(title, style: const TextStyle(fontSize: 18),)),
        onPressed: (){onPressed();},
      ),
    );
  }
}
