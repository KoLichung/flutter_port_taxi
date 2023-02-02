import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/const/color.dart';
import 'package:flutter_port_taxi/pages/edit_profile.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:flutter_port_taxi/widget/custom_profile_text_unit.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[50],
        leading: const BackButton(color: AppColor.blue,),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              child: const Text('修改資料', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile()));
              },
            ),
          )],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 60,),
              const CustomProfileTextUnit(
                  icon: Icons.account_circle_outlined,
                  title: 'JuneWen',
              ),
              const CustomProfileTextUnit(
                  icon: Icons.email_outlined,
                  title: 'abc@email.com',
              ),
              const CustomProfileTextUnit(
                  icon: Icons.lock_outline,
                  title: '********',
              ),
              const Spacer(flex: 1,),
              CustomOutlinedButton(color: AppColor.red, title: '刪除帳號', onPressed: (){}),
            ],
          ),
        ),
      ),
    );
  }
}
