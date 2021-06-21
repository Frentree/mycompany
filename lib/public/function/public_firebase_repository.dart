import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/public_firebase_method.dart';

class PublicFirebaseRepository {
  final PublicFirebaseMethods _methods = PublicFirebaseMethods.settings();
  // final PublicFirebaseMethods _methods = PublicFirebaseMethods();

  Future<List<String>> getTokensFromUsers(
          UserModel user, String? companyCode, List users) =>
      _methods.getTokensFromUsers(user, companyCode, users);

  Future<void> saveAlarmDataFromUsersThenSend(
          UserModel user, String? companyCode, List users, var payload) =>
      _methods.saveAlarmDataFromUsersThenSend(
          user, companyCode, users, payload);
}
