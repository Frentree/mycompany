
import 'package:mycompany/public/db/public_firestore_method.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';

class PublicFirebaseReository {
  PublicFirebaseMethods _curd = PublicFirebaseMethods.setting();

  Future<bool> createTeam({required String companyUser, required TeamModel team}) =>
      _curd.createTeam(companyUser, team);

  Future<bool> createPosition({required String companyUser, required PositionModel position}) =>
      _curd.createPosition(companyUser, position);
}