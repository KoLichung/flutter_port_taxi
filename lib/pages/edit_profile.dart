import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/models/user.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:provider/provider.dart';
import '../config/color.dart';
import '../config/server_api.dart';
import '../notifier_model/user_model.dart';
import '../widget/custom_edit_profile_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userModel = context.read<UserModel>();
    nameController.text = userModel.user!.name!;
    emailController.text = userModel.user!.email!;
  }

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
              child: Text(AppLocalizations.of(context)!.save, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
              onPressed: (){
                var userModel = context.read<UserModel>();
                _putUpdateProfile(userModel.token!, nameController.text, emailController.text );
              },
            ),
          )],
      ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle, size: 110, color: AppColor.blue,),
                const SizedBox(height: 60,),
                SizedBox(
                  width: 320,
                  height: 40,
                  child: Text(AppLocalizations.of(context)!.name,style: const TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                CustomEditProfileTextField(controller: nameController,),
                const SizedBox(height: 20,),
                const SizedBox(
                  width: 320,
                  height: 40,
                  child: Text('Email',style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                CustomEditProfileTextField(controller: emailController,),
                // const SizedBox(height: 20,),
                const Spacer(),
                CustomOutlinedButton(
                    color: AppColor.blue,
                    title: AppLocalizations.of(context)!.editPassword,
                    onPressed: (){
                      Navigator.pushNamed(context, '/edit_password');
                    }),
              ],
            ),
          ),
        ),
    );
  }
  Future _putUpdateProfile (String token, String? name, String? email)async{
    String path = ServerApi.userMe;
    var userModel = context.read<UserModel>();
    try{
      final bodyParams ={
        'name':name,
        'email': email,
      };
      final response = await http.put(ServerApi.standard(path:path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'token $token'
        },
        body: jsonEncode(bodyParams),
      );
      print(response.body);
      if(response.statusCode == 200){
        print('success update profile');
        userModel.updateProfile(nameController.text,  emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新！")));
        Navigator.pop(context);
      }
    } catch (e){
      print(e);
    }
  }

}
