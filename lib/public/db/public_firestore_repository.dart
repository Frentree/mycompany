
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/public/db/public_firestore_method.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';

class PublicFirebaseReository {
  PublicFirebaseMethods _curd = PublicFirebaseMethods.setting();

  Future<bool> createTeam({required String companyCode, required TeamModel team}) =>
      _curd.createTeam(companyCode, team);

  Future<bool> createPosition({required String companyCode, required PositionModel position}) =>
      _curd.createPosition(companyCode, position);

  Future<CompanyModel> getVacation(String companyCode) =>
      _curd.getVacation(companyCode);

  Stream<DocumentSnapshot> getCompany({required String companyCode}) =>
      _curd.getCompany(companyCode);
}