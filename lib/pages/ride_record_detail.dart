import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/car_number_tag.dart';

import '../config/color.dart';

class RideRecordDetail extends StatelessWidget {

  RideRecordDetail({Key? key}) : super(key: key);

  String taxiPrice = '290';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('乘車明細'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            Text('2022/12/13 下午 6:43'),
            const SizedBox(height: 30,),
            Text('司機：王小明',),
            Row(
              children: [
                Text('乘車：Toyota Wish'),
                CarNumberTag(carNumber: 'abc-567')
              ],
            ),
            const SizedBox(height: 30,),
            const Text('上車位置',style: TextStyle(fontSize: 14)),
            Text('桃園市桃園區民生路23號', style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            const Text('下車位置',style: TextStyle(fontSize: 14)),
            Text('桃園市桃園區民生路100號', style: TextStyle(fontWeight: FontWeight.bold),),
            const Divider(color: Colors.black,height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('車資',style: TextStyle(fontSize: 14)),
                Text.rich(
                    TextSpan(
                        children: [
                          const TextSpan(text:'\$ ',style: TextStyle(fontSize: 14)),
                          TextSpan(text: taxiPrice, style: TextStyle(color: AppColor.red, fontWeight: FontWeight.bold, fontSize: 26))
                        ]))
              ],
            ),


          ],
        ),
      ),
    );
  }
}
