import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config/color.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

import '../config/server_api.dart';
import '../notifier_model/user_model.dart';


class FeedbackDialog extends StatefulWidget {

  final int caseId;

  const FeedbackDialog({Key? key, required this.caseId});

  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}


class _FeedbackDialogState extends State<FeedbackDialog>{

  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        color: AppColor.blue,
        child: const Text(
          '乘車回饋',
          style: TextStyle(color: Colors.white),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('感謝您的搭乘，請給我們回饋或建議：'),
            const SizedBox(height: 10,),
            TextField(
              maxLines: 8,
              controller: feedbackController,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1,color: AppColor.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1,color: AppColor.grey),
                ),
                hintText: '請輸入您的回饋或意見',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                onPressed: ()async{
                  _putCaseFeedback(widget.caseId, feedbackController.text);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    elevation: 0,
                    backgroundColor: AppColor.lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),
                child: Text('確認送出'),
              ),
            ),
            // Center(
            //   child: CustomOutlinedButton(
            //       color: Colors.green,
            //       title: "確認送出",
            //       onPressed: () async {
            //     _putCaseFeedback(widget.caseId, feedbackController.text);
            //       }),
            // ),
            Center(
              child:TextButton(
                child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: AppColor.red,
    );
  }


  Future _putCaseFeedback(int caseId, String feedback) async {
    var userModel = context.read<UserModel>();
    String path = ServerApi.putCaseFeedback;

    try {
      final queryParams = {
        'case_id': caseId.toString(),
      };

      final bodyParameters = {
        'feedback': feedback,
      };
      print(bodyParameters);

      final response = await http.put(ServerApi.standard(path: path,queryParameters: queryParams),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${userModel.token!}'
          },
          body: jsonEncode(bodyParameters)
      );

      _printLongString(response.body);

      if(response.statusCode == 200){
        print('成功回饋');
        Navigator.pop(context);
      }else{
        print(response.statusCode);
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text('上傳錯誤，請稍後再試~')));
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }

  void _printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) => print(match.group(0)));
  }

}