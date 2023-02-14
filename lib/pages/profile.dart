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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
              child: Text(AppLocalizations.of(context)!.edit, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,)),
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
                  (userModel.user!=null)?
                  CustomProfileTextUnit(
                    icon: Icons.account_circle_outlined,
                    title: userModel.user!.name!,
                  )
                  :
                  Container(),
              ),
              Consumer<UserModel>(builder: (context, userModel, child) =>
                  (userModel.user!=null)?
                  CustomProfileTextUnit(
                    icon: Icons.email_outlined,
                    title: userModel.user!.email!,
                  )
                      :
                  Container(),
              ),
              const Spacer(flex: 1,),
              CustomOutlinedButton(
                  color: AppColor.red,
                  title: AppLocalizations.of(context)!.deleteAccount,
                  onPressed: () {
                    _showDeleteDialog(context);
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
      title: Text(AppLocalizations.of(context)!.warning),
      content: Text(AppLocalizations.of(context)!.deleteAccountNotice),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.blue,
                elevation: 0
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child:Text(AppLocalizations.of(context)!.cancel)
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.red,
                elevation: 0
            ),
            onPressed: () {
              var userModel = context.read<UserModel>();
              _deleteUserData(userModel.token!, userModel.user!.id!);
            },
            child: Text(AppLocalizations.of(context)!.delete)
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

      // print(response.body);

      if(response.body.contains('delete user')){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("成功刪除使用者!"),));
        var userModel = context.read<UserModel>();
        Navigator.popAndPushNamed(context, '/log_in');
        userModel.removeUser(context);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("未成功刪除使用者!請聯繫管理員~"),));
      }

    } catch (e) {
      print(e);
    }
    return null;
  }
}
