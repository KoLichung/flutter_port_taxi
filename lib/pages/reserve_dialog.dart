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
import 'dart:ui';
import 'package:http/http.dart' as http;

import '../config/server_api.dart';
import '../notifier_model/user_model.dart';


class ReserveDialog extends StatefulWidget {
  final String onAddress;
  final String offAddress;

  const ReserveDialog({Key? key, required this.onAddress, required this.offAddress});

  @override
  _ReserveDialogState createState() => _ReserveDialogState();
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

class _ReserveDialogState extends State<ReserveDialog>{

  String geocodingKey = 'AIzaSyCdP86OffSMXL82nbHA0l6K0W2xrdZ5xLk';

  TextEditingController pickUpAddressController = TextEditingController();
  TextEditingController dropOffAddressController = TextEditingController();
  final DateRangePickerController _bookingDateController = DateRangePickerController();
  DateTime bookingDate = DateTime.now();
  TimeOfDay bookingTimeTimeOfDay = TimeOfDay(hour: DateTime.now().hour+2, minute: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickUpAddressController.text = widget.onAddress;
    dropOffAddressController.text = widget.offAddress;
  }

  @override
  Widget build(BuildContext context) {
   return AlertDialog(
     titlePadding: const EdgeInsets.all(0),
     title: Container(
       width: 300,
       padding: const EdgeInsets.all(10),
       color: AppColor.red,
       child: Text(
         AppLocalizations.of(context)!.reserve_order,
         style: const TextStyle(color: Colors.white),
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
           Text(AppLocalizations.of(context)!.pickUpAddress, style: const TextStyle(color: AppColor.blue, fontSize: 12)),
           const SizedBox(height: 2,),
           Container(
               padding: const EdgeInsets.fromLTRB(10,0,10,0),
               height: 35,
               decoration: BoxDecoration(
                   color: AppColor.lightGrey,
                   borderRadius: BorderRadius.circular(6)
               ),
               child: TextField(
                 style: const TextStyle(fontSize: 14),
                 controller: pickUpAddressController,
                 decoration: InputDecoration(
                     contentPadding: const EdgeInsets.only(bottom: 14),
                     hintStyle: const TextStyle(fontSize: 14),
                     hintText: AppLocalizations.of(context)!.pickUpAddress,
                     border: InputBorder.none),
               )
           ),
           const SizedBox(height: 5,),
           Text(AppLocalizations.of(context)!.dropOffAddress, style: const TextStyle(color: AppColor.blue, fontSize: 12)),
           const SizedBox(height: 2,),
           Container(
               padding: const EdgeInsets.fromLTRB(10,0,10,0),
               height: 35,
               decoration: BoxDecoration(
                   color: AppColor.lightGrey,
                   borderRadius: BorderRadius.circular(6)
               ),
               child: TextField(
                 style: const TextStyle(fontSize: 14),
                 controller: dropOffAddressController,
                 decoration: InputDecoration(
                     contentPadding: const EdgeInsets.only(bottom: 14),
                     hintStyle: const TextStyle(fontSize: 14),
                     hintText: AppLocalizations.of(context)!.dropOffAddress,
                     border: InputBorder.none
                 ),
               )
           ),
           const SizedBox(height: 10,),
           Text(AppLocalizations.of(context)!.bookingDate, style: const TextStyle(color: AppColor.blue, fontSize: 12)),
           const SizedBox(height: 2,),
           Container(
             height: 35,
             padding: const EdgeInsets.symmetric(horizontal: 10),
             decoration: BoxDecoration(
                 color: AppColor.lightGrey,
                 borderRadius: BorderRadius.circular(6)
             ),
             child: Row(
               children: [
                 GestureDetector(
                     onTap: (){
                       showDialog<Widget>(
                           context: context,
                           builder: (BuildContext context) {
                             return bookingDatePicker();
                           });
                     },
                     child:Text(DateFormat('MM/dd').format(bookingDate),style: const TextStyle(color:Colors.black54),),
                 ),
               ],
             ),
           ),
           const SizedBox(height: 10,),
           Text(AppLocalizations.of(context)!.bookingTime, style: const TextStyle(color: AppColor.blue, fontSize: 12)),
           const SizedBox(height: 2,),
           Container(
             height: 35,
             padding: const EdgeInsets.symmetric(horizontal: 10),
             decoration: BoxDecoration(
                 color: AppColor.lightGrey,
                 borderRadius: BorderRadius.circular(6)
             ),
             child: Row(
               children: [
                 GestureDetector(
                   onTap: (){
                     bookingTimePicker(context);
                   },
                   child:Text(bookingTimeTimeOfDay.to24hours(),style: const TextStyle(color:Colors.black54),),
                 ),
               ],
             ),
           ),
           const SizedBox(height: 10,),
           Center(
             child: CustomOutlinedButton(color: Colors.green, title: AppLocalizations.of(context)!.confirmAndContactCustomerService, onPressed: () async {
               _postCreateCase();
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

  bookingDatePicker(){
    return Center(
      child: SizedBox(
        height: 460,
        width: 380,
        child: SfDateRangePickerTheme(
          data: SfDateRangePickerThemeData(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          child: SfDateRangePicker(
            controller: _bookingDateController,
            view: DateRangePickerView.month,
            monthViewSettings: const DateRangePickerMonthViewSettings(
              firstDayOfWeek: 7,
            ),
            allowViewNavigation: false,
            headerHeight: 60,
            headerStyle: const DateRangePickerHeaderStyle(
                backgroundColor: AppColor.blue,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 22,
                  letterSpacing: 1,
                  color: Colors.white,
                )),
            selectionMode: DateRangePickerSelectionMode.single,
            minDate: DateTime.now(),
            onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
              setState(() {
                if (args.value is DateTime) {
                  bookingDate = args.value;
                }
              });
            },
            showActionButtons: true,
            cancelText: AppLocalizations.of(context)!.cancel,
            confirmText: AppLocalizations.of(context)!.ok,
            onSubmit: (Object? value, ) {
              // print('chosen duration: $value');
              Navigator.pop(context);
            },
            onCancel: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Future<void> bookingTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: bookingTimeTimeOfDay,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,);
      },);
    if (picked != null && picked != bookingTimeTimeOfDay) {
      bookingTimeTimeOfDay = TimeOfDay(hour: picked.hour, minute: picked.minute);
      setState(() {});
    }
  }

  Future _postCreateCase() async {
    var userModel = context.read<UserModel>();
    String path = ServerApi.postNewCase;

    String datString = DateFormat('yyyy-MM-dd').format(bookingDate);
    String timeString = bookingTimeTimeOfDay.to24hours();

    String convertAddress = '';
    if (dropOffAddressController.text!=''){
      if(window.locale.languageCode == 'zh'){
        convertAddress = await _getConvertAddress('en', dropOffAddressController.text);
      }else{
        convertAddress = await _getConvertAddress('zh-TW', dropOffAddressController.text);
      }
    }

    String onConvertAddress = '';
    if (pickUpAddressController.text!=''){
      if(window.locale.languageCode == 'zh'){
        onConvertAddress = await _getConvertAddress('en', pickUpAddressController.text);
      }else{
        onConvertAddress = await _getConvertAddress('zh-TW', pickUpAddressController.text);
      }
    }

    try {
      final bodyParameters = {
        'case_type': 'reserve',
        'reserve_date_time': '$datString $timeString',
        'on_address' : window.locale.languageCode == 'zh' ? pickUpAddressController.text : onConvertAddress,
        'off_address': window.locale.languageCode == 'zh' ? dropOffAddressController.text : convertAddress,
        'is_english': userModel.isEngDriverNeeded,
        'on_address_en': window.locale.languageCode == 'en' ? pickUpAddressController.text : onConvertAddress,
        'off_address_en': window.locale.languageCode == 'en' ? dropOffAddressController.text : convertAddress,
      };
      print(bodyParameters);

      final response = await http.post(ServerApi.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${userModel.token!}'
          },
          body: jsonEncode(bodyParameters)
      );

      print(response.body);

      if(response.statusCode == 200){
        print('成功叫車');
        // send message to specific someone
        String text = "${AppLocalizations.of(context)!.hiIAm} ${userModel.user!.name} ${AppLocalizations.of(context)!.iBookedACar}";
        var whatsappUrl = "https://wa.me/+886912585506?text=$text";
        if (!await launchUrl(Uri.parse(whatsappUrl))) {
          throw Exception('Could not launch $whatsappUrl');
        }

        userModel.dropOffAddressController.text = '';
        userModel.pickUpAddressController.text = '';

        Navigator.pop(context);
      }else{
        print(response.statusCode);
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.addressWrong)));
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future _getConvertAddress(String outPutLanguage, String inPutLanguageAddress) async {
    //outPutLanguage = zh-TW / en
    String path = '${ServerApi.geoCodeApi}?address=$inPutLanguageAddress&key=$geocodingKey&language=$outPutLanguage';
    print(path);
    try {
      final response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print(data['status']);
        print('this is convert address: ' + data['results'][0]['formatted_address']);
        return data['results'][0]['formatted_address'];
      }
    } catch (e) {
      print(e);
      return inPutLanguageAddress;
    }
  }

}