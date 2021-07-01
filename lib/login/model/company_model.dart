/*
회사 모델
회사ID : companyCode
회사명 : companyName
회사주소 : companyAddr
회사전화번호 : companyPhone
로고 : companyPhoto
사업자번호 : companyNo
웹페이지주소 : companyWeb
회사검색: companySearch
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  String companyCode;
  String companyName;
  String companyAddr;
  String? companyPhone;
  String? companyPhoto;
  String? companyNo;
  String? companyWeb;
  List<dynamic>? companySearch;
  int vacation;

  CompanyModel({
    required this.companyCode,
    required this.companyName,
    required this.companyAddr,
    this.companyPhone,
    this.companyPhoto,
    this.companyNo,
    this.companyWeb,
    this.companySearch,
    this.vacation = 0,
  });

  CompanyModel.fromMap({required Map mapData})
      : companyCode = mapData["companyCode"] ?? "",
        companyName = mapData["companyName"] ?? "",
        companyAddr = mapData["companyAddr"] ?? "",
        companyPhone = mapData["companyPhone"] ?? "",
        companyPhoto = mapData["companyPhoto"] ?? "",
        companyNo = mapData["companyNo"] ?? "",
        companyWeb = mapData["companyWeb"] ?? "",
        companySearch = mapData["companySearch"] ?? [],
        vacation = mapData["vacation"] ?? 0;

  toJson(){
    return {
      "companyCode": companyCode,
      "companyName": companyName,
      "companyAddr": companyAddr,
      "companyPhone": companyPhone,
      "companyPhoto": companyPhoto,
      "companyNo": companyNo,
      "webUrl": companyWeb,
      "companySearch": companyName.split(""),
      "vacation": vacation,
    };
  }
}
