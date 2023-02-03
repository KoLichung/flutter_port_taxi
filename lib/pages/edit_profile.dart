import 'package:flutter/material.dart';

import '../config/color.dart';
import '../widget/custom_edit_profile_text_field.dart';

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
    nameController.text='JuneWen';
    emailController.text='abc@email.com';
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
              onPressed: (){},
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
}
