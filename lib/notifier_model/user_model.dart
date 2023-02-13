import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/ride_case.dart';
import '../models/user.dart';

class UserModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;
  String? token;

  String? fcmToken;
  String? platformType;
  String? deviceId;

  // double? currentLat;
  // double? currentLong;

  LatLng? currentPosition;
  int statusCallerIndex = 0;
  String caseState='';

  bool isEngDriverNeeded = false;
  bool isCallTaxiClicked = false;
  bool isAllowGetLocation = true;
  bool isTextFieldEnable = true;
  TextEditingController pickUpAddressController = TextEditingController();
  TextEditingController dropOffAddressController = TextEditingController();

  int? currentCaseId;
  RideCase? rideCase;

  Timer? taskTimer;

  void timer (Function function){
    taskTimer = Timer.periodic(const Duration(seconds:5), (timer){
      function();
    });
  }


  void setUser(User theUser){
    _user = theUser;
    notifyListeners();
  }

  void removeUser(BuildContext context){
    _user = null;
    token = null;
    notifyListeners();
  }

  bool isLogin(){
    if(_user != null){
      return true;
    }else{
      return false;
    }
  }

  void updateProfile(String? newName, String? newEmail){
    _user?.name = newName;
    _user?.email = newEmail;
    notifyListeners();
  }

}