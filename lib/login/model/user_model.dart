/*
App 가입 사용자 모델
기기토큰값 : tokenId
이메일 : email
이름 : name
전화번호 : phone
생일 : birthday
계좌 : account
가입일 : createDate
정보수정일 : modifiedDate
회사ID : companyId
회사가입상태 : joinStatus

joinStatus
0 : 가입신청안함(기본값)
1 : 승인 대기
2 : 승인 완료
3 : 승인 반려
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? tokenId;
  String email;
  String name;
  String? phone;
  Timestamp? birthday;
  String? account;
  Timestamp? createDate;
  Timestamp? modifiedDate;
  String? companyId;
  int joinStatus;

  UserModel({
    this.tokenId,
    required this.email,
    required this.name,
    this.phone,
    this.birthday,
    this.account,
    this.createDate,
    this.modifiedDate,
    this.companyId,
    this.joinStatus = 0,
  });

  UserModel.fromMap({required Map mapData})
      : tokenId = mapData["tokenId"] ?? "",
        email = mapData["email"] ?? "",
        name = mapData["name"] ?? "",
        phone = mapData["phone"] ?? "",
        birthday = mapData["birthday"] ?? null,
        account = mapData["account"] ?? "",
        createDate = mapData["createDate"] ?? Timestamp.now(),
        modifiedDate = mapData["modifiedDate"] ?? Timestamp.now(),
        companyId = mapData["companyId"] ?? "",
        joinStatus = mapData["joinStatus"] ?? 0;

  toJson() {
    return {
      "tokenId": tokenId,
      "email": email,
      "name": name,
      "phone": phone,
      "birthday": birthday,
      "account": account,
      "createDate": createDate,
      "modifiedDate": modifiedDate,
      "companyId": companyId,
      "joinStatus": joinStatus,
    };
  }
}
