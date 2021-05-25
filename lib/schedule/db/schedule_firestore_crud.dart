

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';

class ScheduleFirebaseCurd {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<QuerySnapshot> getSchedules(String? companyCode) async {
    print(mailChkList);
    return await _store.collection("company").doc(companyCode).collection("work").where("createUid", whereIn: mailChkList).get();
  }

  Future<QuerySnapshot> getCompanyUser(String? companyCode) async {
    return await _store.collection("company").doc(companyCode).collection("user").where("mail", isNotEqualTo: "bsc2079@naver.com").get();
  }

  Future<QuerySnapshot> getTeamDocument(String? companyCode) async {
    return await _store.collection("company").doc(companyCode).collection("team").get();
  }

  Future<QuerySnapshot> getEmployeeDocument(String? companyCode) async {
    return await _store.collection("company").doc(companyCode).collection("user").get();
  }
}