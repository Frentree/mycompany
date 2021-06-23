/*
공지사항 댓글 모델
  공지사항 댓글 내용 : noticeComment
  공지사항 상위 댓글 내용: noticeUpComment
  공지사항 댓글 아이디 : noticeCommentId
  공지사항 댓글 입력일 : noticeCreateDate
  공지사항 댓글 수정일 : noticeModifyDate
  공지사항 댓글 작성자 메일 : noticeUid
  공지사항 댓글 작성자 : noticeUname
  공지사항 댓글 레벨
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeCommentModel {
  String noticeComment;
  String? noticeCommentId;
  String? noticeUpComment;
  String? noticeUpUid;
  String? noticeUpUname;
  Timestamp? noticeCreateDate;
  Timestamp? noticeModifyDate;
  String noticeUid;
  String noticeUname;
  int level;
  DocumentReference? reference;

  NoticeCommentModel({
    required this.noticeComment,
    this.noticeUpComment,
    this.noticeUpUid,
    this.noticeUpUname,
    this.noticeCommentId,
    this.noticeCreateDate,
    this.noticeModifyDate,
    required this.noticeUid,
    required this.noticeUname,
    required this.level,
  });

  NoticeCommentModel.fromMap({required Map mapData, this.reference})
      : noticeComment = mapData["noticeComment"] ?? "",
        noticeUpComment = mapData["noticeUpComment"] ?? "",
        noticeUpUid = mapData["noticeUpUid"] ?? "",
        noticeUpUname = mapData["noticeUpUname"] ?? "",
        noticeCommentId = mapData["noticeCommentId"] ?? "",
        noticeCreateDate = mapData["noticeCreateDate"] ?? Timestamp.now(),
        noticeModifyDate = mapData["noticeModifyDate"] ?? Timestamp.fromDate(DateTime(1900,1,1,12,0,0)),
        noticeUid = mapData["noticeUid"],
        noticeUname = mapData["noticeUname"],
        level = mapData["level"];
  toJson(){
    return {
      "noticeComment": noticeComment,
      "noticeUpComment": noticeUpComment ?? "",
      "noticeUpUid": noticeUpUid ?? "",
      "noticeUpUname": noticeUpUname ?? "",
      "noticeCommentId": noticeCommentId ?? "",
      "noticeCreateDate": noticeCreateDate ?? Timestamp.now(),
      "noticeModifyDate": noticeModifyDate ?? Timestamp.fromDate(DateTime(1900,1,1,12,0,0)),
      "noticeUid": noticeUid,
      "noticeUname": noticeUname,
      "level": level,
    };
  }
}