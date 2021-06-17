/*
회사 직원 스케줄 모델
  스케줄 docId : docIds
  결재 상태 : status
  스케줄 위치 : location
  결재자 승인 할 내용 : approvalContent
  결재자 이름 : approvalUser
  결재자 메일 : approvalMail
  결재할 스케줄 타입 : approvalType
  스케줄 제목 : title
  스케줄 내용 : requestContent
  스케줄 생성일 : createDate
  결재일 : approvalDate
  스케줄 시작일 : requestStartDate
  스케줄 종료일 : requestEndDate
  결재 총 금액 : totalCost
  결재 요청자 : user
  결재 요청자 메일 : userMail
  같이할 동료 : attendees
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalModel {
  String? docIds;
  bool allDay;
  String status;
  String location;
  String? approvalContent;
  String approvalUser;
  String approvalMail;
  String approvalType;
  String title;
  String requestContent;
  Timestamp? createDate;
  Timestamp? approvalDate;
  Timestamp requestStartDate;
  Timestamp requestEndDate;
  int? totalCost;
  String user;
  String userMail;
  List<dynamic> colleagues;
  DocumentReference? reference;

  ApprovalModel({
    this.docIds,
    required this.allDay,
    required this.status,
    required this.location,
    this.approvalContent,
    required this.approvalUser,
    required this.approvalMail,
    required this.approvalType,
    required this.title,
    required this.requestContent,
    this.createDate,
    this.approvalDate,
    required this.requestStartDate,
    required this.requestEndDate,
    this.totalCost,
    required this.user,
    required this.userMail,
    required this.colleagues,
  });

  ApprovalModel.fromMap({required Map mapData, this.reference})
      : docIds = mapData["docIds"] ?? "",
        allDay = mapData["allDay"] ?? false,
        status = mapData["status"] ?? "대기",
        location = mapData["location"] ?? "",
        approvalContent = mapData["approvalContent"] ?? "",
        approvalUser = mapData["approvalUser"] ?? "",
        approvalMail = mapData["approvalMail"] ?? "",
        approvalType = mapData["approvalType"] ?? "",
        title = mapData["title"] ?? "",
        requestContent = mapData["requestContent"] ?? "",
        createDate = mapData["createDate"] ?? Timestamp.now(),
        approvalDate = mapData["approvalDate"] ?? Timestamp.now(),
        requestStartDate = mapData["requestStartDate"] ?? Timestamp.now(),
        requestEndDate = mapData["requestEndDate"] ?? Timestamp.now(),
        totalCost = mapData["totalCost"] ?? 0,
        user = mapData["user"] ?? Timestamp.now(),
        userMail = mapData["userMail"] ?? Timestamp.now(),
        colleagues = mapData["colleagues"] ?? [mapData["createUid"]];
  toJson(){
    return {
      "docIds": docIds ?? "",
      "allDay": allDay,
      "status": status,
      "location": location,
      "approvalContent": approvalContent,
      "approvalUser": approvalUser,
      "approvalMail": approvalMail,
      "approvalType": approvalType,
      "title": title,
      "requestContent": requestContent,
      "createDate": createDate ?? Timestamp.now(),
      "approvalDate": approvalDate ?? Timestamp.now(),
      "requestStartDate": requestStartDate,
      "requestEndDate": requestEndDate,
      "totalCost": totalCost ?? 0,
      "user": user,
      "userMail": userMail,
      "colleagues" : colleagues,
    };
  }
}