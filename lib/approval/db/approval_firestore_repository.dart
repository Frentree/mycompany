
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/approval/db/approval_firebase_crud.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class ApprovalFirebaseRepository {
  ApprovalFirebaseCurd _curd = ApprovalFirebaseCurd.setting();

  Future<List<ApprovalModel>> getRequestApprovalData({required UserModel loginUser}) =>
      _curd.getRequestApprovalData(loginUser);

  Stream<QuerySnapshot> getRequestApprovalDataSnashot({required UserModel loginUser}) =>
      _curd.getRequestApprovalDataSnashot(loginUser);

  Future<List<ApprovalModel>> getResponseApprovalData({required UserModel loginUser}) =>
   _curd.getResponseApprovalData(loginUser);

  Stream<QuerySnapshot> getResponseApprovalDataSnashot({required UserModel loginUser}) =>
      _curd.getResponseApprovalDataSnashot(loginUser);

  Stream<QuerySnapshot> getResponseApprovalDataCount({required UserModel loginUser}) =>
      _curd.getResponseApprovalDataCount(loginUser);

  Future<bool> insertWorkApproval({required WorkModel workModel,required EmployeeModel approvalUser,required UserModel loginUser, String? docId}) =>
      _curd.insertWorkApproval(workModel, approvalUser, loginUser, docId);

  Future<bool> requestApprovalCencel({required ApprovalModel model,required String companyCode}) =>
      _curd.requestApprovalCencel(model, companyCode);

  Future<bool> updateWorkApproval({required ApprovalModel model,required String companyCode, required String approval, required String content}) =>
      _curd.updateWorkApproval(model, companyCode, approval, content);
}