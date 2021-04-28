/*
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/word/database_name.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider with ChangeNotifier {
  DateFormat _dateFormat = DateFormat();
  LoginFirebaseRepository _loginFirebaseRepository = LoginFirebaseRepository();
  UserModel _userModel;

  UserModel getUserData() {
    return _userModel;
  }

  void setUserData({UserModel userModel}) {
    _userModel = userModel;
    notifyListeners();
  }

  Future<void> saveUserDataToPhone({UserModel userModel}) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    dynamic encodeData = userModel.toJson();

    encodeData['birthday'] = _dateFormat.changeTimeStampToDateTime(timestamp: encodeData['birthday']).toIso8601String();
    encodeData['createDate'] = _dateFormat.changeTimeStampToDateTime(timestamp: encodeData['createDate']).toIso8601String();
    encodeData['modifiedDate'] = _dateFormat.changeTimeStampToDateTime(timestamp: encodeData['modifiedDate']).toIso8601String();

    _sharedPreferences.setString(USER, jsonEncode(encodeData));
    setUserData(userModel: userModel);
  }

  Future<void> loadUserDataToPhone() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString(USER) != null){
      dynamic decodeData = jsonDecode(_sharedPreferences.getString(USER));

      decodeData['birthday'] = _dateFormat.changeDateTimeToTimeStamp(dateTime: DateTime.parse(decodeData['birthday']));
      decodeData['createDate'] = _dateFormat.changeDateTimeToTimeStamp(dateTime: DateTime.parse(decodeData['createDate']));
      decodeData['modifiedDate'] = _dateFormat.changeDateTimeToTimeStamp(dateTime: DateTime.parse(decodeData['modifiedDate']));

      _userModel = UserModel.fromMap(mapData: decodeData);

      UserModel _userData = await _loginFirebaseRepository.readUserData(email: _userModel.email);

      if(_userData != _userModel){
        saveUserDataToPhone(userModel: _userData);
        _userModel = _userData;
      }
      notifyListeners();
    }

    else{
      return null;
    }
  }

  Future<void> deleteUserDataToPhone() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.remove(USER);
    setUserData(userModel: null);
  }
}*/
