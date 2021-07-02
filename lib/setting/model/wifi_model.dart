/*
자동 출근 WIFI 모델
wifi 이름 : wifiName
등록자메일 : registrantMail
등록자이름 : registrantName
등록일자 : registrationDate
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class WifiModel {
  String? documentId; //Document ID
  String wifiName;
  String registrantMail;
  String registrantName;
  Timestamp? registrationDate;

  WifiModel({
    this.documentId,
    required this.wifiName,
    required this.registrantMail,
    required this.registrantName,
    this.registrationDate,
  });

  WifiModel.fromMap({required Map mapData, String? documentId})
      : documentId = documentId ?? "",
        wifiName = mapData["wifiName"] ?? "",
        registrantMail = mapData["registrantMail"] ?? "",
        registrantName = mapData["registrantName"] ?? "",
        registrationDate = mapData["registrationDate"] ?? Timestamp.now();


  toJson() {
    return {
      "wifiName": wifiName,
      "registrantMail": registrantMail,
      "registrantName": registrantName,
      "registrationDate": registrationDate,
    };
  }
}
