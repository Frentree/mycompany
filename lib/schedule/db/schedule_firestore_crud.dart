

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/schedule/model/approval_model.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';

class ScheduleFirebaseCurd {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<QuerySnapshot> getSchedules(String? companyCode) async {
    List<String> mailList = [];
    for(var data in mailChkList){
      mailList.add(data.mail);
    }

    return await _store.collection("company").doc(companyCode).collection("work").where("createUid", whereIn: mailList).get();
  }

  Future<QuerySnapshot> getCompanyUser(String? companyCode) async {
    return await _store.collection("company").doc(companyCode).collection("user").where("mail", isNotEqualTo: "bsc2079@naver.com").get();
  }

  Future<QuerySnapshot> getTeamDocument(String? companyCode) async {
    return await _store.collection("company").doc(companyCode).collection("team").get();
  }

  Future<QuerySnapshot> getEmployeeDocument(String? companyCode) async {
    return await _store.collection("company").doc(companyCode).collection("user").get();
  }

  /*
  *  스케줄 등록 Doc
  *  내근, 기타, 미팅 결재 x
  *  외근 스케줄 등록 후 결재 진행
  *  외출, 재택, 연차,  휴가등 결재 후 스케줄 등록
  *
  * */
  Future<bool> insertWorkDocument(WorkModel workModel, CompanyUserModel? approvalUser, String companyCode) async {
    bool isResult = false;
    switch(workModel.type) {
      case "내근": case "미팅":
        await _store.collection("company").doc(companyCode).collection("work").add(workModel.toJson());
        isResult = true;
        break;
      case "외근": case "요청":
        await _store.collection("company").doc(companyCode).collection("work").add(workModel.toJson()).then((value) => insertWorkApproval(workModel, approvalUser!, companyCode, value.id));
        isResult = true;
        break;

      case "재택": case "외출": case "연차" : case "Annual":
        await insertWorkApproval(workModel, approvalUser!, companyCode, null);
        isResult = true;
        break;
    }

    if(workModel.type == "기타" && approvalUser!.mail == ""){
      await _store.collection("company").doc(companyCode).collection("work").add(workModel.toJson());
      isResult = true;
    }else if(workModel.type == "기타" && approvalUser!.mail != "") {
      await _store.collection("company").doc(companyCode).collection("work").add(workModel.toJson()).then((value) => insertWorkApproval(workModel, approvalUser, companyCode, value.id));
      isResult = true;
    }

    return isResult;
  }

  /*
  *  결재 Doc
  *
  * */
  Future<void> insertWorkApproval(WorkModel workModel, CompanyUserModel approvalUser, String companyCode, String? docId) async {
    ApprovalModel model = ApprovalModel(
      docIds: docId,
      allDay: workModel.allDay,
      approvalMail: approvalUser.mail,
      approvalUser: approvalUser.name,
      colleagues: workModel.colleagues,
      title: workModel.title,
      location: workModel.location!,
      approvalType: workModel.type,
      user: workModel.name,
      userMail: workModel.createUid,
      requestContent: workModel.content,
      status: "대기",
      requestStartDate: workModel.startTime,
      requestEndDate: workModel.endTime!,
    );

    await _store.collection("company").doc(companyCode).collection("workApproval").add(model.toJson());
  }

  // 결재 내역 확인 있으면 삭제 불가능
  Future<bool> getApprovalListSizeDocument(String companyCode, String documentId) async {
    bool isResult = false;

    await _store.collection("company").doc(companyCode).collection("workApproval").where("docIds", isEqualTo: documentId).where("status", isEqualTo: "대기").get().then((value) {
      if(value.size < 1) {
        isResult = true;
      }
    });

    return isResult;
  }

  // 일정 삭제
  Future<bool> deleteScheduleDocument(String companyCode, String documentId) async {
    bool isResult = false;

    await _store.collection("company").doc(companyCode).collection("work").doc(documentId).delete().whenComplete(() => {isResult = true});

    return isResult;
  }

  /*
  * 결재 승인 반려 Doc
  *
  *
  * */
  Future<bool> updateWorkApproval(ApprovalModel model, String companyCode, String approval) async {
    bool isResult = false;

    WorkModel workModel = WorkModel(
      allDay: model.allDay,
      type: model.approvalType,
      title: model.title,
      content: model.requestContent,
      location: model.location,
      startTime: model.requestStartDate,
      endTime: model.requestEndDate,
      colleagues: model.colleagues,
      name: model.approvalType == "요청" ? model.user : model.approvalUser,
      createUid: model.approvalType == "요청" ? model.userMail : model.approvalMail,
      createDate: model.createDate
    );

    if(approval == "승인"){
      switch(model.approvalType) {
        case "재택": case "외출": case "연차" : case "Annual":
          await _store.collection("company").doc(companyCode).collection("work").add(workModel.toJson());
          break;
      }
    } else if(approval == "반려") {
      switch(model.approvalType) {
        case "기타": case "외근": case "요청":
          await _store.collection("company").doc(companyCode).collection("work").doc(model.docIds).delete();
          break;
      }
    }

    // 결재 상태 변경
    await _store.collection("company").doc(companyCode).collection("workApproval").doc(model.reference!.id).update(model.toJson())
        .onError((error, stackTrace) => {isResult = false}).whenComplete(() => {isResult = true});

    return isResult;

  }
}