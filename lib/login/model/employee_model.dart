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
팀번호 : teamNum
팀 : team
직급번호 : positionNum
직급 : position
권한 : level
사용자검색 : userSearch
상태 : status
사번 : employeeNum

status
0 : 회사 다님
1 : 회사 퇴사
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
  int? teamNum;
  String? team;
  int? positionNum;
  String? position;
  List<dynamic>? level;
  List<dynamic>? userSearch;
  String? employeeNum;
  int? status;
  num? vacation;
  DocumentReference? reference;

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
    this.teamNum,
    this.team,
    this.positionNum,
    this.position,
    this.level,
    this.userSearch,
    this.employeeNum,
    this.status,
    this.vacation,
  });

  EmployeeModel.fromMap({required Map mapData, this.reference})
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
        teamNum = mapData["teamNum"] ?? 999,
        team = mapData["team"] ?? "",
        positionNum = mapData["positionNum"] ?? 999,
        position = mapData["position"] ?? "",
        level = mapData["level"] ?? [],
        userSearch = mapData["userSearch"] ?? [],
        employeeNum = mapData["employeeNum"] ?? "",
        status = mapData["status"] ?? 0,
        vacation = mapData["vacation"] ?? 0.0;

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
      "teamNum": teamNum ?? 999,
      "team": team ?? "",
      "positionNum": positionNum ?? 999,
      "position": position ?? "",
      "level": level ?? [0],
      "userSearch": name.split(""),
      "employeeNum": employeeNum,
      "status": status,
      "vacation": vacation ?? 0.0,
    };
  }
}
