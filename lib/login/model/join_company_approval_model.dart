/*
회사 가입 신청 모델
승인 요청자 이메일 : mail
승인 요청자 이름 : name
승인 요청자 전화번호 : phone
승인 요청자 생일 : birthday
승인 요청 일자 : requestDate
승인 상태 : state
승인자 이메일 : signUpApprover
승인 일자 : approvalDate
퇴사 날짜 : resignationDate
퇴사승인자 : resignationApprover


state
0 : 승인 대기
1 : 승인 완료
2 : 승인 반려
3 : 퇴사
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class JoinCompanyApprovalModel {
  String? documentId;
  String mail;
  String name;
  String? phone;
  String? birthday;
  Timestamp requestDate;
  int state;
  String? signUpApprover;
  Timestamp? approvalDate;
  Timestamp? resignationDate;
  String? resignationApprover;

  JoinCompanyApprovalModel({
    this.documentId,
    required this.mail,
    required this.name,
    this.phone,
    this.birthday,
    required this.requestDate,
    this.state = 0,
    this.signUpApprover,
    this.approvalDate,
    this.resignationApprover,
    this.resignationDate,
  });

  JoinCompanyApprovalModel.fromMap({required Map mapData, String? documentId})
      : documentId = documentId ?? "",
        mail = mapData["mail"] ?? "",
        name = mapData["name"] ?? "",
        phone = mapData["phone"] ?? "",
        birthday = mapData["birthday"] ?? "",
        requestDate = mapData["requestDate"] ?? Timestamp.now(),
        state = mapData["state"] ?? 0,
        signUpApprover = mapData["signUpApprover"] ?? "",
        approvalDate = mapData["approvalDate"] ?? null,
        resignationApprover = mapData["resignationApprover"] ?? "",
        resignationDate = mapData["resignationDate"] ?? null;

  toJson() {
    return {
      "mail": mail,
      "name": name,
      "phone": phone,
      "birthday": birthday,
      "requestDate": requestDate,
      "state": state,
      "signUpApprover": signUpApprover,
      "approvalDate": approvalDate,
      "resignationApprover": resignationApprover,
      "resignationDate": resignationDate,
    };
  }
}
