import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/word/database_name.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EmployeeInfoProvider with ChangeNotifier {
  DateFormatCustom _dateFormatCustom = DateFormatCustom();
  LoginFirestoreRepository _loginFirestoreRepository = LoginFirestoreRepository();
  EmployeeModel? _employeeModel;

  EmployeeModel? getEmployeeData() {
    return _employeeModel;
  }

  void setEmployeeData({EmployeeModel? employeeModel}) {
    _employeeModel = employeeModel;
    notifyListeners();
  }

  Future<void> saveEmployeeDataToPhone({required EmployeeModel employeeModel}) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    dynamic encodeData = employeeModel.toJson();

    encodeData['createDate'] = _dateFormatCustom.changeTimestampToDateTime(timestamp: encodeData['createDate']).toIso8601String();
    encodeData['lastModDate'] = _dateFormatCustom.changeTimestampToDateTime(timestamp: encodeData['lastModDate']).toIso8601String();

    _sharedPreferences.setString(EMPLOYEE, jsonEncode(encodeData));
    setEmployeeData(employeeModel: employeeModel);
  }

  Future<void> saveEmployeeDataToPhoneWithoutNotifyListener({required EmployeeModel employeeModel}) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    dynamic encodeData = employeeModel.toJson();

    encodeData['createDate'] = _dateFormatCustom.changeTimestampToDateTime(timestamp: encodeData['createDate']).toIso8601String();
    encodeData['lastModDate'] = _dateFormatCustom.changeTimestampToDateTime(timestamp: encodeData['lastModDate']).toIso8601String();

    _sharedPreferences.setString(EMPLOYEE, jsonEncode(encodeData));
  }

  Future<void> loadEmployeeDataToPhone() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString(EMPLOYEE) != null){
      dynamic decodeData = jsonDecode(_sharedPreferences.getString(EMPLOYEE)!);

      decodeData['createDate'] = _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.parse(decodeData['createDate']));
      decodeData['lastModDate'] = _dateFormatCustom.changeDateTimeToTimestamp(dateTime: DateTime.parse(decodeData['lastModDate']));

      _employeeModel = EmployeeModel.fromMap(mapData: decodeData);

      EmployeeModel _employeeData = await _loginFirestoreRepository.readEmployeeData(companyId: _employeeModel!.companyCode, email: _employeeModel!.mail);

      if(_employeeData != _employeeModel){
        saveEmployeeDataToPhone(employeeModel: _employeeData);
        _employeeModel = _employeeData;
      }
      notifyListeners();
    }

    else{
      return null;
    }
  }

  Future<void> deleteEmployeeDataToPhone() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    await _sharedPreferences.remove(USER);
    setEmployeeData(employeeModel: null);
  }
}
