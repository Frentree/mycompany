
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/schedule/db/schedule_firestore_crud.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class ScheduleFirebaseReository {
  ScheduleFirebaseCurd _curd = ScheduleFirebaseCurd();

  Future<QuerySnapshot> getSchedules({String? companyCode}) =>
      _curd.getSchedules(companyCode);

  Future<QuerySnapshot> getCompanyUser({String? companyCode}) =>
      _curd.getCompanyUser(companyCode);

  Future<QuerySnapshot> getMyAndCompanyUser({String? companyCode}) =>
      _curd.getMyAndCompanyUser(companyCode);

  Future<QuerySnapshot> getTeamDocument({String? companyCode}) =>
      _curd.getTeamDocument(companyCode);


  Future<bool> insertWorkNotApprovalDocument({required WorkModel workModel, required String companyCode}) =>
      _curd.insertWorkNotApprovalDocument(workModel, companyCode);

  Future<bool> insertWorkApprovalDocument({required WorkModel workModel, required EmployeeModel approvalUser,required String companyCode}) =>
      _curd.insertWorkApprovalDocument(workModel, approvalUser, companyCode);

  Future<bool> updateWorkApprovalDocument({required WorkModel workModel, required EmployeeModel approvalUser,required String companyCode, required String documentId}) =>
      _curd.updateWorkApprovalDocument(workModel, approvalUser, companyCode, documentId);


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
}