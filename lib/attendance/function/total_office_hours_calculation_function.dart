import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:flutter/material.dart ';

class TotalOfficeHoursCalculationFunction {
  LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();
  DateFormatCustom dateFormatCustom = DateFormatCustom();

  Duration officeHoursCalculation({
    required Timestamp attendTime,
    required Timestamp endTime,
  }) {

    Duration officeHours = dateFormatCustom.changeTimestampToDateTime(timestamp: endTime).difference(dateFormatCustom.changeTimestampToDateTime(timestamp: attendTime));
    
    return officeHours;
  }

  Duration overTimeCalculation({
    required Timestamp endTime,
  }) {
    DateTime defaultEndTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 18, 00);

    Duration officeHours = dateFormatCustom.changeTimestampToDateTime(timestamp: endTime).difference(defaultEndTime);

    if(officeHours.isNegative){
      officeHours = Duration();
    }

    return officeHours;
  }

  Duration remainingTimeCalculation({
    required Duration totalOfficeHours,
  }) {
    Duration officeHours = Duration(minutes: 3120 - totalOfficeHours.inMinutes);

    if(officeHours.isNegative){
      officeHours = Duration();
    }

    return officeHours;
  }
  
  String changeOfficeHoursToString({required Duration officeHours}){
    int hours = officeHours.inHours;
    int minutes = officeHours.inMinutes - (60 * hours);

    String officeHoursString = hours != 0 ? "${hours}시간 ${minutes}분" : "${minutes}분";
    
    return officeHoursString;
  } 

  Timer? todayOfficeHoursCalculation({required ValueNotifier<String> officeHours, required ValueNotifier<Timestamp?> attendTime, required ValueNotifier<Timestamp?> endTime}){
    Timer? timer;

    if(attendTime.value == null){
      officeHours.value = "-";
    }
    else{
      Timestamp tempAttendTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: attendTime.value!);
      if(endTime.value != null){

        Timestamp tempEndTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: endTime.value!);
        officeHours.value = changeOfficeHoursToString(officeHours: officeHoursCalculation(attendTime: tempAttendTime, endTime: tempEndTime));
      }

      else{
        officeHours.value = changeOfficeHoursToString(officeHours:  officeHoursCalculation(attendTime: tempAttendTime, endTime: Timestamp.now()));
        timer = Timer.periodic(Duration(seconds: 10), (timer) {
          if(endTime.value != null){
            timer.cancel();
          }
          officeHours.value = changeOfficeHoursToString(officeHours: officeHoursCalculation(attendTime: tempAttendTime, endTime: Timestamp.now()));
        });
      }
    }
    return timer;
  }

  Duration dayOfficeHoursCalculation({required AttendanceModel attendanceData}){
    Duration officeHours = Duration();

    if(attendanceData.attendTime != null && attendanceData.endTime != null){
      Timestamp tempAttendTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: attendanceData.attendTime!);
      Timestamp tempEndTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: attendanceData.endTime!);

      officeHours = officeHoursCalculation(attendTime: tempAttendTime, endTime: tempEndTime);
    }

    return officeHours;
  }

  List<AttendanceModel> getWeekAttendanceData({required List<AttendanceModel> attendanceDataList, required DateTime startDate, required DateTime endDate}){
    List<AttendanceModel> weekAttendanceData = [
      AttendanceModel(mail: "", name: ""),
      AttendanceModel(mail: "", name: ""),
      AttendanceModel(mail: "", name: ""),
      AttendanceModel(mail: "", name: ""),
      AttendanceModel(mail: "", name: ""),
      AttendanceModel(mail: "", name: ""),
      AttendanceModel(mail: "", name: ""),
    ];

    attendanceDataList.forEach((element) {
      DateTime dataCreateDate = dateFormatCustom.changeTimestampToDateTime(timestamp: element.createDate!);
      if((dataCreateDate.compareTo(startDate) >= 0) && (dataCreateDate.compareTo(endDate) <= 0)){
        weekAttendanceData[element.createDate!.toDate().weekday] = element;
      }
    });

    return weekAttendanceData;
  }

  Map<String, List<AttendanceModel>> getEmployeeWeekAttendanceData({required List<AttendanceModel> attendanceDataList, required List<EmployeeModel> employeeData, required DateTime startDate, required DateTime endDate}){
    Map<String, List<AttendanceModel>> employeeWeekAttendanceData = {};

    employeeData.forEach((element) {
      employeeWeekAttendanceData.putIfAbsent(element.mail, () => [
        AttendanceModel(mail: element.mail, name: element.name),
        AttendanceModel(mail: element.mail, name: element.name),
        AttendanceModel(mail: element.mail, name: element.name),
        AttendanceModel(mail: element.mail, name: element.name),
        AttendanceModel(mail: element.mail, name: element.name),
        AttendanceModel(mail: element.mail, name: element.name),
        AttendanceModel(mail: element.mail, name: element.name),
      ]);
    });
    attendanceDataList.forEach((element) {
      if(employeeWeekAttendanceData.keys.contains(element.mail)){
        DateTime dataCreateDate = dateFormatCustom.changeTimestampToDateTime(timestamp: element.createDate!);
        if((dataCreateDate.compareTo(startDate) >= 0) && (dataCreateDate.compareTo(endDate) <= 0)){
          employeeWeekAttendanceData[element.mail]![element.createDate!.toDate().weekday] = element;
        }
      }
    });

    return employeeWeekAttendanceData;
  }

  List<Duration> weekTotalOfficeHoursCalculation({required List<AttendanceModel> attendanceDataList}){
    List<Duration> weekTotal = [Duration(), Duration(), Duration()];

    attendanceDataList.forEach((element) {
      if((element.attendTime != null) && (element.endTime != null)){
        Timestamp tempAttendTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: element.attendTime!);
        Timestamp tempEndTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: element.endTime!);

        weekTotal[0] += officeHoursCalculation(attendTime: tempAttendTime, endTime: tempEndTime);
        if(element.overTime != 0){
          weekTotal[1] += overTimeCalculation(endTime: tempEndTime);
        }
      }
    });

    weekTotal[2] = remainingTimeCalculation(totalOfficeHours: weekTotal[0]);

    return weekTotal;
  }

  Map<String, List<Duration>> employeeWeekTotalOfficeHoursCalculation({required Map<String, List<AttendanceModel>> employeeAttendanceDataList}){
    Map<String, List<Duration>> employeeWeekTotal = {};

    employeeAttendanceDataList.keys.forEach((element) {
      employeeWeekTotal.putIfAbsent(element, () => [Duration(), Duration(), Duration()]);
    });

    employeeAttendanceDataList.forEach((key, value) {
      value.forEach((element) {
        if((element.attendTime != null) && (element.endTime != null)){
          Timestamp tempAttendTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: element.attendTime!);
          Timestamp tempEndTime = dateFormatCustom.showTimestampUpToMinutes(timestamp: element.endTime!);

          employeeWeekTotal[key]![0] += officeHoursCalculation(attendTime: tempAttendTime, endTime: tempEndTime);
          if(element.overTime != 0){
            employeeWeekTotal[key]![1] += overTimeCalculation(endTime: tempEndTime);
          }
        }
      });

      employeeWeekTotal[key]![2] = remainingTimeCalculation(totalOfficeHours: employeeWeekTotal[key]![0]);
    });

    return employeeWeekTotal;
  }
}