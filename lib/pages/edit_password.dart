import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:provider/provider.dart';
import '../config/color.dart';
import '../config/server_api.dart';
import '../notifier_model/user_model.dart';
import '../widget/custom_edit_profile_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EditPassword extends StatefulWidget {
  const EditPassword({Key? key}) : super(key: key);

  @override
  State<EditPassword> createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {

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
              child: Text(AppLocalizations.of(context)!.save, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
              onPressed: (){
                var userModel = context.read<UserModel>();
                if(oldPasswordController.text =='' ){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請輸入舊密碼！"),));
                }else if(newPasswordController.text == ''){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請輸入新密碼！"),));
                }else{
                  _putUpdateUserPassword(userModel.token!, oldPasswordController.text, newPasswordController.text);
                }
              },
            ),
          )],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 110, color: AppColor.blue,),
              const SizedBox(height: 60,),
              SizedBox(
                width: 320,
                height: 40,
                child: Text(AppLocalizations.of(context)!.oldPassword,style: const TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
              ),
              CustomEditProfileTextField(
                isObscureText: true,
                controller: oldPasswordController,
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 320,
                height: 40,
                child: Text(AppLocalizations.of(context)!.newPassword, style: const TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
              ),
              CustomEditProfileTextField(
                isObscureText: true,
                controller: newPasswordController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _putUpdateUserPassword(String token, String oldPassword, String newPassword) async {
    String path = ServerApi.userUpdatePassword;

    try {
      Map queryParameters = {
        'new_password': newPassword,
        'old_password': oldPassword,
      };

      final response = await http.put(
          ServerApi.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token $token',
          },
          body: jsonEncode(queryParameters)
      );

      print(response.body);

      Map<String, dynamic> map = json.decode(utf8.decode(response.body.runes.toList()));
      if(map['message']!=null){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("成功更新密碼！"),));
        Navigator.pop(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("無法更新資料 密碼有誤！"),));
      }

    } catch (e) {
      print(e);
      return "error";
    }
  }

}
