import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/attendance/db/attendance_firestore_repository.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';

Future<void> autoCheckOnWorkFunction({required EmployeeModel employeeInfo}) async {

  AttendanceFirestoreRepository attendanceFirestoreRepository = AttendanceFirestoreRepository();
  DateFormatCustom dateFormatCustom = DateFormatCustom();
  DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  //오늘 출퇴근 데이터를 가져온다.
  List<AttendanceModel> todayAttendanceData = await attendanceFirestoreRepository.readMyAttendanceDataWithPeriod(
    employeeData: employeeInfo,
    minimumDate: dateFormatCustom.changeDateTimeToTimestamp(dateTime: today),
    maximumDate: dateFormatCustom.changeDateTimeToTimestamp(dateTime: today),
  );

  //출퇴근 데이터가 없을 경우
  if(todayAttendanceData.length == 0){
    AttendanceModel _attendanceModel = AttendanceModel(
      mail: employeeInfo.mail,
      name: employeeInfo.name,
      createDate: dateFormatCustom.changeDateTimeToTimestamp(dateTime: today),
    );

    bool _isConnectWifi = await checkConnectWifi();

    //WIFI 연결 됨
    if(_isConnectWifi == true){
      _attendanceModel.status = 1;
      _attendanceModel.certificationDevice = 0;
      _attendanceModel.attendTime = Timestamp.now();
    }

    //WIFI 연결 안됨
    else{
      _attendanceModel.status = 0;
    }

    await attendanceFirestoreRepository.createAttendanceData(companyId: employeeInfo.companyCode, attendanceModel: _attendanceModel);
  }

  //출퇴근 데이터가 있을 경우
  else{
    //출근전일 경우
    if(todayAttendanceData[0].status == 0){
      bool _isConnectWifi = await checkConnectWifi();

      //WIFI 연결 됨
      if(_isConnectWifi == true){
        todayAttendanceData[0].status = 1;
        todayAttendanceData[0].certificationDevice = 0;
        todayAttendanceData[0].attendTime = Timestamp.now();

        await attendanceFirestoreRepository.updateAttendanceData(companyId: employeeInfo.companyCode, attendanceModel: todayAttendanceData[0]);
      }
    }
  }
}

Future<bool> checkConnectWifi() async {
  Connectivity connectivity = Connectivity();
  WifiInfo wifiInfo = WifiInfo();

  String connectedWifiName = "";
  String wifiName = "AndroidWifi";

  ConnectivityResult connectivityResult = await connectivity.checkConnectivity();
  if(connectivityResult == ConnectivityResult.wifi){
    connectedWifiName = (await wifiInfo.getWifiName())!;
    if(connectedWifiName == wifiName){
      return true;
    }

    else{
      return false;
    }
  }

  return false;
}