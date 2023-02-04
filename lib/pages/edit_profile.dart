import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/color.dart';
import '../config/server_api.dart';
import '../notifier_model/user_model.dart';
import '../widget/custom_edit_profile_text_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
              child: const Text('儲存', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
              onPressed: (){
                var userModel = context.read<UserModel>();
                _putUpdateProfile(userModel.token!, nameController.text, emailController.text );
                userModel.updateProfile(nameController.text,  emailController.text);
              },
            ),
          )],
      ),
      body: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
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
                const SizedBox(
                  width: 320,
                  height: 40,
                  child: Text('姓名',style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                CustomEditProfileTextField(controller: nameController,),
                const SizedBox(height: 20,),
                const SizedBox(
                  width: 320,
                  height: 40,
                  child: Text('Email',style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                CustomEditProfileTextField(controller: emailController,),
                const SizedBox(height: 20,),
                const SizedBox(
                  width: 320,
                  height: 40,
                  child: Text('舊密碼',style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                CustomEditProfileTextField(
                  isObscureText: true,
                  controller: oldPasswordController,
                ),
                const SizedBox(height: 20,),
                const SizedBox(
                  width: 320,
                  height: 40,
                  child: Text('新密碼',style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 16),),
                ),
                CustomEditProfileTextField(
                  isObscureText: true,
                  controller: newPasswordController,
                ),
               ],
            ),
          ),
        ),
      ),
    );
  }
  Future _putUpdateProfile (String token, String? name, String? email)async{
    String path = ServerApi.userMe;
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("成功更新！"),
            )
        );
      }

    } catch (e){
      print(e);
    }

  }

}
