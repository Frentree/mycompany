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

    encodeData['birthday'] = _dateFormatCustom.changeTimeStampToDateTime(timestamp: encodeData['birthday']).toIso8601String();
    encodeData['joinedDate'] = _dateFormatCustom.changeTimeStampToDateTime(timestamp: encodeData['joinedDate']).toIso8601String();
    encodeData['enteredDate'] = _dateFormatCustom.changeTimeStampToDateTime(timestamp: encodeData['enteredDate']).toIso8601String();
    encodeData['modifiedDate'] = _dateFormatCustom.changeTimeStampToDateTime(timestamp: encodeData['modifiedDate']).toIso8601String();

    _sharedPreferences.setString(EMPLOYEE, jsonEncode(encodeData));
    setEmployeeData(employeeModel: employeeModel);
  }

  Future<void> loadEmployeeDataToPhone() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    if(_sharedPreferences.getString(EMPLOYEE) != null){
      dynamic decodeData = jsonDecode(_sharedPreferences.getString(EMPLOYEE)!);

      decodeData['birthday'] = _dateFormatCustom.changeDateTimeToTimeStamp(dateTime: DateTime.parse(decodeData['birthday']));
      decodeData['joinedDate'] = _dateFormatCustom.changeDateTimeToTimeStamp(dateTime: DateTime.parse(decodeData['joinedDate']));
      decodeData['enteredDate'] = _dateFormatCustom.changeDateTimeToTimeStamp(dateTime: DateTime.parse(decodeData['enteredDate']));
      decodeData['modifiedDate'] = _dateFormatCustom.changeDateTimeToTimeStamp(dateTime: DateTime.parse(decodeData['modifiedDate']));

      _employeeModel = EmployeeModel.fromMap(mapData: decodeData);

      EmployeeModel _employeeData = await _loginFirestoreRepository.readEmployeeData(companyId: _employeeModel!.companyId, email: _employeeModel!.email);

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
    await _sharedPreferences.remove(EMPLOYEE);
    setEmployeeData(employeeModel: null);
  }
}
