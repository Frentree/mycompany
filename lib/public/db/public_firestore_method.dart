

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class PublicFirebaseMethods {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  PublicFirebaseMethods.setting({persistenceEnabled: true});

  Future<bool> createTeam(String companyUser, TeamModel team) async {
    bool result = false;

    await _store.collection(COMPANY).doc(companyUser).collection(TEAM).add(team.toJson()).whenComplete(() => result = true);

    return result;
  }

  Future<bool> createPosition(String companyUser, PositionModel position) async {
    bool result = false;

    await _store.collection(COMPANY).doc(companyUser).collection(POSITION).add(position.toJson()).whenComplete(() => result = true);

    return result;
  }

}