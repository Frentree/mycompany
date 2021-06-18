
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

  Future<QuerySnapshot> getTeamDocument({String? companyCode}) =>
      _curd.getTeamDocument(companyCode);

  Future<bool> insertWorkDocument({required WorkModel workModel, EmployeeModel? approvalUser,required String companyCode}) =>
      _curd.insertWorkDocument(workModel, approvalUser, companyCode);

  Future<bool> updateWorkDocument({required WorkModel workModel, EmployeeModel? approvalUser,required String companyCode, required String documentId}) =>
      _curd.updateWorkDocument(workModel, approvalUser, companyCode, documentId);

  Future<bool> deleteScheduleDocument({required String companyCode,required String documentId}) =>
      _curd.deleteScheduleDocument(companyCode, documentId);

  Future<bool> getApprovalListSizeDocument({required String companyCode,required String documentId}) =>
      _curd.getApprovalListSizeDocument(companyCode, documentId);
}