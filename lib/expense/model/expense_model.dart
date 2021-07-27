/*
경비 모델
   mail  : 사용자 메일
   name  : 사용자 이름
   companyCode : 회사 코드
   contentType : 경비 종류
   detailNote : 경비 내용
   imageUrl : 경비 영수증 이미지
   docId
   status : 결재 상태
   index
   cost : 가격
   isApproved
   isSelected
   createDate : 글작성일
   buyDate : 경비 사용일
   searchDate
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String mail;
  String name;
  String companyCode;
  String contentType;
  String? detailNote;
  String? imageUrl;
  String? docId;
  String status;
  int? index;
  int cost;
  bool? isApproved;
  bool? isSelected;
  Timestamp? createDate;
  Timestamp buyDate;
  Timestamp? searchDate;
  DocumentReference? reference;

  ExpenseModel({
    required this.mail,
    required this.name,
    required this.companyCode,
    required this.contentType,
    this.detailNote,
    this.imageUrl,
    this.docId,
    required this.status,
    this.index,
    required this.cost,
    this.isApproved,
    this.isSelected,
    this.createDate,
    required this.buyDate,
    this.searchDate,
  });

  ExpenseModel.fromMap({required Map mapData, this.reference})
      : mail = mapData["mail"],
        name = mapData["name"],
        companyCode = mapData["companyCode"],
        contentType = mapData["contentType"] ,
        detailNote = mapData["detailNote"] ?? "",
        imageUrl = mapData["imageUrl"] ?? "",
        docId = mapData["docId"] ?? "",
        status = mapData["status"],
        index = mapData["index"] ?? 0,
        cost = mapData["cost"] ?? 0,
        isApproved = mapData["isApproved"] ?? false,
        isSelected = mapData["isSelected"] ?? false,
        createDate = mapData["createDate"],
        buyDate = mapData["buyDate"],
        searchDate = mapData["searchDate"] ?? Timestamp.now();

  toJson(){
    return {
      "mail": mail,
      "name": name,
      "companyCode": companyCode,
      "contentType": contentType,
      "detailNote": detailNote,
      "imageUrl": imageUrl ?? "",
      "docId": docId ?? "",
      "status": status,
      "index": index,
      "cost": cost,
      "isApproved": isApproved ?? false,
      "isSelected": isSelected ?? false,
      "createDate": createDate ?? Timestamp.now(),
      "buyDate": buyDate,
      "searchDate": searchDate ?? Timestamp.now(),
    };
  }
}