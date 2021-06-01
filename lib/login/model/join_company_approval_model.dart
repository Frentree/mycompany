/*
회사 가입 신청 모델
승인 요청자 이메일 : requesterEmail
승인 요청자 이름 : requesterName
승인 요청자 전화번호 : requesterPhone
승인 요청자 생일 : requesterBirthday
승인 요청 일자 : requestDate
승인 상태 : approvalStatus
승인자 이메일 : approverEmail
승인자 이름 : approverName
승인 일자 : approvalDate


approvalStatus
0 : 승인 대기
1 : 승인 완료
2 : 승인 반려
*/

import 'package:cloud_firestore/cloud_firestore.dart';

class JoinCompanyApprovalModel {
  String requesterEmail;
  String requesterName;
  String? requesterPhone;
  Timestamp? requesterBirthday;
  Timestamp requestDate;
  int approvalStatus;
  String? approverEmail;
  String? approverName;
  Timestamp? approvalDate;

  JoinCompanyApprovalModel({
    required this.requesterEmail,
    required this.requesterName,
    this.requesterPhone,
    this.requesterBirthday,
    required this.requestDate,
    this.approvalStatus = 0,
    this.approverEmail,
    this.approverName,
    this.approvalDate,
  });

  JoinCompanyApprovalModel.fromMap({required Map mapData})
      : requesterEmail = mapData["requesterEmail"] ?? "",
        requesterName = mapData["requesterName"] ?? "",
        requesterPhone = mapData["requesterPhone"] ?? "",
        requesterBirthday = mapData["requesterBirthday"] ?? null,
        requestDate = mapData["requestDate"] ?? Timestamp.now(),
        approvalStatus = mapData["approvalStatus"] ?? 0,
        approverEmail = mapData["approverEmail"] ?? "",
        approverName = mapData["approverName"] ?? "",
        approvalDate = mapData["approvalDate"] ?? null;

  toJson() {
    return {
      "requesterEmail": requesterEmail,
      "requesterName": requesterName,
      "requesterPhone": requesterPhone,
      "requesterBirthday": requesterBirthday,
      "requestDate": requestDate,
      "approvalStatus": approvalStatus,
      "approverEmail": approverEmail,
      "approverName": approverName,
      "approvalDate": approvalDate,
    };
  }
}
