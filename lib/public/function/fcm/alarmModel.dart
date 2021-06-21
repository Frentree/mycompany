/*
알람 모델

작성자 이름 <createName>
작성자 이메일 <createMail>
컬렉션 이름 <collectionName>
읽음여부 <read>
알림온시간 <alarmDate>
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class AlarmModel {
  String id; //Document ID
  int alarmId;
  String title;
  String createName;
  String createMail;
  String collectionName;
  String alarmContents; // message
  bool read;
  Timestamp alarmDate;
  String route;

  AlarmModel({
    required this.id,
    required this.alarmId,
    required this.title,
    required this.createName,
    required this.createMail,
    required this.collectionName,
    required this.alarmContents,
    this.read = false,
    required this.alarmDate,
    required this.route,
  });

  AlarmModel.fromMap(Map snapshot, String id)
      : id = snapshot["id"] ?? "",
        alarmId = snapshot["alarmId"] ?? 0,
        title = snapshot["title"] ?? "",
        createName = snapshot["createName"] ?? "",
        createMail = snapshot["createMail"] ?? "",
        collectionName = snapshot["collectionName"] ?? "",
        alarmContents = snapshot["alarmContents"] ?? "",
        read = snapshot["read"] ?? false,
        route = snapshot["route"] ?? "",
        alarmDate = snapshot["alarmDate"] ?? Timestamp.now();


  toJson() {
    return {
      "id": id,
      "alarmId": alarmId,
      "title": title,
      "createName": createName,
      "createMail": createMail,
      "collectionName": collectionName,
      "alarmContents": alarmContents,
      "read": read,
      "alarmDate": alarmDate,
      "route": route,
    };
  }
}
