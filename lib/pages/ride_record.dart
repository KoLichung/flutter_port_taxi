import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/pages/ride_record_detail.dart';

import '../widget/custom_my_page_button.dart';

class RideRecord extends StatefulWidget {
  const RideRecord({Key? key}) : super(key: key);

  @override
  State<RideRecord> createState() => _RideRecordState();
}

class _RideRecordState extends State<RideRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('乘車紀錄'),
      ),
      body: SafeArea(
          child: Column(
            children: [
              CustomMyPageButton(
                title: '2022年12月5日  林森路 70號',
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>RideRecordDetail()));
                },

              ),
            ],
          )
      ),
    );
  }
}
