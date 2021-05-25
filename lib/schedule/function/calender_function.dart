

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/testcompany_model.dart';
import 'package:mycompany/schedule/widget/schedule_dialog_widget.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class CalenderFunction{
  final ScheduleFirebaseReository _reository = ScheduleFirebaseReository();

  Future<List<Appointment>> getSheduleData(String? companyCode) async {
    var _color = [checkColor, outWorkColor, Colors.teal, annualColor, annualColor, Colors.limeAccent, Colors.cyanAccent];
    int typeChoise = 1;
    var typeList = ["내근", "외근", "미팅", "연차", "반차", "휴가", "기타"];


    final List<Appointment> shedules = <Appointment>[];
    var schduleData = await _reository.getSchedules(companyCode: companyCode);

    List<QueryDocumentSnapshot> scheduleSnapshot = schduleData.docs;

    for (var doc in scheduleSnapshot) {
      String type = doc.data()['type'];
      String name = doc.data()['name'];
      String? title = doc.data()['title'];
      String? mail = doc.data()['createUid'];
      String? location = doc.data()['location'];
      String? notes = "[${type}] ${title}";
      Timestamp startTimes = doc.data()['startTime'];

      if(typeList.contains(type)){
        typeChoise = typeList.indexOf(type);
      } else {
        typeChoise = 6;
      }

      final DateTime startTime = DateTime.parse(startTimes.toDate().toString());
      final DateTime endTime = doc.data()['endTime'] == null ? startTime.add(const Duration(hours: 0)) : DateTime.parse(doc.data()['endTime'].toDate().toString());

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

  void getScheduleDetail(CalendarTapDetails details, BuildContext context){
    dynamic appointment = details.appointments;
    DateTime? date = details.date;
    //CalendarElement element = details.targetElement; //  달력 요소
    if(appointment != null){
      ScheduleDialogWidget().showScheduleDetail(context: context, data: appointment, date: date!);
    }
  }

  Future<DateTime> dateTimeSet(DateTime date, BuildContext context) async{
    DateTime pickTime = await ScheduleDialogWidget().showDatePicker(context: context, date: date);
    //CalendarElement element = details.targetElement; //  달력 요소

    return pickTime;
  }

  void mainNavigator(CalendarTapDetails details, BuildContext context){
    dynamic appointment = details.appointments;
    DateTime? date = details.date;
    //CalendarElement element = details.targetElement; //  달력 요소
    if(appointment != null){
      ScheduleDialogWidget().showScheduleDetail(context: context, data: appointment, date: date!);
    }
  }

  Future<List<TeamModel>> getTeam(String? companyCode) async {
    List<TeamModel> teamList = [];
    var teamData = await _reository.getTeamDocument(companyCode: companyCode);

    List<QueryDocumentSnapshot> teamSnapshot = teamData.docs;

    for (var doc in teamSnapshot) {
      teamList.add(TeamModel.fromMap(mapData: doc.data()));
    }

    return teamList;
  }

  Future<List<CompanyUserModel>> getEmployee(String? companyCode) async {
    List<CompanyUserModel> empList = [];
    var empData = await _reository.getCompanyUser(companyCode: companyCode);

    List<QueryDocumentSnapshot> empSnapshot = empData.docs;

    for (var doc in empSnapshot) {
      empList.add(CompanyUserModel.fromMap(mapData: doc.data()));
    }

    return empList;
  }

}