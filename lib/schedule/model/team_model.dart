/*
App 팀 이름
팀이름 : teamName

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class TeamModel {
  String? teamName;

  TeamModel({
    this.teamName,
  });

  TeamModel.fromMap({required Map mapData})
      : teamName = mapData["teamName"] ?? "";

  toJson() {
    return {
      "teamName": teamName,
    };
  }
}
