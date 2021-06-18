/*
근태 모델
직원메일 : mail
직원이름 : name
문서생성일 : createDate
출근시간 : attendTime
퇴근시간 : endTime
인증기기 : certificationDevice
수동출근이유 : manualOnWorkReason
출근상태 : status

certificationDevice
0 : WIFI
1 : 수동

manualOnWorkReason
0 : 기기고장
1 : 착오
3 : 사무실 외 근무

status
0 : 출근전
1 : 내근
2 : 외근
3 : 직출
4 : 재택
5 : 연차
6 : 퇴근
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  String mail;
  String name;
  Timestamp? createDate;
  Timestamp? attendTime;
  Timestamp? endTime;
  int? certificationDevice;
  int? manualOnWorkReason;
  String status;

  AttendanceModel({
    required this.mail,
    required this.name,
    this.createDate,
    this.attendTime,
    this.endTime,
    this.certificationDevice,
    this.manualOnWorkReason,
    required this.status,
  });

  AttendanceModel.fromMap({required Map mapData})
      : mail = mapData["mail"] ?? "",
        name = mapData["name"] ?? "",
        createDate = mapData["createDate"] ?? Timestamp.now(),
        attendTime = mapData["attendTime"] ?? null,
        endTime = mapData["endTime"] ?? null,
        certificationDevice = mapData["certificationDevice"] ?? null,
        manualOnWorkReason = mapData["manualOnWorkReason"] ?? null,
        status = mapData["status"] ?? 0;

  toJson(){
    return {
      "mail": mail,
      "name": name,
      "createDate": createDate,
      "attendTime": attendTime,
      "endTime": endTime,
      "certificationDevice": certificationDevice,
      "manualOnWorkReason": manualOnWorkReason,
      "status": status,
    };
  }
}