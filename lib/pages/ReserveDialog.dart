import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../config/color.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:syncfusion_flutter_core/theme.dart';


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

  TextEditingController pickUpAddressController = TextEditingController();
  TextEditingController dropOffAddressController = TextEditingController();
  final DateRangePickerController _bookingDateController = DateRangePickerController();
  DateTime bookingDate = DateTime.now();
  TimeOfDay bookingTimeTimeOfDay = const TimeOfDay(hour: 09, minute: 0);

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
           // const Text('您的 ATM 繳款訊息如下：'),
           // const Text('p.s 繳款完，請回填後5碼，才能為您對帳喔！'),
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
                     hintText: AppLocalizations.of(context)!.pressRightBtnGetAddress,
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
           Text('預約日期', style: const TextStyle(color: AppColor.blue, fontSize: 12)),
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
           Text('預約時間', style: const TextStyle(color: AppColor.blue, fontSize: 12)),
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
            cancelText: '取消',
            confirmText: '確定',
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

      if(picked.minute > 0 && picked.minute < 15){
        bookingTimeTimeOfDay = TimeOfDay(hour: picked.hour, minute: 0);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("時間自動以30分鐘為單位調整！"),));
      } else if ((picked.minute >= 15 && picked.minute <30) || (picked.minute > 30 && picked.minute <45)){
        bookingTimeTimeOfDay = TimeOfDay(hour: picked.hour, minute: 30);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("時間自動以30分鐘為單位調整！"),));
      } else if (picked.minute >= 45 && picked.minute <= 59) {
        bookingTimeTimeOfDay = TimeOfDay(hour: picked.hour + 1, minute: 0);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("時間自動以30分鐘為單位調整！"),));
      }else{
        bookingTimeTimeOfDay = TimeOfDay(hour: picked.hour, minute: picked.minute);
      }

      setState(() {});
    }
  }

}