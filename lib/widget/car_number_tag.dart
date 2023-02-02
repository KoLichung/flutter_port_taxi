import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/const/color.dart';

class CarNumberTag extends StatelessWidget {
  final String carNumber;
  const CarNumberTag({Key? key, required this.carNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColor.lightBlue,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),),
      child: Text(carNumber, style: const TextStyle(fontSize: 14, color: AppColor.lightBlue),),
    );
  }
}
