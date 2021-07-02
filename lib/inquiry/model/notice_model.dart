/*
공지사항 모델
  공지사항 제목 : noticeTitle
  공지사항 내용 : noticeContent
  공지사항 입력일 : noticeCreateDate
  공지사항 수정일 : noticeModifyDate
  공지사항 작성자 메일 : noticeUid
  공지사항 작성자 : noticeUname
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  String noticeTitle;
  String noticeContent;
  Timestamp? noticeCreateDate;
  Timestamp? noticeModifyDate;
  String noticeUid;
  String noticeUname;
  DocumentReference? reference;

  NoticeModel({
    required this.noticeTitle,
    required this.noticeContent,
    this.noticeCreateDate,
    this.noticeModifyDate,
    required this.noticeUid,
    required this.noticeUname,
  });

  NoticeModel.fromMap({required Map mapData, this.reference})
      : noticeTitle = mapData["noticeTitle"] ?? "",
        noticeContent = mapData["noticeContent"] ?? "",
        noticeCreateDate = mapData["noticeCreateDate"] ?? Timestamp.now(),
        noticeModifyDate = mapData["noticeModifyDate"] ?? Timestamp.fromDate(DateTime(1900,1,1,12,0,0)),
        noticeUid = mapData["noticeUid"],
        noticeUname = mapData["noticeUname"];
  toJson(){
    return {
      "noticeTitle": noticeTitle,
      "noticeContent": noticeContent,
      "noticeCreateDate": noticeCreateDate ?? Timestamp.now(),
      "noticeModifyDate": noticeModifyDate ?? Timestamp.fromDate(DateTime(1900,1,1,12,0,0)),
      "noticeUid": noticeUid,
      "noticeUname": noticeUname,
    };
  }
}