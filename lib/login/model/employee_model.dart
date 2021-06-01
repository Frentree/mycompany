/*
회사 가입 사용자 모델
기기토큰값 : tokenId
이메일 : email
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

class EmployeeModel {
  String? tokenId;
  String email;
  String name;
  String? phone;
  Timestamp? birthday;
  String? account;
  String companyId;
  Timestamp joinedDate;
  Timestamp? enteredDate;
  Timestamp? modifiedDate;
  String? profile;
  int? team;
  int? position;
  List<dynamic>? authority;
  List<dynamic>? userSearch;

  EmployeeModel({
    this.tokenId,
    required this.email,
    required this.name,
    this.phone,
    this.birthday,
    this.account,
    required this.companyId,
    required this.joinedDate,
    this.enteredDate,
    this.modifiedDate,
    this.profile,
    this.team,
    this.position,
    this.authority = const <int>[1, 0, 0, 0, 0],
    this.userSearch,
  });

  EmployeeModel.fromMap({required Map mapData})
      : tokenId = mapData["tokenId"] ?? "",
        email = mapData["email"] ?? "",
        name = mapData["name"] ?? "",
        phone = mapData["phone"] ?? "",
        birthday = mapData["birthday"] ?? null,
        account = mapData["account"] ?? "",
        companyId = mapData["companyId"] ?? "",
        joinedDate = mapData["joinedDate"] ?? Timestamp.now(),
        enteredDate = mapData["enteredDate"] ?? Timestamp.now(),
        modifiedDate = mapData["modifiedDate"] ?? Timestamp.now(),
        profile = mapData["profile"] ?? "",
        team = mapData["team"] ?? null,
        position = mapData["position"] ?? null,
        authority = mapData["authority"] ?? [1, 0, 0, 0, 0],
        userSearch = mapData["userSearch"] ?? [];

  toJson(){
    return {
      "tokenId": tokenId,
      "email": email,
      "name": name,
      "phone": phone,
      "birthday": birthday,
      "account": account,
      "companyId": companyId,
      "joinedDate": joinedDate,
      "enteredDate": enteredDate,
      "modifiedDate": modifiedDate,
      "profile": profile,
      "team": team,
      "position": position,
      "authority": authority,
      "userSearch": name.split(""),
    };
  }
}
