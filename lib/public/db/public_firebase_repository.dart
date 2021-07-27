import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firebase_method.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class PublicFirebaseRepository {
  final PublicFirebaseMethods _methods = PublicFirebaseMethods.settings();

  // final PublicFirebaseMethods _methods = PublicFirebaseMethods();

  Future<List<String>> getTokensFromUsers(UserModel user, String? companyCode,
      List users) =>
      _methods.getTokensFromUsers(user, companyCode, users);

  Future<void> saveAlarmDataFromUsersThenSend(UserModel user,
      String? companyCode, List users, var payload) =>
      _methods.saveAlarmDataFromUsersThenSend(
          user, companyCode, users, payload);

  Future<void> setAlarmReadToTrue(String? companyCode, String? mail,
      String alarmId) =>
      _methods.setAlarmReadToTrue(companyCode, mail, alarmId);

  Future<double> usedVacationWithDuration(String? companyCode, String? mail, DateTime start, DateTime end) =>
      _methods.usedVacationWithDuration(companyCode, mail, start, end);

  Stream<QuerySnapshot> getCompanyUsers({required UserModel loginUser}) =>
      _methods.getCompanyUsers(loginUser);


  Stream<QuerySnapshot> getCompanyTeamUsers({required UserModel loginUser,required String teamName}) =>
      _methods.getCompanyTeamUsers(loginUser, teamName);

  Stream<QuerySnapshot> getLoginUser({required UserModel loginUser}) =>
      _methods.getLoginUser(loginUser);

  Stream<QuerySnapshot> usedVacation({required UserModel loginUser,required DateTime time}) =>
      _methods.usedVacation(loginUser, time);


  Future<bool> createTeam({required String companyCode, required TeamModel team}) =>
      _methods.createTeam(companyCode, team);

  Future<bool> createPosition({required String companyCode, required PositionModel position}) =>
      _methods.createPosition(companyCode, position);

  Future<CompanyModel> getVacation({required String companyCode}) =>
      _methods.getVacation(companyCode);

  Stream<DocumentSnapshot> getCompany({required String companyCode}) =>
      _methods.getCompany(companyCode);

  Stream<DocumentSnapshot> getUserVacation({required UserModel loginUser}) =>
      _methods.getUserVacation(loginUser);

  Stream<EmployeeModel> getEmployeeUser({required UserModel loginUser}) =>
      _methods.getEmployeeUser(loginUser);

  Stream<QuerySnapshot> getColleagueAttendance({required UserModel loginUser}) =>
      _methods.getColleagueAttendance(loginUser);

  Future<WorkModel> getOutWorkLocation({required UserModel loginUser, required String mail}) =>
      _methods.getOutWorkLocation(loginUser, mail);

  Stream<List<ExpenseModel>> getExpense({required UserModel loginUser}) =>
      _methods.getExpense(loginUser);

  Future<void> addExpense({required UserModel loginUser,required ExpenseModel model}) =>
      _methods.addExpense(loginUser, model);

}
