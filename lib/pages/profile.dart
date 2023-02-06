import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/config/color.dart';
import 'package:flutter_port_taxi/pages/edit_profile.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:flutter_port_taxi/widget/custom_profile_text_unit.dart';
import 'package:provider/provider.dart';
import '../config/server_api.dart';
import '../models/user.dart';
import '../notifier_model/user_model.dart';
import 'package:http/http.dart' as http;

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
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const EditProfile()));
              },
            ),
          )],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.account_circle, size: 110, color: AppColor.blue,),
              const SizedBox(height: 60,),
              Consumer<UserModel>(builder: (context, userModel, child) =>
                  CustomProfileTextUnit(
                    icon: Icons.account_circle_outlined,
                    title: userModel.user!.name!,
                  ),
              ),
              Consumer<UserModel>(builder: (context, userModel, child) =>
                  CustomProfileTextUnit(
                    icon: Icons.email_outlined,
                    title: userModel.user!.email!,
                  ),
              ),
              const Spacer(flex: 1,),
              CustomOutlinedButton(
                  color: AppColor.red,
                  title: '刪除帳號',
                  onPressed: () async {
                    final confirmBack = await _showDeleteDialog(context);
                    if(confirmBack){
                      print('here');
                      var userModel = context.read<UserModel>();
                      _deleteUserData(userModel.token!, userModel.user!.id!);
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _showDeleteDialog(BuildContext context) {
    // Init
    AlertDialog dialog = AlertDialog(
      title: const Text("注意!"),
      content: const Text('帳號刪除後，無法取回資料！'),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.blue,
                elevation: 0
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("取消")
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.red,
                elevation: 0
            ),
            onPressed: () {
              Navigator.popAndPushNamed(context, '/log_in');
            },
            child: const Text("確認刪除")
        ),
      ],
    );

    // Show the dialog
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        }
    );
  }

  Future<User?> _deleteUserData(String token,int userId) async {
    String path = '${ServerApi.deleteUser}$userId/';
    try {
      final response = await http.delete(
        ServerApi.standard(path: path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token',
        },
      );

      print(response.body);


    } catch (e) {
      print(e);
    }
    return null;
  }
}
