/*
App 가입 사용자 모델
기기토큰값 : token
이메일 : mail
이름 : name
전화번호 : phone
생일 : birthday
가입일 : createDate
정보수정일 : lastModDate
회사ID : companyCode
회사가입상태 : state
프로필사진 : profilePhoto
기기ID : deviceId

state
0 : 가입신청안함(기본값)
1 : 승인 대기
2 : 승인 완료
3 : 승인 반려
4 : 회사 퇴사
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? token;
  String mail;
  String name;
  String? phone;
  String? birthday;
  Timestamp? createDate;
  Timestamp? lastModDate;
  String? companyCode;
  int state;
  String? profilePhoto;
  String? deviceId;

  UserModel({
    this.token,
    required this.mail,
    required this.name,
    this.phone,
    this.birthday,
    this.createDate,
    this.lastModDate,
    this.companyCode,
    this.state = 0,
    this.profilePhoto,
    this.deviceId,
  });

  UserModel.fromMap({required Map mapData})
      : token = mapData["token"] ?? "",
        mail = mapData["mail"] ?? "",
        name = mapData["name"] ?? "",
        phone = mapData["phone"] ?? "",
        birthday = mapData["birthday"] ?? "",
        createDate = mapData["createDate"] ?? Timestamp.now(),
        lastModDate = mapData["lastModDate"] ?? Timestamp.now(),
        companyCode = mapData["companyCode"] ?? "",
        state = mapData["state"] ?? 0,
        profilePhoto = mapData["profilePhoto"] ?? "",
        deviceId = mapData["deviceId"] ?? "";

  toJson() {
    return {
      "token": token,
      "mail": mail,
      "name": name,
      "phone": phone,
      "birthday": birthday,
      "createDate": createDate,
      "lastModDate": lastModDate,
      "companyCode": companyCode,
      "state": state,
      "profilePhoto": profilePhoto,
      "deviceId": deviceId,
    };
  }
}
