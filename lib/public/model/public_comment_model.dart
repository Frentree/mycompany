/*
공지사항 댓글 모델
  공지사항 댓글 내용 : comment
  공지사항 상위 댓글 내용: upComment
  공지사항 댓글 아이디 : commentId
  공지사항 댓글 입력일 : createDate
  공지사항 댓글 수정일 : modifyDate
  공지사항 댓글 작성자 메일 : uid
  공지사항 댓글 작성자 : uname
  공지사항 댓글 레벨
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String comment;
  String? commentId;
  String? upComment;
  String? upUid;
  String? upUname;
  Timestamp? createDate;
  Timestamp? modifyDate;
  String uid;
  String uname;
  int level;
  DocumentReference? reference;

  CommentModel({
    required this.comment,
    this.upComment,
    this.upUid,
    this.upUname,
    this.commentId,
    this.createDate,
    this.modifyDate,
    required this.uid,
    required this.uname,
    required this.level,
  });

  CommentModel.fromMap({required Map mapData, this.reference})
      : comment = mapData["comment"] ?? "",
        upComment = mapData["upComment"] ?? "",
        upUid = mapData["upUid"] ?? "",
        upUname = mapData["upUname"] ?? "",
        commentId = mapData["commentId"] ?? "",
        createDate = mapData["createDate"] ?? Timestamp.now(),
        modifyDate = mapData["modifyDate"] ?? Timestamp.fromDate(DateTime(1900,1,1,12,0,0)),
        uid = mapData["uid"],
        uname = mapData["uname"],
        level = mapData["level"];
  toJson(){
    return {
      "comment": comment,
      "upComment": upComment ?? "",
      "upUid": upUid ?? "",
      "upUname": upUname ?? "",
      "commentId": commentId ?? "",
      "createDate": createDate ?? Timestamp.now(),
      "modifyDate": modifyDate ?? Timestamp.fromDate(DateTime(1900,1,1,12,0,0)),
      "uid": uid,
      "uname": uname,
      "level": level,
    };
  }
}