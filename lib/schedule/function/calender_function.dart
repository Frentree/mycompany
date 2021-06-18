

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
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
      final model =
          WorkModel.fromMap(mapData: (doc.data() as Map<dynamic, dynamic>));
      String type = model.type;
      String name = model.name;
      String title = model.title;
      String content = model.content;
      String mail = model.createUid;
      String? location = model.location;
      String? notes = "[${type}] ${title}";
      Timestamp startTimes = model.startTime;
      String? position = mailChkList
          .firstWhere((element) => element.mail == mail)
          .position
          .toString();
      String? team = mailChkList
          .firstWhere((element) => element.mail == mail)
          .team
          .toString();

      if (typeList.contains(type)) {
        typeChoise = typeList.indexOf(type);
      } else {
        typeChoise = 6;
      }

      final DateTime startTime = DateTime.parse(startTimes.toDate().toString());
      final DateTime endTime = model.endTime == null
          ? startTime.add(const Duration(hours: 0))
          : DateTime.parse(model.endTime!.toDate().toString());

      shedules.add(Appointment(
        startTime: startTime,
        endTime: endTime,
        subject: name,
        color: _color[typeChoise],
        notes: notes,
        type: type,
        profile: mail,
        team: team,
        title: title,
        content: content,
        colleagues: model.colleagues,
        documentId: doc.id,
        position: position,
        location: location != null ? location : "",
        resourceIds: <Object>[mail.hashCode],
      ));
    }

    return shedules;
  }

  void getScheduleDetail(CalendarTapDetails details, BuildContext context){
    dynamic appointment = details.appointments;
    DateTime? date = details.date;
    //CalendarElement element = details.targetElement; //  달력 요소
    if(appointment != null){
      showScheduleDetail(context: context, data: appointment, date: date!);
    }
  }

  Future<DateTime> dateSet(DateTime date, BuildContext context) async{
    DateTime pickTime = await showDatesPicker(context: context, date: date);
    //CalendarElement element = details.targetElement; //  달력 요소

    return pickTime;
  }

  Future<DateTime> dateTimeSet(DateTime date, BuildContext context) async{
    DateTime pickTime = await showDateTimePicker(context: context, date: date);
    //CalendarElement element = details.targetElement; //  달력 요소

    return pickTime;
  }

  void mainNavigator(CalendarTapDetails details, BuildContext context){
    dynamic appointment = details.appointments;
    DateTime? date = details.date;
    //CalendarElement element = details.targetElement; //  달력 요소
    if(appointment != null){
      showScheduleDetail(context: context, data: appointment, date: date!);
    }
  }

  Future<List<TeamModel>> getTeam(String? companyCode) async {
    List<TeamModel> teamList = [];
    var teamData = await _reository.getTeamDocument(companyCode: companyCode);

    List<QueryDocumentSnapshot> teamSnapshot = teamData.docs;

    for (var doc in teamSnapshot) {
      teamList.add(TeamModel.fromMap(mapData: (doc.data() as Map<dynamic,dynamic>)));
    }

    return teamList;
  }

  Future<List<CompanyUserModel>> getEmployee(String? companyCode) async {
    List<CompanyUserModel> empList = [];
    var empData = await _reository.getCompanyUser(companyCode: companyCode);

    List<QueryDocumentSnapshot> empSnapshot = empData.docs;

    for (var doc in empSnapshot) {
      empList.add(CompanyUserModel.fromMap(mapData: (doc.data() as Map<dynamic,dynamic>)));
    }

    return empList;
  }


  // 스케줄 입력
  Future<bool> insertSchedule({
    required String companyCode,
    required bool allDay,
    required String workName,
    required String title,
    required String content,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    required List<CompanyUserModel> workColleagueChkList,
    required bool isAllDay,
    CompanyUserModel? approvalUser,
  }) async {
    // 선택된 동료 리스트
    List<String>? colleaguesList;

    // 선택된 동료가 있으면
    if(workColleagueChkList.length != 0){
      colleaguesList = ["bsc2079@naver.com"];
      workColleagueChkList.map((e) => colleaguesList!.add(e.mail.toString())).toList();
    }


    WorkModel workModel = WorkModel(
      allDay: allDay,
      type: workName,
      title: title,
      content: content,
      location: location,
      startTime: Timestamp.fromDate(startTime),
      endTime: Timestamp.fromDate(endTime),
      colleagues: colleaguesList,
      name: "이윤혁",
      createUid: "bsc2079@naver.com",
    );

    return await _reository.insertWorkDocument(workModel: workModel, companyCode: companyCode, approvalUser: approvalUser);
  }

  // 스케줄 수정
  Future<bool> updateSchedule({
    required String companyCode,
    required bool allDay,
    required String workName,
    required String title,
    required String content,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    required List<CompanyUserModel> workColleagueChkList,
    required bool isAllDay,
    CompanyUserModel? approvalUser,
  }) async {
    // 선택된 동료 리스트
    List<String>? colleaguesList;

    // 선택된 동료가 있으면
    if(workColleagueChkList.length != 0){
      colleaguesList = ["bsc2079@naver.com"];
      workColleagueChkList.map((e) => colleaguesList!.add(e.mail.toString())).toList();
    }


    WorkModel workModel = WorkModel(
      allDay: allDay,
      type: workName,
      title: title,
      content: content,
      location: location,
      startTime: Timestamp.fromDate(startTime),
      endTime: Timestamp.fromDate(endTime),
      colleagues: colleaguesList,
      name: "이윤혁",
      createUid: "bsc2079@naver.com",
    );

    return await _reository.insertWorkDocument(workModel: workModel, companyCode: companyCode, approvalUser: approvalUser);
  }

  // 스케줄 삭제
  Future<int> deleteSchedule({
    required String companyCode,
    required String documentId
  }) async {
    int resultCode = 0; // 0 : 성공, 404 : 결재 중인 항목일때, 405 : 스케줄 삭제 오류

    var approvalResult = await _reository.getApprovalListSizeDocument(companyCode: companyCode, documentId: documentId);

    if(approvalResult){
      var scheduleResult = await _reository.deleteScheduleDocument(companyCode: companyCode, documentId: documentId);
      if(!scheduleResult){
        resultCode = 405;
      }
    } else {
      resultCode = 404;
    }

    return resultCode;
  }




}