import 'package:flutter/material.dart';
import 'package:flutter_port_taxi/config/color.dart';
import 'package:flutter_port_taxi/config/time_converter.dart';
import 'package:flutter_port_taxi/pages/ride_record_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/server_api.dart';
import '../models/ride_case.dart';
import '../notifier_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class RideRecordList extends StatefulWidget {
  const RideRecordList({Key? key}) : super(key: key);

  @override
  State<RideRecordList> createState() => _RideRecordListState();
}

class _RideRecordListState extends State<RideRecordList> {

  List<RideCase> myRideCasesList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getMyRideList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('乘車紀錄'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColor.blue,))
          : SafeArea(
              child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: myRideCasesList.length,
              itemBuilder: (BuildContext context,int i){
                return Column(
                  children: [
                  GestureDetector(
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: ListTile(
                          title: Text(DateTimeConverter.date(myRideCasesList[i].createTime!), style: const TextStyle(fontSize: 16),),
                          subtitle: Text(myRideCasesList[i].onAddress!, style: const TextStyle(fontSize: 16),),
                          trailing: const SizedBox(
                            width: 30,
                            child: Icon(Icons.arrow_forward_ios, color: Color(0xff292D32),),
                          ),
                        )),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>RideRecordDetail(theCase: myRideCasesList[i]),
                          ));
                    },
                  ),
                  const Divider(
                    color: Color(0xffCCCCCC),
                    thickness: 0.5,
                  ),
                ],);
              },
              )
            ),
      );

  }
  Future _getMyRideList() async {
    var userModel = context.read<UserModel>();
    String path = ServerApi.userCases;
    try {
      final response = await http.get(ServerApi.standard(path: path),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token ${userModel.token!}'},
      );
      if (response.statusCode == 200) {
        // print(response.body);
        List<dynamic> parsedListJson = json.decode(utf8.decode(response.body.runes.toList()));
        List<RideCase> data = List<RideCase>.from(parsedListJson.map((i) => RideCase.fromJson(i)));
        myRideCasesList = data;
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
