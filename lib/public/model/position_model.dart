/*
App 팀 이름
팀순서 : positionNum
팀이름 : positionName

*/

import 'package:cloud_firestore/cloud_firestore.dart';

class PositionModel {
  int? positionNum;
  String position;
  DocumentReference? reference;

  PositionModel({
    this.positionNum,
    required this.position,
  });

  PositionModel.fromMap({required Map mapData, this.reference})
      : positionNum = mapData["positionNum"] ?? 999,
        position = mapData["position"] ?? "";

  toJson() {
    return {
      "positionNum": positionNum ?? 999,
      "position": position,
    };
  }
}
