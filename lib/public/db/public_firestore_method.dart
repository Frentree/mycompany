

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class PublicFirebaseMethods {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  PublicFirebaseMethods.setting({persistenceEnabled: true});

  Future<bool> createTeam(String companyCode, TeamModel team) async {
    bool result = false;

    await _store.collection(COMPANY).doc(companyCode).collection(TEAM).add(team.toJson()).whenComplete(() => result = true);

    return result;
  }

  Future<bool> createPosition(String companyCode, PositionModel position) async {
    bool result = false;

    await _store.collection(COMPANY).doc(companyCode).collection(POSITION).add(position.toJson()).whenComplete(() => result = true);

    return result;
  }

  Future<CompanyModel> getVacation(String companyCode) async {
    dynamic doc = await _store.collection(COMPANY).doc(companyCode).get();

    CompanyModel model = CompanyModel.fromMap(mapData: doc.data());

    return model;
  }

  Stream<DocumentSnapshot> getCompany(String companyCode) {

    return _store.collection(COMPANY).doc(companyCode).snapshots();
  }

}