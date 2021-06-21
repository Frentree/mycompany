/*
회사 가입 사용자 모델
기기토큰값 : token
이메일 : mail
이름 : name
전화번호 : phone
생일 : birthday
계좌 : account
회사ID : companyCode
회사가입일 : createDate
입사일 : enteredDate
정보수정일 : lastModDate
프로필사진 : profilePhoto
팀 : team
직급 : position
권한 : level
사용자검색 : userSearch
상태 : status
사번 : employeeNum
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeModel {
  String? token;
  String mail;
  String name;
  String? phone;
  String? birthday;
  String? account;
  String companyCode;
  Timestamp createDate;
  String? enteredDate;
  Timestamp? lastModDate;
  String? profilePhoto;
  String? team;
  String? position;
  List<dynamic>? level;
  List<dynamic>? userSearch;
  String? employeeNum;
  int? status;

  EmployeeModel({
    this.token,
    required this.mail,
    required this.name,
    this.phone,
    this.birthday,
    this.account,
    required this.companyCode,
    required this.createDate,
    this.enteredDate,
    this.lastModDate,
    this.profilePhoto,
    this.team,
    this.position,
    this.level,
    this.userSearch,
    this.employeeNum,
    this.status,
  });

  EmployeeModel.fromMap({required Map mapData})
      : token = mapData["token"] ?? "",
        mail = mapData["mail"] ?? "",
        name = mapData["name"] ?? "",
        phone = mapData["phone"] ?? "",
        birthday = mapData["birthday"] ?? "",
        account = mapData["account"] ?? "",
        companyCode = mapData["companyCode"] ?? "",
        createDate = mapData["createDate"] ?? Timestamp.now(),
        enteredDate = mapData["enteredDate"] ?? "",
        lastModDate = mapData["lastModDate"] ?? Timestamp.now(),
        profilePhoto = mapData["profilePhoto"] ?? "",
        team = mapData["team"] ?? "",
        position = mapData["position"] ?? "",
        level = mapData["level"] ?? [],
        userSearch = mapData["userSearch"] ?? [],
        employeeNum = mapData["employeeNum"] ?? "",
        status = mapData["status"] ?? 0;

  toJson(){
    return {
      "token": token,
      "mail": mail,
      "name": name,
      "phone": phone,
      "birthday": birthday,
      "account": account,
      "companyCode": companyCode,
      "createDate": createDate,
      "enteredDate": enteredDate,
      "lastModDate": lastModDate,
      "profilePhoto": profilePhoto ?? "",
      "team": team ?? "",
      "position": position ?? "",
      "level": level,
      "userSearch": name.split(""),
      "employeeNum": employeeNum,
      "status": status,
    };
  }
}
