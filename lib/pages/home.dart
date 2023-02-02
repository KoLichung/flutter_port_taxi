import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/widget/car_number_tag.dart';
import 'package:flutter_port_taxi/widget/custom_outlined_button.dart';
import 'dart:async';
import '../const/color.dart';
import 'my.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(child: pageCaller(_selectedIndex),),

      bottomNavigationBar: BottomNavigationBar(
        elevation: _selectedIndex == 0 ? 0 : 8,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xffFCFCFC),
        selectedItemColor: AppColor.blue,
        unselectedItemColor: const Color(0xff737273),
        currentIndex: _selectedIndex,
        onTap: (int index){
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.local_taxi_rounded), label: '叫車'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: '我的'),
        ],
      ),
    );
  }

  pageCaller(int index){
    switch(index){
      case 0:{return const HomeLayout();}
      case 1:{return const My();}
    }
  }
}

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {

  int _statusCallerIndex = 0;

  bool isEngDriverNeeded = false;
  bool isCallTaxiClicked = false;
  bool isAllowGetLocation = true;
  TextEditingController pickUpAddressController = TextEditingController();
  TextEditingController dropOffAddressController = TextEditingController();

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }



  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(25.0339206,121.5636985),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  void _callButtonCallback() {
    setState(() {
      isCallTaxiClicked = true;
      isAllowGetLocation = false;
      Timer(Duration(seconds:2), (){
        print('yes');
        _statusCallerIndex = 1;
      });

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickUpAddressController.text = '桃園區民族路1號';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // child: GoogleMap(
          //   initialCameraPosition: _kGooglePlex,
          //   onMapCreated: (GoogleMapController controller) {
          //     _controller.complete(controller);
          //   },
          //
          // ),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
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
                  padding: const EdgeInsets.fromLTRB(10,0,10,6),
                  height: 35,
                  decoration: BoxDecoration(
                      color: AppColor.lightGrey,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 14),
                    controller: pickUpAddressController,
                    decoration: const InputDecoration(border: InputBorder.none),
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
                        elevation: 0,
                        backgroundColor: AppColor.lightBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    onPressed: isAllowGetLocation == true ? (){} : null,
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

  getStatusLayout(int index){
    if (index == 0){
      return statusCaller(0);
    } else if (index ==1 ){
      return statusCaller(1);
    }

  }

}
