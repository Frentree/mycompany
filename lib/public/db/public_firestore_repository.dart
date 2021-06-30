
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firestore_method.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/schedule/db/schedule_firestore_method.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';

class PublicFirebaseReository {
  PublicFirebaseMethods _curd = PublicFirebaseMethods.setting();

  Future<bool> createTeam({required String companyUser, required TeamModel team}) =>
      _curd.createTeam(companyUser, team);

  Future<bool> createPosition({required String companyUser, required PositionModel position}) =>
      _curd.createPosition(companyUser, position);
}