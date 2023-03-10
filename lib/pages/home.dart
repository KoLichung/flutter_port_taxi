import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/pages/feedback_dialog.dart';
import 'package:flutter_port_taxi/pages/reserve_dialog.dart';
import 'package:flutter_port_taxi/widget/car_number_tag.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../config/color.dart';
import '../config/server_api.dart';
import '../models/ride_case.dart';
import '../notifier_model/user_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String geocodingKey = 'AIzaSyCdP86OffSMXL82nbHA0l6K0W2xrdZ5xLk';

  double? currentLat;
  double? currentLong;

  Timer? _taskTimer;

  bool isFeedbackDialogShowing = false;

  void _getUserLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      var userModel = context.read<UserModel>();
      userModel.currentPosition = LatLng(position.latitude, position.longitude);
      currentLat = position.latitude;
      currentLong = position.longitude;
      print('currentLat: $currentLat');
      print('currentLong: $currentLong');
    });
  }

  void _liveLocation(){
    LocationSettings locationSettings = const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 100,);
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position){
      currentLat = position.latitude;
      currentLong= position.longitude;
    });
  }

  @override
  void initState() {
    var userModel = context.read<UserModel>();
    super.initState();
    _getUserLocation();

    if(userModel.currentCaseId != null){
      _taskTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        getCurrentCaseState(userModel.currentCaseId!);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if(_taskTimer!=null){
      print('cancel timer');
      _taskTimer!.cancel();
      _taskTimer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(AppLocalizations.of(context)!.hello);

    return Scaffold(
      body: Center(
        child: Consumer<UserModel>(builder: (context, userModel, child) =>
          (userModel.currentPosition==null)
              ? const CircularProgressIndicator(color: AppColor.blue,)
              : GoogleMap(
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: userModel.currentPosition!,
                    zoom: 16,
                  ),
                ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255,253,252,252),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: 280,
        child: Consumer<UserModel>(builder: (context, userModel, child){
          return statusCaller(userModel.statusCallerIndex);
        }),
      ),
    );
  }

  callTaxiLayout(){
    var userModel = context.read<UserModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.pickUpAddress, style: const TextStyle(color: AppColor.blue, fontSize: 12)),
        const SizedBox(height: 2,),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                  padding: const EdgeInsets.fromLTRB(10,0,10,0),
                  height: 35,
                  decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: TextField(
                    enabled: userModel.isTextFieldEnable,
                    style: const TextStyle(fontSize: 14),
                    controller: userModel.pickUpAddressController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(bottom: 14),
                        hintStyle: const TextStyle(fontSize: 14),
                        hintText: AppLocalizations.of(context)!.pressRightBtnGetAddress,
                        border: InputBorder.none),
                  )
              ),
            ),
            const SizedBox(width: 10,),
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        elevation: 0,
                        backgroundColor: AppColor.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    onPressed: userModel.isAllowGetLocation == true
                        ? (){
                              getHttpConvertToZhOnAddress(currentLat!, currentLong!);
                              getHttpConvertToEngOnAddress(currentLat!, currentLong!);
                              _liveLocation();
                          }
                        : null,
                    child: Text(AppLocalizations.of(context)!.currentAddress)
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 5,),
        Text(AppLocalizations.of(context)!.dropOffAddress, style: const TextStyle(color: AppColor.blue, fontSize: 12)),
        const SizedBox(height: 2,),
        Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.fromLTRB(10,0,10,0),
                height: 35,
                decoration: BoxDecoration(
                    color: AppColor.lightGrey,
                    borderRadius: BorderRadius.circular(6)
                ),
                child: TextField(
                  enabled: userModel.isTextFieldEnable,
                  controller: userModel.dropOffAddressController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(bottom: 14),
                    hintStyle: const TextStyle(fontSize: 14),
                    hintText: AppLocalizations.of(context)!.dropOffAddress,
                      border: InputBorder.none
                  ),
                )
            ),
          ],
        ),
        const SizedBox(height: 10,),
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                visualDensity: VisualDensity.comfortable,
                value: userModel.isEngDriverNeeded,
                onChanged: userModel.isCallTaxiClicked
                    ? null
                    :  (bool? value) {
                        setState(() {
                          userModel.isEngDriverNeeded = value!;
                          print('isEngDriverNeeded: ${userModel.isEngDriverNeeded}');
                        });
                },),
            ),
            const SizedBox(width: 10,),
            const Text('English speaking driver required',style: TextStyle(color: AppColor.blue, fontSize: 14) ),
          ],
        ),
        const SizedBox(height: 10,),
        SizedBox(
          width: double.infinity,
          height: 35,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColor.lightBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                )
            ),
            onPressed: userModel.isCallTaxiClicked
                ? null //this null is to disable button
                :(){
                      if(userModel.pickUpAddressController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.enterPickUpAddress),));
                      } else {
                        setState(() {
                          userModel.isCallTaxiClicked = true;
                          userModel.isAllowGetLocation = false;
                          userModel.isTextFieldEnable = false;
                          _postCreateCase();
                        });
                      }
                  },
            child: Text( userModel.isCallTaxiClicked == false ? AppLocalizations.of(context)!.order : AppLocalizations.of(context)!.searchingForDrivers, style: const TextStyle(fontSize: 18),),
          ),
        ),
        const SizedBox(height: 10,),
        SizedBox(
          width: double.infinity,
          height: 35,
          child: userModel.isCallTaxiClicked
              ? CustomOutlinedButton(
            onPressed:() async {
              var whatsappUrl = "https://wa.me/+886912585506";
              if (!await launchUrl(Uri.parse(whatsappUrl))) {
                throw Exception('Could not launch $whatsappUrl');
              }
            },
            color:  Colors.green,
            title: AppLocalizations.of(context)!.contactCustomerService,
          )
              : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColor.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    )
                ),
            onPressed:() async {
              var userModel = context.read<UserModel>();
              final confirmBack = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ReserveDialog(
                        onAddress: userModel.pickUpAddressController.text,
                        offAddress: userModel.dropOffAddressController.text);
                  });
            },
            child: Text( AppLocalizations.of(context)!.reserve_order, style: const TextStyle(fontSize: 18),),
          ),
        ),
      ],
    );
  }

  waitingTaxiLayout(){
    var userModel = context.read<UserModel>();
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Spacer(flex: 1,),
          Text('${AppLocalizations.of(context)!.driver} ${userModel.rideCase?.driverName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 10,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text(userModel.rideCase!.carModel!, style: const TextStyle(fontWeight: FontWeight.bold),),
            CarNumberTag(carNumber:userModel.rideCase!.carIdNumber! )
          ],),
          const SizedBox(height: 10,),
          Text.rich(
              TextSpan(
                  children: [
                    TextSpan(text:'${userModel.rideCase!.driverName!} ${AppLocalizations.of(context)!.driverOnTheWay}', style: const TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold)),
                    TextSpan(text: '${userModel.rideCase?.expectMinutes.toString()} ', style: const TextStyle(color: AppColor.red, fontWeight: FontWeight.bold)),
                    TextSpan(text:  AppLocalizations.of(context)!.arrivingMinutes, style: const TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold)),
                  ]
              )),
          const SizedBox(height: 10,),
          Flexible(child: Text('${AppLocalizations.of(context)!.pickUpAddress}???${userModel.pickUpAddressController.text}')),
          // const Spacer(flex: 1,),
          const SizedBox(height: 10,),
          userModel.isCallTaxiClicked
              ? SizedBox(
                width: double.infinity,
                height: 35,
                child: CustomOutlinedButton(
                          onPressed:() async {
                              var whatsappUrl = "https://wa.me/+886912585506";
                              if (!await launchUrl(Uri.parse(whatsappUrl))) {
                                throw Exception('Could not launch $whatsappUrl');
                              }
                          },
                          color:  Colors.green,
                          title: AppLocalizations.of(context)!.contactCustomerService,
                        ),
                            )
              :const SizedBox()
        ],
      ),
    );
  }

  inTaxiLayout(){
    var userModel = context.read<UserModel>();
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Spacer(flex: 1,),
          Text('${AppLocalizations.of(context)!.driver}${userModel.rideCase?.driverName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 10,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userModel.rideCase!.carModel!, style: const TextStyle(fontWeight: FontWeight.bold),),
              CarNumberTag(carNumber: userModel.rideCase!.carIdNumber!)
            ],),
          const SizedBox(height: 10,),
          Text('${AppLocalizations.of(context)!.pickUpAddress}???${userModel.pickUpAddressController.text}'),
          const SizedBox(height: 10,),
          userModel.dropOffAddressController.text.isNotEmpty
              ? Text('${AppLocalizations.of(context)!.dropOffAddress}???${userModel.dropOffAddressController.text}')
              : Text('${AppLocalizations.of(context)!.dropOffAddress}???'),
          // const Spacer(flex: 1,),
          const SizedBox(height: 10,),
          userModel.isCallTaxiClicked
              ? SizedBox(
            width: double.infinity,
            height: 35,
            child: CustomOutlinedButton(
              onPressed:() async {
                var whatsappUrl = "https://wa.me/+886912585506";
                if (!await launchUrl(Uri.parse(whatsappUrl))) {
                  throw Exception('Could not launch $whatsappUrl');
                }
              },
              color:  Colors.green,
              title: AppLocalizations.of(context)!.contactCustomerService,
            ),
          )
              :const SizedBox()
        ],
      ),
    );
  }

  Future<void> _showFeedBackDialog() async {
    var userModel = context.read<UserModel>();

     await showDialog(
        context: context,
        builder: (BuildContext context) {
          return FeedbackDialog(caseId: userModel.currentCaseId!);
        });
    userModel.currentCaseId = null;
  }

  arrivedDestinationLayout(){
    var userModel = context.read<UserModel>();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 260,
            // alignment: Alignment.center,
            child: Text(AppLocalizations.of(context)!.arrivedMsg, style: const TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 18),),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            height: 35,
            child: CustomOutlinedButton(
                color: AppColor.blue,
                title: AppLocalizations.of(context)!.ok,
                onPressed: (){
                  setState(() {
                    _showFeedBackDialog();

                    var userModel = context.read<UserModel>();
                    userModel.statusCallerIndex = 0;
                    userModel.isCallTaxiClicked = false;
                    userModel.isAllowGetLocation = true;
                    userModel.isEngDriverNeeded = false;
                    userModel.isTextFieldEnable = true;
                    userModel.pickUpAddressController.text = '';
                    userModel.dropOffAddressController.text = '';

                    _taskTimer!.cancel();
                  });
                  _getUserLocation();
                }),
          ),
          const SizedBox(height: 10,),
          userModel.isCallTaxiClicked
              ? SizedBox(
            width: double.infinity,
            height: 35,
            child: CustomOutlinedButton(
              onPressed:() async {
                var whatsappUrl = "https://wa.me/+886912585506";
                if (!await launchUrl(Uri.parse(whatsappUrl))) {
                  throw Exception('Could not launch $whatsappUrl');
                }
              },
              color:  Colors.green,
              title: AppLocalizations.of(context)!.contactCustomerService,
            ),
          )
              :const SizedBox()
        ],
      ),
    );

  }

  statusCaller(int index){
    //?????????
    // 0 ????????????????????????(=???????????????)
    // 1 ????????????
    // 2 ??????(=?????????)
    // 3 ??????(=???????????????)
    switch(index){
      case 0:{return callTaxiLayout();}
      case 1:{return waitingTaxiLayout();}
      case 2:{return inTaxiLayout();}
      case 3:{return arrivedDestinationLayout();}
    }
  }

  Future getHttpConvertToZhOnAddress(double lat, double long) async{
    var userModel = context.read<UserModel>();
    //??????????????????????????????????????? &language=zh-TW ??????
    String path = '${ServerApi.currentAddress}$lat,$long&key=$geocodingKey&language=zh-TW';

    try {
      final response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print(data['status']);
        print(data['results'][0]['formatted_address']);
        setState(() {
          if(window.locale.languageCode == 'zh'){
            userModel.pickUpAddressController.text=data['results'][0]['formatted_address'];
          }
          userModel.pickUpZhAddress=data['results'][0]['formatted_address'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  //?????????????????????????????????????????????????????????????????????????????????????????? server
  //???????????????????????????app???????????????????????????????????????????????????????????????????????????????????? server
  //dropOff address ????????????
  Future getHttpConvertToEngOnAddress(double lat, double long) async{
    var userModel = context.read<UserModel>();
    String path = '${ServerApi.currentAddress}$lat,$long&key=$geocodingKey';
    try {
      final response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print(data['status']);
        print(data['results'][0]['formatted_address']);
        setState(() {
          if(window.locale.languageCode == 'en'){
            userModel.pickUpAddressController.text=data['results'][0]['formatted_address'];
          }
          userModel.pickUpEngAddress=data['results'][0]['formatted_address'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _postCreateCase() async {
    var userModel = context.read<UserModel>();
    String path = ServerApi.postNewCase;

    String converAddress = '';
    if (userModel.dropOffAddressController.text!=''){
      if(window.locale.languageCode == 'zh'){
        converAddress = await _getConvertAddress('en', userModel.dropOffAddressController.text);
      }else{
        converAddress = await _getConvertAddress('zh-TW', userModel.dropOffAddressController.text);
      }
    }

    try {
      final bodyParameters = {
        'on_address' : window.locale.languageCode == 'zh' ? userModel.pickUpAddressController.text : userModel.pickUpZhAddress,
        'off_address': window.locale.languageCode == 'zh' ? userModel.dropOffAddressController.text : converAddress,
        'is_english': userModel.isEngDriverNeeded,
        'on_address_en': window.locale.languageCode == 'en' ? userModel.pickUpAddressController.text : userModel.pickUpEngAddress,
        'off_address_en': window.locale.languageCode == 'en' ? userModel.dropOffAddressController.text : converAddress,
        'case_type': 'direct',
      };
      print(bodyParameters);

      final response = await http.post(ServerApi.standard(path: path),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${userModel.token!}'
          },
          body: jsonEncode(bodyParameters)
      );

      // print(response.body);
      _printLongString(response.body);

      if(response.statusCode == 200){
        print('????????????');
        Map<String, dynamic> map = json.decode(response.body);
        userModel.currentCaseId = map['case_id'];

        //??????????????????????????? getCurrentCaseState

        _taskTimer = Timer.periodic(const Duration(seconds:5), (timer){
          if(userModel.currentCaseId!=null) {
            getCurrentCaseState(userModel.currentCaseId!);
          }else{
            if(_taskTimer!=null) {
              _taskTimer!.cancel();
            }
          }
        });

      }else{

        print(response.statusCode);
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.addressWrong)));
        setState(() {
          userModel.isCallTaxiClicked = false;
          userModel.isAllowGetLocation = true;
        });
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }

  Future getCurrentCaseState(int caseId) async{
    String path = ServerApi.getCurrentCaseState;
    var userModel = context.read<UserModel>();
    try {
      final queryParams = {
        'case_id': userModel.currentCaseId.toString(),
      };

      final response = await http.get(
          ServerApi.standard(path: path,queryParameters: queryParams),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Token ${userModel.token}',
          },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        RideCase theCase = RideCase.fromJson(data);
        userModel.rideCase = theCase;

        print(theCase.caseState);
        userModel.caseState = theCase.caseState!;
        switch(userModel.rideCase?.caseState) {
          case 'wait': {userModel.statusCallerIndex=0;} break;
          case 'way_to_catch': {userModel.statusCallerIndex=1;} break;
          case 'arrived': {userModel.statusCallerIndex=2;}break;
          case 'catched': {userModel.statusCallerIndex=2;}break;
          case 'on_road': {userModel.statusCallerIndex=2;}break;
          case 'finished': {userModel.statusCallerIndex=3;}break;
          default: {userModel.statusCallerIndex=0;}
          break;
        }
        setState(() {});
      }
    } catch (e) {
      print(e);
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
    }
  }

  void _printLongString(String text) {
    final RegExp pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((RegExpMatch match) => print(match.group(0)));
  }
}



