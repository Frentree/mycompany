/*
회사 가입 사용자 모델
기기토큰값 : token
이메일 : mail
이름 : name
전화번호 : phone
생일 : birthday
계좌 : account
회사ID : companyId
회사가입일 : joinedDate
입사일 : enteredDate
정보수정일 : modifiedDate
프로필사진 : profile
팀 : team
직급 : position
권한 : authority
사용자검색 : userSearch

team

position

authority
List[0] : 일반사용자
List[1] : 업무관리자
List[2] : 앱관리자
List[3] : 회계담담자
List[4] : 최고관리자
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyUserModel {
  String? token;
  String mail;
  String name;
  String? phone;
  String? birthday;
  String? account;
  String companyId;
  Timestamp joinedDate;
  String? enteredDate;
  Timestamp? modifiedDate;
  String? profilePhoto;
  int? teamNum;
  String? team;
  int? positionNum;
  String? position;
  List<int>? authority;
  List<dynamic> userSearch;

  CompanyUserModel({
    this.token,
    required this.mail,
    required this.name,
    this.phone,
    this.birthday,
    this.account,
    required this.companyId,
    required this.joinedDate,
    this.enteredDate,
    this.modifiedDate,
    this.profilePhoto,
    this.teamNum,
    this.team,
    this.positionNum,
    this.position,
    this.authority = const <int>[1, 0, 0, 0, 0],
    required this.userSearch,
  });

  CompanyUserModel.fromMap({required Map mapData})
      : token = mapData["token"] ?? "",
        mail = mapData["mail"] ?? "",
        name = mapData["name"] ?? "",
        phone = mapData["phone"] ?? "",
        birthday = mapData["birthday"] ?? "",
        account = mapData["account"] ?? "",
        companyId = mapData["companyId"] ?? "",
        joinedDate = mapData["joinedDate"] ?? Timestamp.now(),
        enteredDate = mapData["enteredDate"] ?? Timestamp.now(),
        modifiedDate = mapData["modifiedDate"] ?? Timestamp.now(),
        profilePhoto = mapData["profilePhoto"] ?? "",
        teamNum = mapData["teamNum"] ?? 999,
        team = mapData["team"] ?? "",
        positionNum = mapData["positionNum"] ?? 999,
        position = mapData["position"] ?? "",
        authority = mapData["authority"] ?? [1, 0, 0, 0, 0],
        userSearch = mapData["userSearch"] ?? [];

  toJson(){
    return {
      "token": token,
      "mail": mail,
      "name": name,
      "phone": phone,
      "birthday": birthday,
      "account": account,
      "companyId": companyId,
      "joinedDate": joinedDate,
      "enteredDate": enteredDate,
      "modifiedDate": modifiedDate,
      "profilePhoto": profilePhoto ?? "",
      "teamNum" : teamNum ?? 999,
      "team": team ?? "",
      "positionNum" : positionNum ?? 999,
      "position": position ?? "",
      "authority": authority,
      "userSearch": userSearch,
    };
  }
}
