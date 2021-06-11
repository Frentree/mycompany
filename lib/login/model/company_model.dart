/*
회사 모델
회사ID : companyId
회사생성일 : createDate;
정보수정일 : modifiedDate;
회사명 : companyName
회사주소 : companyAddress
회사전화번호 : companyPhone
로고 : companyLogo
사업자번호 : businessNumber
웹페이지주소 : webUrl
회사검색: companySearch
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyModel {
  String companyId;
  Timestamp? createDate;
  Timestamp? modifiedDate;
  String companyName;
  String companyAddress;
  String? companyPhone;
  String? companyLogo;
  String? businessNumber;
  String? webUrl;
  List<dynamic>? companySearch;

  CompanyModel({
    required this.companyId,
    this.createDate,
    this.modifiedDate,
    required this.companyName,
    required this.companyAddress,
    this.companyPhone,
    this.companyLogo,
    this.businessNumber,
    this.webUrl,
    this.companySearch,
  });

  CompanyModel.fromMap({required Map mapData})
      : companyId = mapData["companyId"] ?? "",
        createDate = mapData["createDate"] ?? Timestamp.now(),
        modifiedDate = mapData["modifiedDate"] ?? Timestamp.now(),
        companyName = mapData["companyName"] ?? "",
        companyAddress = mapData["companyAddress"] ?? "",
        companyPhone = mapData["companyPhone"] ?? "",
        companyLogo = mapData["companyLogo"] ?? "",
        businessNumber = mapData["businessNumber"] ?? "",
        webUrl = mapData["webUrl"] ?? "",
        companySearch = mapData["companySearch"] ?? [];

  toJson(){
    return {
      "companyId": companyId,
      "createDate": createDate,
      "modifiedDate": modifiedDate,
      "companyName": companyName,
      "companyAddress": companyAddress,
      "companyPhone": companyPhone,
      "companyLogo": companyLogo,
      "businessNumber": businessNumber,
      "webUrl": webUrl,
      "companySearch": companyName.split(""),
    };
  }
}
