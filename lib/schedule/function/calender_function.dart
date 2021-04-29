

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalenderFunction{
  final ScheduleFirebaseReository _reository = ScheduleFirebaseReository();

  Future<List<Appointment>> getSheduleData(String? companyCode) async {
    var _color = [Colors.red, Colors.green, Colors.teal, Colors.lightBlueAccent, Colors.deepPurpleAccent, Colors.limeAccent, Colors.cyanAccent];
    int typeChoise = 1;
    var typeList = ["내근", "외근", "미팅", "연차", "반차", "휴가", "기타"];


    final List<Appointment> shedules = <Appointment>[];
    var schduleData = await _reository.getSchedules(companyCode: companyCode);

    List<QueryDocumentSnapshot> scheduleSnapshot = schduleData.docs;

    for (var doc in scheduleSnapshot) {
      String type = doc.data()['type'];
      String name = doc.data()['name'];
      String title = doc.data()['title'];
      String mail = doc.data()['createUid'];
      String location = doc.data()['location'];
      String notes = "[${type}] ${title}";
      Timestamp startTimes = doc.data()['startTime'];

      if(typeList.contains(type)){
        typeChoise = typeList.indexOf(type);
      } else {
        typeChoise = 6;
      }

      final DateTime startTime = DateTime.parse(startTimes.toDate().toString());
      final DateTime endTime = doc.data()['endTime'] == null ? startTime.add(const Duration(hours: 0)) : DateTime.parse(doc.data()['endTime'] .toDate().toString());

      shedules.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: name,
        color: _color[typeChoise],
        notes: notes,
        location: location != null ? location : "",
        resourceIds:<Object> [mail.hashCode],
      ));

    }


    return shedules;
  }

}