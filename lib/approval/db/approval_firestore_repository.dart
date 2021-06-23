
import 'package:mycompany/approval/db/approval_firebase_crud.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class ApprovalFirebaseRepository {
  ApprovalFirebaseCurd _curd = ApprovalFirebaseCurd.setting();

  Future<List<ApprovalModel>> getRequestApprovalData({required String companyCode}) =>
      _curd.getRequestApprovalData(companyCode);

  Future<List<ApprovalModel>> getResponseApprovalData({required String companyCode}) =>
   _curd.getResponseApprovalData(companyCode);

  Future<bool> insertWorkApproval({required WorkModel workModel,required EmployeeModel approvalUser,required String companyCode, String? docId}) =>
      _curd.insertWorkApproval(workModel, approvalUser, companyCode, docId);

  Future<bool> requestApprovalCencel({required ApprovalModel model,required String companyCode}) =>
      _curd.requestApprovalCencel(model, companyCode);

  Future<bool> updateWorkApproval({required ApprovalModel model,required String companyCode, required String approval, required String content}) =>
      _curd.updateWorkApproval(model, companyCode, approval, content);
}