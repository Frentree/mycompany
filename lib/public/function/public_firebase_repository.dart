import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/public_firebase_method.dart';

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

}
