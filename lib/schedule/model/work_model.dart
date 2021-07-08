/*
회사 직원 스케줄 모델
  알림ID : alarmId
  종일 체크 : allDay
  글 제목 : title
  글 내용 : content
  글 종류 : type
  글 작성자 아이디 : createUid
  글 작성자명 : name
  주최자 아이디 : organizerId
  장소 : location
  스케줄 시작일 : startTime
  스케줄 종료일 : endTime
  글 작성일 : createDate
  글 수정일 : lastModDate
  동료 초대 : attendees
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class WorkModel {
  int? alarmId;
  bool allDay;
  String title;
  String contents;
  String type;
  String createUid;
  String name;
  String? organizerId;
  String? location;
  Timestamp? startDate;
  Timestamp startTime;
  Timestamp? endTime;
  Timestamp? createDate;
  Timestamp? lastModDate;
  List<dynamic>? colleagues;
  int? level;
  int? timeSlot;
  DocumentReference? reference;


  WorkModel({
    this.alarmId,
    required this.allDay,
    required this.title,
    required this.contents,
    required this.type,
    required this.createUid,
    required this.name,
    this.organizerId,
    this.location,
    this.startDate,
    required this.startTime,
    required this.endTime,
    this.createDate,
    this.lastModDate,
    this.colleagues
  });

  WorkModel.fromMap({required Map mapData, this.reference})
      : alarmId = mapData["alarmId"] ?? 0,
        allDay = mapData["allDay"] ?? false,
        title = mapData["title"] ?? "",
        contents = mapData["contents"] ?? "",
        type = mapData["type"] ?? "",
        createUid = mapData["createUid"] ?? null,
        name = mapData["name"] ?? "",
        organizerId = mapData["organizerId"] ?? "",
        location = mapData["location"] ?? "",
        startTime = mapData["startTime"] ?? Timestamp.now(),
        endTime = mapData["endTime"] ?? mapData["startTime"],
        createDate = mapData["createDate"] ?? Timestamp.now(),
        lastModDate = mapData["lastModDate"] ?? Timestamp.now(),
        colleagues = mapData["colleagues"] ?? [];

  toJson(){
    return {
      "alarmId": alarmId ?? 0,
      "allDay": allDay,
      "title": title,
      "contents": contents,
      "type": type,
      "createUid": createUid,
      "name": name,
      "organizerId": organizerId,
      "location": location,
      "startDate" : startDate ?? Timestamp.fromDate(DateTime(startTime.toDate().year, startTime.toDate().month, startTime.toDate().day, 21, 0, 0)),
      "startTime": startTime,
      "endTime": endTime,
      "createDate": createDate ?? Timestamp.now(),
      "lastModDate": lastModDate ?? Timestamp.now(),
      "colleagues" : colleagues ?? [{createUid : name}],
    };
  }
}