import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/car_number_tag.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'dart:async';
import '../config/color.dart';
import '../config/server_api.dart';
import '../notifier_model/user_model.dart';
import 'my.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _statusCallerIndex = 0;

  bool isEngDriverNeeded = false;
  bool isCallTaxiClicked = false;
  bool isAllowGetLocation = true;
  TextEditingController pickUpAddressController = TextEditingController();
  TextEditingController dropOffAddressController = TextEditingController();


  String geocodingKey = 'AIzaSyCdP86OffSMXL82nbHA0l6K0W2xrdZ5xLk';

  // LatLng? currentPosition;
  double? currentLat;
  double? currentLong;

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

  //待修改
  void _callButtonCallback() {
    var userModel = context.read<UserModel>();
    if(pickUpAddressController.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請輸入您的上車地址！"),));

    } else {
      setState(() {
        isCallTaxiClicked = true;
        isAllowGetLocation = false;
        // Timer(Duration(seconds:2), (){
        //   print('yes');
        //   _statusCallerIndex = 1;
        // });
        _postCreateCase();
      });

    }

  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child:Consumer<UserModel>(builder: (context, userModel, child) =>
            (userModel.currentPosition==null)?
            const CircularProgressIndicator(color: AppColor.blue,)
                :
            GoogleMap(
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: userModel.currentPosition!,
                zoom: 16,
              ),
            ),
          )
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromARGB(255,253,252,252),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        height: 222,
        // child: getStatusLayout(_statusCallerIndex),
        child: statusCaller(0)
      ),
    );
  }

  callTaxiLayout(){
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
                    style: const TextStyle(fontSize: 14),
                    controller: pickUpAddressController,
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
                        padding: EdgeInsets.all(0),
                        elevation: 0,
                        backgroundColor: AppColor.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    onPressed: isAllowGetLocation == true
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
                  controller: dropOffAddressController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 14),
                    hintStyle: TextStyle(fontSize: 14),
                    hintText: '輸入下車位置可預估車資(可省略)',
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
                value: isEngDriverNeeded,
                onChanged: (bool? value) {
                  setState(() {
                    isEngDriverNeeded = value!;
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
            onPressed: isCallTaxiClicked == false ? _callButtonCallback : null,
            child: Text( isCallTaxiClicked == false ? '叫車' : '搜尋司機中...', style: const TextStyle(fontSize: 18),),
          ),
        )
      ],
    );
  }

  waitingTaxiLayout(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Spacer(flex: 1,),
          Text('司機：王小明', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 10,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
            Text('Toyota Wish', style: TextStyle(fontWeight: FontWeight.bold),),
            CarNumberTag(carNumber: '134-456')
          ],),
          const SizedBox(height: 10,),
          Text.rich(
              TextSpan(
                  children: [
                    TextSpan(text: '小明司機在路上，約', style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold)),
                    TextSpan(text: ' 5 ', style: TextStyle(color: AppColor.red, fontWeight: FontWeight.bold)),
                    TextSpan(text: '分鐘到達～', style: TextStyle(color: AppColor.blue, fontWeight: FontWeight.bold)),

                  ]
              )),
          const SizedBox(height: 10,),
          Text('上車位置：桃園區民族路1號'),
          // const Spacer(flex: 1,),
        ],
      ),
    );
  }

  inTaxiLayout(){
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Spacer(flex: 1,),
          Text('司機：王小明', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          const SizedBox(height: 10,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Toyota Wish', style: TextStyle(fontWeight: FontWeight.bold),),
              CarNumberTag(carNumber: '134-456')
            ],),
          const SizedBox(height: 10,),
          Text('上車：桃園區民族路1號'),
          const SizedBox(height: 10,),
          Text('下車：蘆竹區中山路100號'),
          // const Spacer(flex: 1,),
        ],
      ),
    );
  }

  arrivedDestinationLayout(){
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
                  _statusCallerIndex = 0;
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

  //待修改
  getStatusLayout(int index){
    if (index == 0){
      return statusCaller(0);
    } else if (index ==1 ){
      return statusCaller(1);
    }

  }

  Future getHttpConvertToAddress(double lat, double long) async{
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
          pickUpAddressController.text=data['results'][0]['formatted_address'];
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
        'on_address' : pickUpAddressController.text,
        'off_address': dropOffAddressController.text.isEmpty ? '無' :dropOffAddressController.text
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

      if(response.statusCode == 201){

        print('成功叫車');

      }else{
        print(response.statusCode);
        ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(const SnackBar(content: Text('叫車失敗!')));
      }


    } catch (e) {
      print(e);
      return "error";
    }
  }

}



