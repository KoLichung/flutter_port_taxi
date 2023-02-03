import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/config/color.dart';
import 'package:flutter_port_taxi/pages/register.dart';

import '../widget/custom_edit_profile_text_field.dart';
import '../widget/custom_fixed_width_elevated_button.dart';
import '../widget/custom_log_in_text_field.dart';
import 'home.dart';
import 'my.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                width: 175,
                height: 175,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 60,),
            CustomLogInTextField(
              icon: Icons.email_outlined,
              hintText: 'email',
              controller: emailController,
            ),
            const SizedBox(height: 15,),
            CustomLogInTextField(
              icon: Icons.lock_outline,
              hintText: '密碼',
              controller: passwordController,
            ),
            Container(
              alignment: Alignment.centerRight,
              width: 320,
              child: TextButton(
                child: const Text('忘記密碼'),
                onPressed: () {  },

              ),
            ),
            const Spacer(flex: 2,),
            CustomFixedWidthElevatedButton(

              color: AppColor.blue,
              title: '登入',
              onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> Home()));
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (Route<dynamic> route) => false, );

              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('還沒有帳號？'),
                TextButton(
                  child: const Text('點這裡註冊', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Register()), (Route<dynamic> route) => false, );
                  },
                ),

              ],
            ),
            const Spacer(flex: 1,)



          ],


        ),
      ),
    );
  }
}
