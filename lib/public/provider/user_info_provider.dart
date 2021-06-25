import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoProvider with ChangeNotifier {
  DateFormatCustom _dateFormatCustom = DateFormatCustom();
  LoginFirestoreRepository _loginFirestoreRepository = LoginFirestoreRepository();
  UserModel? _userModel;

  UserModel? getUserData() {
    return _userModel;
  }

  void setUserData({UserModel? userModel}) {
    _userModel = userModel;
    notifyListeners();
  }

  Future<void> saveUserDataToPhone({required UserModel userModel}) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    dynamic encodeData = userModel.toJson();

    encodeData['createDate'] = _dateFormatCustom.changeTimestampToDateTime(timestamp: encodeData['createDate']).toIso8601String();
    encodeData['lastModDate'] = _dateFormatCustom.changeTimestampToDateTime(timestamp: encodeData['lastModDate']).toIso8601String();

    _sharedPreferences.setString(USER, jsonEncode(encodeData));

    print("로그인 사용자 : ${userModel.mail}");

    setUserData(userModel: userModel);
  }

  Future<void> loadUserDataToPhone() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString(USER) != null){
      dynamic decodeData = jsonDecode(_sharedPreferences.getString(USER)!);

      decodeData['createDate'] = _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.parse(decodeData['createDate']));
      decodeData['lastModDate'] = _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.parse(decodeData['lastModDate']));

      _userModel = UserModel.fromMap(mapData: decodeData);

      UserModel _userData = await _loginFirestoreRepository.readUserData(email: _userModel!.mail);

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
}
