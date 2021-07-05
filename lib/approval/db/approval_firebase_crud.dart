import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/attendance/db/attendance_firestore_repository.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class ApprovalFirebaseCurd {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  ApprovalFirebaseCurd.setting({persistenceEnabled: true});
  DateFormatCustom _formatCustom = DateFormatCustom();

  Future<List<ApprovalModel>> getRequestApprovalData(UserModel loginUser) async {
    List<ApprovalModel> approvalList = [];
    var doc = await _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORKAPPROVAL).where("userMail", isEqualTo: loginUser.mail).get();

    doc.docs.map((e) => approvalList.add(ApprovalModel.fromMap(mapData: e.data(), reference: e.reference))).toList();

    approvalList.sort((a, b) => b.createDate!.compareTo(a.createDate!));

    return approvalList;
  }

  Stream<QuerySnapshot> getRequestApprovalDataSnashot(UserModel loginUser) {
    return _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORKAPPROVAL).where("userMail", isEqualTo: loginUser.mail).snapshots();
  }

  Future<List<ApprovalModel>> getResponseApprovalData(UserModel loginUser) async {
    List<ApprovalModel> approvalList = [];

    var doc = await _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORKAPPROVAL).where("approvalMail", isEqualTo: loginUser.mail).get();

    doc.docs.map((e) => approvalList.add(ApprovalModel.fromMap(mapData: e.data(), reference: e.reference))).toList();

    approvalList.sort((a, b) => b.createDate!.compareTo(a.createDate!));

    return approvalList;
  }

  Stream<QuerySnapshot> getResponseApprovalDataSnashot(UserModel loginUser) {
    return _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORKAPPROVAL).where("approvalMail", isEqualTo: loginUser.mail).snapshots();
  }

  Stream<QuerySnapshot> getResponseApprovalDataCount(UserModel loginUser){
    return _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORKAPPROVAL).where("approvalMail", isEqualTo: loginUser.mail)
        .where("status", isEqualTo: "요청")
        .snapshots();
  }

  /*
  *  결재 Doc
  *
  * */
  Future<bool> insertWorkApproval(WorkModel workModel, EmployeeModel approvalUser, UserModel loginUser, String? docId) async {
    ApprovalModel model = ApprovalModel(
      workIds: docId,
      allDay: workModel.allDay,
      approvalMail: approvalUser.mail,
      approvalUser: approvalUser.name,
      colleagues: workModel.colleagues,
      title: workModel.title,
      location: workModel.location!,
      approvalType: workModel.type,
      user: workModel.type == "요청" ? loginUser.name : workModel.name,
      userMail: workModel.type == "요청" ? loginUser.mail : workModel.createUid,
      requestContent: workModel.contents,
      status: "요청",
      requestStartDate: workModel.startTime,
      requestEndDate: workModel.endTime!,
    );
    bool isResult = false;

    await _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORKAPPROVAL).add(model.toJson()).whenComplete(() => {isResult = true});

    return isResult;
  }

  /*
  *  결재 요청 취소
  *
  * */
  Future<bool> requestApprovalCencel(ApprovalModel model, String companyCode) async {
    bool isResult = false;

    switch(model.approvalType) {
      case "외근":
      case "요청":
        await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(model.workIds).delete();
        break;
    }

    await _store.collection(COMPANY).doc(companyCode).collection(WORKAPPROVAL).doc(model.reference!.id).delete().whenComplete(() {isResult = true;});

    return isResult;

  }


  /*
  * 결재 승인 완료
  *
  *
  * */
  Future<bool> updateWorkApproval(ApprovalModel model, String companyCode, String approval, String content) async {
    bool isResult = false;

    WorkModel workModel = WorkModel(
      allDay: model.allDay,
      type: model.approvalType,
      title: model.title,
      contents: model.requestContent,
      location: model.location,
      startTime: model.requestStartDate,
      endTime: model.requestEndDate,
      colleagues: model.colleagues,
      name: model.approvalType == "요청" ? model.approvalUser :  model.user,
      createUid: model.approvalType == "요청" ? model.approvalMail : model.userMail,
      createDate: model.createDate,
    );

    model.status = approval;
    model.approvalDate = Timestamp.now();
    model.approvalContent = content;

    if(approval == "승인"){
      switch(model.approvalType) {
        case "재택": case "외출": case "연차": case "반차":
        await _store.collection(COMPANY).doc(companyCode).collection(WORK).add(workModel.toJson());
        break;
      }
      if(model.approvalType == "연차") {
        AttendanceFirestoreRepository().createAttendanceData(
          companyId: companyCode,
          attendanceModel: AttendanceModel(
              mail: model.userMail,
              name: model.user,
              createDate: _formatCustom.updateAttendance(date: model.requestStartDate),
              status: 5
          )
        );
      }
    } else if(approval == "반려") {
      switch(model.approvalType) {
        case "기타": case "외근": case "요청":
        await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(model.workIds).delete();
        break;
      }
    }


    // 결재 상태 변경
    await _store.collection(COMPANY).doc(companyCode).collection(WORKAPPROVAL).doc(model.reference!.id).update(model.toJson())
        .onError((error, stackTrace) => {isResult = false}).whenComplete(() => {isResult = true});

    return isResult;

  }
}