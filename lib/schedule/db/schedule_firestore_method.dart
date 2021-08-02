

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/model/public_comment_model.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';

class ScheduleFirebaseMethods {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  ScheduleFirebaseMethods.setting({persistenceEnabled: true});

  ApprovalFirebaseRepository approvalRepository = ApprovalFirebaseRepository();

  Future<QuerySnapshot> getSchedules(String? companyCode) async {

    var result = await _store.collection(COMPANY).doc(companyCode).collection(WORK).where("colleagues", isGreaterThan: mailChkList).get();

    return result;
  }
  
  
  Future<QuerySnapshot> getCompanyUser(UserModel loginUser) async {
    return await _store.collection(COMPANY).doc(loginUser.companyCode).collection(USER).where("mail", isNotEqualTo: loginUser.mail).get();
  }

  Future<QuerySnapshot> getMyAndCompanyUser(String? companyCode) async {
    return await _store.collection(COMPANY).doc(companyCode).collection(USER).get();
  }

  Future<QuerySnapshot> getTeamDocument(String? companyCode) async {
    return await _store.collection(COMPANY).doc(companyCode).collection(TEAM).get();
  }

  Future<QuerySnapshot> getEmployeeDocument(String? companyCode) async {
    return await _store.collection(COMPANY).doc(companyCode).collection(USER).get();
  }

  /*
  *  스케줄 등록 Doc
  *  내근, 기타, 미팅 결재 x
  *  외근 스케줄 등록 후 결재 진행
  *  외출, 재택, 연차,  휴가등 결재 후 스케줄 등록
  *
  * */
  Future<bool> insertWorkNotApprovalDocument(WorkModel workModel, String companyCode) async {
    bool isResult = false;

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).add(workModel.toJson()).whenComplete(() => {isResult = true});

    return isResult;
  }

  Future<bool> insertWorkApprovalDocument(WorkModel workModel, EmployeeModel approvalUser, UserModel loginUser) async {
    bool isResult = false;
    await _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORK).add(workModel.toJson()).then((value) => approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser, loginUser: loginUser, docId: value.id)).whenComplete(() => {isResult = true});

    return isResult;
  }

  Future<bool> updateWorkNotApprovalDocument(WorkModel workModel, String companyCode, String documentId) async {
    bool isResult = false;

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(documentId).set(workModel.toJson()).whenComplete(() => {isResult = true});

    return isResult;
  }

  Future<bool> updateWorkApprovalDocument(WorkModel workModel, EmployeeModel approvalUser, UserModel loginUser, String documentId) async {
    bool isResult = false;

    await _store.collection(COMPANY).doc(loginUser.companyCode).collection(WORK).doc(documentId).set(workModel.toJson()).then((value) => approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser, loginUser: loginUser, docId: documentId)).whenComplete(() => {isResult = true});

    return isResult;
  }

  // 결재 내역 확인 있으면 삭제 불가능
  Future<bool> getApprovalListSizeDocument(String companyCode, String documentId) async {
    bool isResult = false;

    await _store.collection(COMPANY).doc(companyCode).collection(WORKAPPROVAL).where("workIds", isEqualTo: documentId).where("status", isEqualTo: "요청").get().then((value) {
      if(value.size < 1) {
        isResult = true;
      }
    });

    return isResult;
  }

  // 일정 삭제
  Future<bool> deleteScheduleDocument(String companyCode, String documentId) async {
    bool isResult = false;

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(documentId).delete().whenComplete(() => {isResult = true});

    return isResult;
  }

  Future<void> workColleaguesUpdate(String companyCode) async {
     /*await _store.collection(COMPANY).doc(companyCode).collection(WORK).get().then((value) => value.docs.map((e) {
       final work = WorkModel.fromMap(mapData: e.data());

       if(work.colleagues!.length != 0) {
         List<Map<String,String>> map = [{work.createUid : work.name}];
         e.reference.update({"colleagues" : map});
       }
     }).toList());*/

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).get().then((value) =>value.docs.map((e) {
      final work = WorkModel.fromMap(mapData: e.data());
      print(e.data().containsKey("endTime"));

      if(work.colleagues!.length != 0) {
        List<Map<String,String>> map = [{work.createUid : work.name}];
        e.reference.update({"colleagues" : map});
      }
      if(!e.data().containsKey("endTime")){
          e.reference.update({"endTime" : work.startTime});
        }
      }).toList());

  }

  Future<int> workColleaguesDelete(String companyCode, String documentId, List<Map<String,String>> map) async {
    int result = 0;

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(documentId).update({"colleagues": map}).onError((error, stackTrace) =>{result = 405});

    return result;
  }

  Stream<QuerySnapshot> getScheduleComment(String companyCode, String docId) {
    return _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(docId).collection(COMMENT).snapshots();
  }

  Future<int> insertScheduleComment(String companyCode, String scheduleId, CommentModel model) async {
    var result = -1;
    await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(scheduleId).collection(COMMENT).add(model.toJson())
        .whenComplete(() => {result = 0});

    return result;
  }

  Stream<QuerySnapshot> getTeamStream(String companyCode){
    return _store.collection(COMPANY).doc(companyCode).collection(TEAM).snapshots();
  }

  Stream<QuerySnapshot> getPositionStream(String companyCode){
    return _store.collection(COMPANY).doc(companyCode).collection(POSITION).snapshots();
  }

  Future<void> insertAdminSchedule(EmployeeModel loginEmployee, WorkModel model) async {
    await _store.collection(COMPANY).doc(loginEmployee.companyCode).collection(WORK).add(model.toJson());
  }

  Future<void> updateAdminSchedule(EmployeeModel loginEmployee, WorkModel model, String docId) async {
    await _store.collection(COMPANY).doc(loginEmployee.companyCode).collection(WORK).doc(docId).update(model.toJson());
  }
}