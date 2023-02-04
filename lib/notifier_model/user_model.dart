import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class UserModel extends ChangeNotifier {

  User? _user;
  User? get user => _user;
  String? token;

  String? fcmToken;
  String? platformType;
  String? deviceId;

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