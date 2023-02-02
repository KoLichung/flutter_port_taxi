import 'package:flutter/material.dart';
import '../const/color.dart';
import '../widget/custom_fixed_width_elevated_button.dart';
import '../widget/custom_log_in_text_field.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameController = TextEditingController();
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
              icon: Icons.account_circle_outlined,
              hintText: '使用者姓名',
              controller: nameController,
            ),
            const SizedBox(height: 15,),
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
            const Spacer(flex: 2,),
            CustomFixedWidthElevatedButton(
              color: AppColor.blue,
              title: '註冊',
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (Route<dynamic> route) => false, );
              },
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('註冊即代表您同意 ', style: TextStyle(fontSize: 14),),
                GestureDetector(
                  onTap: (){},
                  child: const Text('會員條款', style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.blue, decoration: TextDecoration.underline, fontSize: 14), ),),
                const Text( ' 與 ', style: TextStyle(fontSize: 14),),
                GestureDetector(
                  onTap: (){},
                  child: const Text( '隱私權政策', style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.blue, decoration: TextDecoration.underline, fontSize: 14), )),
              ],
            ),
            const Spacer(flex: 1,)
          ],
        ),
      ),
    );
  }
}
