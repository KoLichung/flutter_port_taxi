import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/custom_my_page_button.dart';
import 'package:flutter_port_taxi/pages/profile.dart';
import 'package:flutter_port_taxi/pages/ride_record.dart';

import 'login.dart';

class My extends StatefulWidget {
  const My({Key? key}) : super(key: key);

  @override
  State<My> createState() => _MyState();
}

class _MyState extends State<My> {
  @override
  Widget build(BuildContext context) {
    String userName = 'June';

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(197),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1,),
                const Icon(Icons.account_circle, size: 100, color: Colors.white,),
                const SizedBox(width: 30,),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: ' 哈囉! ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                      TextSpan(text: userName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800))
                    ]
                  ),
                ),
                TextButton(
                  child: const Text('(登出)', style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LogIn()));
                  }, ),
                const Spacer(flex: 2,),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5,),
          CustomMyPageButton(
            title: '個人資料',
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=> const Profile()));
            },
          ),
          CustomMyPageButton(
            title: '乘車紀錄',
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=> const RideRecord()));
              },
          ),
        ],
      ),
    );
  }
}

