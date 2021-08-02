
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/schedule/db/schedule_firestore_method.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class ScheduleFirebaseReository {
  ScheduleFirebaseMethods _curd = ScheduleFirebaseMethods.setting();

  Future<QuerySnapshot> getSchedules({String? companyCode}) =>
      _curd.getSchedules(companyCode);

  Future<QuerySnapshot> getCompanyUser({required UserModel loginUser}) =>
      _curd.getCompanyUser(loginUser);

  Future<QuerySnapshot> getMyAndCompanyUser({String? companyCode}) =>
      _curd.getMyAndCompanyUser(companyCode);

  Future<QuerySnapshot> getTeamDocument({String? companyCode}) =>
      _curd.getTeamDocument(companyCode);


  Future<bool> insertWorkNotApprovalDocument({required WorkModel workModel, required String companyCode}) =>
      _curd.insertWorkNotApprovalDocument(workModel, companyCode);

  Future<bool> insertWorkApprovalDocument({required WorkModel workModel, required EmployeeModel approvalUser,required loginUser}) =>
      _curd.insertWorkApprovalDocument(workModel, approvalUser, loginUser);

  Future<bool> updateWorkApprovalDocument({required WorkModel workModel, required EmployeeModel approvalUser,required UserModel loginUser, required String documentId}) =>
      _curd.updateWorkApprovalDocument(workModel, approvalUser, loginUser, documentId);


  Future<bool> updateWorkNotApprovalDocument({required WorkModel workModel, required String companyCode, required String documentId}) =>
      _curd.updateWorkNotApprovalDocument(workModel, companyCode, documentId);

  Future<bool> deleteScheduleDocument({required String companyCode,required String documentId}) =>
      _curd.deleteScheduleDocument(companyCode, documentId);

  Future<bool> getApprovalListSizeDocument({required String companyCode,required String documentId}) =>
      _curd.getApprovalListSizeDocument(companyCode, documentId);

  Future<void> workColleaguesUpdate({required String companyCode}) =>
      _curd.workColleaguesUpdate(companyCode);

  Future<int> workColleaguesDelete({required String companyCode, required String documentId, required List<Map<String,String>> map}) =>
      _curd.workColleaguesDelete(companyCode, documentId, map);

  Stream<QuerySnapshot> getScheduleComment({required String companyCode, required String docId}) =>
      _curd.getScheduleComment(companyCode, docId);

  Future<int> insertScheduleComment({required companyCode, required scheduleId, required model}) =>
      _curd.insertScheduleComment(companyCode, scheduleId, model);

  Stream<QuerySnapshot> getTeamStream({required String companyCode}) =>
      _curd.getTeamStream(companyCode);

  Stream<QuerySnapshot> getPositionStream({required String companyCode}) =>
      _curd.getPositionStream(companyCode);

  Future<void> insertAdminSchedule({required EmployeeModel loginEmployee, required WorkModel model}) =>
      _curd.insertAdminSchedule(loginEmployee, model);

  Future<void> updateAdminSchedule({required EmployeeModel loginEmployee, required WorkModel model, required String docId}) =>
      _curd.updateAdminSchedule(loginEmployee, model, docId);
}