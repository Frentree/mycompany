/*
App 팀 이름
팀순서 : teamNum
팀이름 : teamName

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  int? teamNum;
  String teamName;
  DocumentReference? reference;

  TeamModel({
    this.teamNum,
    required this.teamName,
  });

  TeamModel.fromMap({required Map mapData, this.reference})
      : teamNum = mapData["teamNum"] ?? 999,
       teamName = mapData["teamName"] ?? "";

  toJson() {
    return {
      "teamNum": teamNum ?? 999,
      "teamName": teamName,
    };
  }
}
