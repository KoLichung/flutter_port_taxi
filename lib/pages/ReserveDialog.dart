import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config/color.dart';

class ReserveDialog extends StatefulWidget {
  final String onAddress;
  final String offAddress;

  const ReserveDialog({Key? key, required this.onAddress, required this.offAddress});

  @override
  _ReserveDialogState createState() => _ReserveDialogState();
}

class _ReserveDialogState extends State<ReserveDialog>{

  @override
  Widget build(BuildContext context) {
   return AlertDialog(
     titlePadding: const EdgeInsets.all(0),
     title: Container(
       width: 300,
       padding: const EdgeInsets.all(10),
       color: AppColor.red,
       child: const Text(
         '預約叫車',
         style: TextStyle(color: Colors.white),
       ),
     ),
     contentPadding: const EdgeInsets.all(0),
     content: Container(
       color: Colors.white,
       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         mainAxisSize: MainAxisSize.min,
         children: [
           const Text('您的 ATM 繳款訊息如下：'),
           const Text('p.s 繳款完，請回填後5碼，才能為您對帳喔！'),
           SizedBox(height: 10,),
           Center(
             child: CustomOutlinedButton(color: Colors.green, title: "確認，並聯繫 WhatsApp 客服", onPressed: () async {
               // send message to specific someone
               var whatsappUrl = "https://wa.me/+886912585506?text=Hello";
               if (!await launchUrl(Uri.parse(whatsappUrl))) {
                 throw Exception('Could not launch $whatsappUrl');
               }
               Navigator.pop(context);
             }),
           ),
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



}