import 'package:flutter/material.dart';

class CustomMyPageButton extends StatelessWidget {
  final String title;
  final Function onPressed;


  const CustomMyPageButton({super.key,  required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: ListTile(
                title: Text(title, style: const TextStyle(fontSize: 16),),
                trailing: const SizedBox(
                  width: 30,
                  child: Icon(Icons.arrow_forward_ios, color: Color(0xff292D32),),
                ),
              )),
          onTap: (){
            onPressed();
          },
        ),
        const Divider(
          color: Color(0xffCCCCCC),
          thickness: 0.5,
        ),
      ],
    );
  }
}