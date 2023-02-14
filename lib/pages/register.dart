import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/main.dart';
import '../config/color.dart';
import '../config/server_api.dart';
import '../models/user.dart';
import '../notifier_model/user_model.dart';
import '../widget/custom_fixed_width_elevated_button.dart';
import '../widget/custom_log_in_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';




class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
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
                  hintText: AppLocalizations.of(context)!.name,
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
                  isObscureText: true,
                  icon: Icons.lock_outline,
                  hintText: AppLocalizations.of(context)!.password,
                  controller: passwordController,
                ),
                const Spacer(flex: 2,),
                CustomFixedWidthElevatedButton(
                  color: AppColor.blue,
                  title: AppLocalizations.of(context)!.register,
                  onPressed: (){
                    if(nameController.text == ''||emailController.text ==''||passwordController.text==''){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.enterCompleteInfo),));
                    } else{
                      User user = User(name: nameController.text, email: emailController.text);
                      _postCreateUser(user, passwordController.text);
                      isLoading = true;
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.agreement, style: const TextStyle(fontSize: 12),),
                    GestureDetector(
                      onTap: (){},
                      child: Text(AppLocalizations.of(context)!.termsOfUse, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColor.blue, decoration: TextDecoration.underline, fontSize: 12), ),),
                    Text( ' ${AppLocalizations.of(context)!.and} ', style: const TextStyle(fontSize: 12),),
                    GestureDetector(
                        onTap: (){},
                        child: Text( AppLocalizations.of(context)!.privacyPolicy, style: const TextStyle(fontWeight: FontWeight.bold,color: AppColor.blue, decoration: TextDecoration.underline, fontSize: 12), )),
                  ],
                ),
                const SizedBox(height: 10,),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/log_in');
                    },
                    child: Text(AppLocalizations.of(context)!.back)
                ),
                const Spacer(flex: 1,)
              ],
            ),
            isLoading? const CircularProgressIndicator() : const SizedBox(),
          ]
        ),
      ),
    );
  }

  Future _postCreateUser(User user, String password) async {
    var userModel = context.read<UserModel>();
    String path = ServerApi.userCreate;
    try {
      Map queryParameters = {
        'name' : user.name,
        'email': user.email,
        'password': password,
      };
      // print(queryParameters);
      final response = await http.post(ServerApi.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',

          },
          body: jsonEncode(queryParameters)
      );
      // print(response.body);

      if(response.statusCode == 201){


        // Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
        // User theUser = User.fromJson(map);
        // userModel.setUser(theUser);

        String? token = await _getUserToken(user.email!,password);
        userModel.token = token!;

        User? theUser = await _getUserData(token);
        userModel.setUser(theUser!);

        // Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.popUntil(context, ModalRoute.withName('/main'));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const TabPage()), (Route<dynamic> route) => false, );


      }else{
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.wrongEmail)));
      }


    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future<String?> _getUserToken(String email, String password) async {
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
        return token;
      }else{
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法取得Token！"),));
        return null;
      }
    } catch (e) {
      print(e);
      return null;
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

      return theUser;

    } catch (e) {
      print(e);

      // return null;
      // return User(phone: '0000000000', name: 'test test', isGottenLineId: false, token: '4b36f687579602c485093c868b6f2d8f24be74e2',isOwner: false);

    }
    return null;
  }

}
