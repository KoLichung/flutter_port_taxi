import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/car_number_tag.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'dart:async';
import '../config/color.dart';
import '../config/server_api.dart';
import '../models/ride_case.dart';
import '../notifier_model/user_model.dart';
import 'my.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  // bool isEngDriverNeeded = false;
  // bool isCallTaxiClicked = false;
  // bool isAllowGetLocation = true;
  // bool isTextFieldEnable = true;
  // TextEditingController pickUpAddressController = TextEditingController();
  // TextEditingController dropOffAddressController = TextEditingController();


  String geocodingKey = 'AIzaSyCdP86OffSMXL82nbHA0l6K0W2xrdZ5xLk';

  // LatLng? currentPosition;
  double? currentLat;
  double? currentLong;

  Timer? _taskTimer;

  // int? currentCaseId;
  // RideCase? rideCase;

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

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    print(AppLocalizations.of(context)!.helloWorld);

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
        height: 222,
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
        const Text('上車位置',style: TextStyle(color: AppColor.blue, fontSize: 12)),
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
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 14),
                        hintStyle: TextStyle(fontSize: 14),
                        hintText: '按右方按鈕取得目前地址',
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
                        ? (){ getHttpConvertToAddress(currentLat!, currentLong!); }
                        : null,
                    child: const Text('取得當前位置')
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 5,),
        const Text('下車位置',style: TextStyle(color: AppColor.blue, fontSize: 12)),
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
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 14),
                    hintStyle: TextStyle(fontSize: 14),
                    hintText: '輸入下車位置',
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
            // onPressed: isCallTaxiClicked == false ? _callButtonCallback : null,
            onPressed: userModel.isCallTaxiClicked
                ? null //this null is to disable button
                :(){
                      if(userModel.pickUpAddressController.text.isEmpty){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請輸入您的上車地址！"),));
                      } else {
                        setState(() {
                          userModel.isCallTaxiClicked = true;
                          userModel.isAllowGetLocation = false;
                          userModel.isTextFieldEnable = false;
                          _postCreateCase();
                        });
                      }
                  },
            child: Text( userModel.isCallTaxiClicked == false ? '叫車' : '搜尋司機中...', style: const TextStyle(fontSize: 18),),
          ),
        )
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
          Text('司機：${userModel.rideCase?.driverName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
                    TextSpan(text: '${userModel.rideCase!.driverName!}司機在路上，約 ', style: const TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold)),
                    TextSpan(text: userModel.rideCase?.expectMinutes.toString(), style: const TextStyle(color: AppColor.red, fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' 分鐘到達～', style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold)),

                  ]
              )),
          const SizedBox(height: 10,),
          Flexible(child: Text('上車位置：${userModel.pickUpAddressController.text}')),
          // const Spacer(flex: 1,),
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
          Text('司機：${userModel.rideCase?.driverName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 10,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(userModel.rideCase!.carModel!, style: const TextStyle(fontWeight: FontWeight.bold),),
              CarNumberTag(carNumber: userModel.rideCase!.carIdNumber!)
            ],),
          const SizedBox(height: 10,),
          Text('上車：${userModel.pickUpAddressController.text}'),
          const SizedBox(height: 10,),
          userModel.dropOffAddressController.text.isNotEmpty
              ? Text('下車：${userModel.dropOffAddressController.text}')
              : const Text('下車：未指名')
          // const Spacer(flex: 1,),
        ],
      ),
    );
  }

  arrivedDestinationLayout(){
    var userModel = context.read<UserModel>();

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('已抵達目的地，感謝您的搭乘！', style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold, fontSize: 18),),
          CustomOutlinedButton(
              color: AppColor.blue,
              title: '確認',
              onPressed: (){
                setState(() {
                  var userModel = context.read<UserModel>();
                  userModel.statusCallerIndex = 0;
                  userModel.isCallTaxiClicked = false;
                  userModel.isAllowGetLocation = true;
                  userModel.pickUpAddressController.text = '';
                  userModel.dropOffAddressController.text = '';
                  userModel.currentCaseId = null;
                  _taskTimer!.cancel();
                });
              })
        ],
      ),
    );

  }

  statusCaller(int index){
    //狀態：
    // 0 尚未叫車～已叫車(=搜尋司機中)
    // 1 等待司機
    // 2 上車(=車程中)
    // 3 下車(=抵達目的地)
    switch(index){
      case 0:{return callTaxiLayout();}
      case 1:{return waitingTaxiLayout();}
      case 2:{return inTaxiLayout();}
      case 3:{return arrivedDestinationLayout();}
    }
  }


  Future getHttpConvertToAddress(double lat, double long) async{
    var userModel = context.read<UserModel>();

    //如果是英文使用者語言要把 &language=zh-TW 刪掉
    // String path = '${ServiceApi.currentAddress}25.03369,121.564128&key=$geocodingKey&language=zh-TW';
    String path = '${ServerApi.currentAddress}$lat,$long&key=$geocodingKey&language=zh-TW';

    try {
      final response = await http.get(Uri.parse(path));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print(data['status']);
        print(data['results'][0]['formatted_address']);
        setState(() {
          userModel.pickUpAddressController.text=data['results'][0]['formatted_address'];
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future _postCreateCase() async {
    var userModel = context.read<UserModel>();
    String path = ServerApi.postNewCase;
    try {
      final bodyParameters = {
        'on_address' : userModel.pickUpAddressController.text,
        'off_address': userModel.dropOffAddressController.text.isEmpty ? '未指名' : userModel.dropOffAddressController.text,
        'is_english': userModel.isEngDriverNeeded,
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
        Map<String, dynamic> map = json.decode(response.body);
        userModel.currentCaseId = map['case_id'];

        //每五秒要抓一次資料 getCurrentCaseState
        // 要讓他不論切到哪個畫面都能夠在背景底下持續計時

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
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('地址有誤，請重新輸入!')));
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
        // print(theCase.caseState);
        // switch(theCase.caseState) {
        //   case 'wait': {userModel.statusCallerIndex=0;} break;
        //   case 'way_to_catch': {userModel.statusCallerIndex=1;} break;
        //   case 'arrived': {userModel.statusCallerIndex=2;}break;
        //   case 'catched': {userModel.statusCallerIndex=2;}break;
        //   case 'on_road': {userModel.statusCallerIndex=2;}break;
        //   case 'finished': {userModel.statusCallerIndex=3;}break;
        //   default: {userModel.statusCallerIndex=0;}
        //   break;
        // }
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

}



