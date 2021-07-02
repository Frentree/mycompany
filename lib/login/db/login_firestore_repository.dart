import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/db/login_firestore_crud.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/join_company_approval_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/model/team_model.dart';

class LoginFirestoreRepository {
  LoginFirestoreCrud _loginFirebaseCrud = LoginFirestoreCrud.settings();

  //Employee 관련
  Future<void> createEmployeeData({required EmployeeModel employeeModel}) =>
      _loginFirebaseCrud.createEmployeeData(employeeModel: employeeModel);

  Future<EmployeeModel> readEmployeeData(
          {required String companyId, required String email}) =>
      _loginFirebaseCrud.readEmployeeData(companyId: companyId, email: email);

  Future<void> updateEmployeeData({required EmployeeModel employeeModel}) => _loginFirebaseCrud.updateEmployeeData(employeeModel: employeeModel);

  //User 관련
  Future<void> createUserData({required UserModel userModel}) =>
      _loginFirebaseCrud.createUserData(userModel: userModel);

  Future<UserModel> readUserData({required String email}) =>
      _loginFirebaseCrud.readUserData(email: email);

  Future<void> updateUserData({required UserModel userModel}) =>
      _loginFirebaseCrud.updateUserData(userModel: userModel);

  Future<void> updateUserJoinCompanyState({required String userMail, int? state, String? companyId,}) => _loginFirebaseCrud.updateUserJoinCompanyState(userMail: userMail, state: state, companyId: companyId);

  //Company 관련
  Future<void> createCompanyData({required CompanyModel companyModel}) =>
      _loginFirebaseCrud.createCompanyData(companyModel: companyModel);

  Future<List<CompanyModel>> readAllCompanyData() =>
      _loginFirebaseCrud.readAllCompanyData();

  Future<QuerySnapshot> findCompanyDataWithName({required String keyWord}) =>
      _loginFirebaseCrud.findCompanyDataWithName(keyWord: keyWord);

  Future<List<TeamModel>> readTeamData({required String companyId}) async => _loginFirebaseCrud.readTeamData(companyId: companyId);

  //JoinCompanyApproval 관련
  Future<void> createJoinCompanyApprovalData({
    required String companyId,
    required JoinCompanyApprovalModel joinCompanyApprovalModel,
  }) =>
      _loginFirebaseCrud.createJoinCompanyApprovalData(
        companyId: companyId,
        joinCompanyApprovalModel: joinCompanyApprovalModel,
      );

  Stream<QuerySnapshot<Map<String, dynamic>>> readJoinCompanyApprovalData(
          {required String companyId}) =>
      _loginFirebaseCrud.readJoinCompanyApprovalData(companyId: companyId);

  Future<void> updateJoinCompanyApprovalData(
          {required String companyId,
          required JoinCompanyApprovalModel joinCompanyApprovalModel}) =>
      _loginFirebaseCrud.updateJoinCompanyApprovalData(
          companyId: companyId,
          joinCompanyApprovalModel: joinCompanyApprovalModel);
}
