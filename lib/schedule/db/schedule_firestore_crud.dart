

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';

class ScheduleFirebaseCurd {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  ApprovalFirebaseRepository approvalRepository = ApprovalFirebaseRepository();

  Future<QuerySnapshot> getSchedules(String? companyCode) async {
    List<String> mailList = [];

    for(var data in mailChkList){
      mailList.add(data.mail);
    }
    var result = await _store.collection(COMPANY).doc(companyCode).collection(WORK).where("colleagues", isGreaterThan: mailList).get();

    return result;
  }
  
  
  Future<QuerySnapshot> getCompanyUser(String? companyCode) async {
    return await _store.collection(COMPANY).doc(companyCode).collection("user").where("mail", isNotEqualTo: loginUser!.mail).get();
  }

  Future<QuerySnapshot> getMyAndCompanyUser(String? companyCode) async {
    return await _store.collection(COMPANY).doc(companyCode).collection("user").get();
  }

  Future<QuerySnapshot> getTeamDocument(String? companyCode) async {
    return await _store.collection(COMPANY).doc(companyCode).collection("team").get();
  }

  Future<QuerySnapshot> getEmployeeDocument(String? companyCode) async {
    return await _store.collection(COMPANY).doc(companyCode).collection("user").get();
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

  Future<bool> insertWorkApprovalDocument(WorkModel workModel, EmployeeModel approvalUser, String companyCode) async {
    bool isResult = false;
    await _store.collection(COMPANY).doc(companyCode).collection(WORK).add(workModel.toJson()).then((value) => approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser, companyCode: companyCode, docId: value.id)).whenComplete(() => {isResult = true});

    return isResult;
  }

  Future<bool> updateWorkNotApprovalDocument(WorkModel workModel, String companyCode, String documentId) async {
    bool isResult = false;

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(documentId).set(workModel.toJson()).whenComplete(() => {isResult = true});

    return isResult;
  }

  Future<bool> updateWorkApprovalDocument(WorkModel workModel, EmployeeModel approvalUser, String companyCode, String documentId) async {
    bool isResult = false;

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(documentId).set(workModel.toJson()).then((value) => approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser, companyCode: companyCode, docId: documentId)).whenComplete(() => {isResult = true});

    return isResult;
  }

  // 결재 내역 확인 있으면 삭제 불가능
  Future<bool> getApprovalListSizeDocument(String companyCode, String documentId) async {
    bool isResult = false;

    print(documentId);

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
     await _store.collection(COMPANY).doc(companyCode).collection(WORK).get().then((value) => value.docs.map((e) {
       final work = WorkModel.fromMap(mapData: e.data());

       if(work.colleagues!.length != 0) {
         List<Map<String,String>> map = [{work.createUid : work.name}];
         e.reference.update({"colleagues" : map});
       }
     }).toList());

  }

  Future<int> workColleaguesDelete(String companyCode, String documentId, List<Map<String,String>> map) async {
    int result = 0;

    print(map);

    await _store.collection(COMPANY).doc(companyCode).collection(WORK).doc(documentId).update({"colleagues": map}).onError((error, stackTrace) =>{result = 405});

    return result;
  }
}