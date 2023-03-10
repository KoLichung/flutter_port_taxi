import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/config/color.dart';
import 'package:flutter_port_taxi/main.dart';
import 'package:flutter_port_taxi/pages/register.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/server_api.dart';
import '../models/user.dart';
import '../notifier_model/user_model.dart';
import '../widget/custom_fixed_width_elevated_button.dart';
import '../widget/custom_log_in_text_field.dart';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

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
              hintText: AppLocalizations.of(context)!.password,
              controller: passwordController,
              isObscureText: true,
            ),
            // Container(
            //   alignment: Alignment.centerRight,
            //   width: 320,
            //   child: TextButton(
            //     child: const Text('????????????'),
            //     onPressed: () {  },
            //
            //   ),
            // ),
            const Spacer(flex: 2,),
            CustomFixedWidthElevatedButton(
              color: AppColor.blue,
              title: AppLocalizations.of(context)!.logIn,
              onPressed: () async {
                  _emailLogIn(context, emailController.text, passwordController.text);
                },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.dontHaveAccount),
                TextButton(
                  child: Text(AppLocalizations.of(context)!.register, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                  onPressed: (){
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Register()), (Route<dynamic> route) => false, );
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Register()));
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

  Future<void> _emailLogIn(BuildContext context, String email, String password) async {
    var userModel = context.read<UserModel>();
    String path = ServerApi.userToken;
    try {
      Map queryParameters = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
          ServerApi.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(queryParameters)
      );

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['token']!=null){

        String token = map['token'];
        print('server token $token');

        userModel.token = token;
        User? user = await _getUserData(token);
        userModel.setUser(user!);

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TabPage()), (Route<dynamic> route) => false, );
      }else{
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.emailPasswordError),
            )
        );
      }

    }catch(e){
      print(e);
    }
  }

  Future<User?> _getUserData(String token) async {
    String path = ServerApi.userMe;
    try {
      final response = await http.get(
        ServerApi.standard(path: path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
      );

      print(response.body);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      User theUser = User.fromJson(map);

      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('user_token', token);
      //
      // _httpPostFCMDevice();

      return theUser;

    } catch (e) {
      print(e);
    }
    return null;
  }

}
