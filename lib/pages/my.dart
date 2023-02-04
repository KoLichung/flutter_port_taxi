import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/custom_my_page_button.dart';
import 'package:flutter_port_taxi/pages/profile.dart';
import 'package:flutter_port_taxi/pages/ride_record.dart';
import 'package:provider/provider.dart';

import '../notifier_model/user_model.dart';
import 'login.dart';

class My extends StatefulWidget {
  const My({Key? key}) : super(key: key);

  @override
  State<My> createState() => _MyState();
}

class _MyState extends State<My> {


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(197),
        child: AppBar(
          elevation: 0,
          flexibleSpace: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(20,40,20,20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1,),
                const Icon(Icons.account_circle, size: 100, color: Colors.white,),
                const SizedBox(width: 10,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(' 哈囉! ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        Consumer<UserModel>(builder: (context, userModel, child)=> userModel.isLogin()
                            ? Text(userModel.user!.name!, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))
                            : const SizedBox()
                        ),
                        ],
                    ),
                  TextButton(
                    child: const Text('(登出)', style: TextStyle(color: Colors.white),),
                    onPressed: (){
                      var userModel = context.read<UserModel>();
                      userModel.removeUser(context);
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => const LogIn()));
                    }, ),
                ],),
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

