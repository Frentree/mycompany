

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:mycompany/schedule/view/schedule_registration_update_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/schedule_dialog_widget.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class CalenderMethod{
  final ScheduleFirebaseReository _reository = ScheduleFirebaseReository();
  ApprovalFirebaseRepository approvalRepository = ApprovalFirebaseRepository();

  Future<List<Appointment>> getSheduleData(String? companyCode) async {
    var _color = [checkColor, outWorkColor, Colors.purple, Colors.teal, annualColor, annualColor, annualColor, Colors.cyanAccent];
    int typeChoise = 1;
    var typeList = ["내근", "외근", "업무", "미팅", "연차", "반차", "휴가", "기타"];


    final List<Appointment> shedules = <Appointment>[];
    var schduleData = await _reository.getSchedules(companyCode: companyCode);

    List<QueryDocumentSnapshot> scheduleSnapshot = schduleData.docs;

    for (var doc in scheduleSnapshot) {
      final model = WorkModel.fromMap(mapData: (doc.data() as dynamic));
      String type = model.type;
      String name = model.name;
      String title = model.title;
      String content = model.contents;
      String mail = model.createUid;
      String? location = model.location;
      String? notes = "[${type}] ${title}";
      Timestamp startTimes = model.startTime;
     // late String? position = mailChkList.firstWhere((element) => element.mail == mail).position.toString();
     // late String? team = mailChkList.firstWhere((element) => element.mail == mail).team.toString();

      if(typeList.contains(type)){
        typeChoise = typeList.indexOf(type);
      } else {
        typeChoise = 6;
      }

      final DateTime startTime = DateTime.parse(startTimes.toDate().toString());
      final DateTime endTime = model.endTime == null ? startTime.add(const Duration(hours: 0)) : DateTime.parse(model.endTime!.toDate().toString());



      var colleagues = model.colleagues!;


      for(var data in colleagues) {
        Map<String, dynamic> map = data;
        String mail = map.keys.toString().replaceAll("(", "").replaceAll(")", "");
        String name = map.values.toString().replaceAll("(", "").replaceAll(")", "");;

        for (var mailData in mailChkList) {
          if (mailData.mail.contains(mail)) {
            shedules.add(Appointment(
              isAllDay: model.allDay,
              startTime: startTime,
              endTime: endTime,
              subject: name,
              color: _color[typeChoise],
              notes: notes,
              type: type,
              profile: mail.toString(),
              team: mailData.team,
              title: title,
              content: content,
              colleagues: model.colleagues,
              documentId: doc.id,
              position: mailData.position,
              location: location != null ? location : "",
              resourceIds: <Object>[mail.hashCode],
              organizerId: model.createUid
            ));
          }
        }
      }
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

  Future<List<EmployeeModel>> getEmployee(String? companyCode) async {
    List<EmployeeModel> empList = [];
    var empData = await _reository.getCompanyUser(companyCode: companyCode);

    List<QueryDocumentSnapshot> empSnapshot = empData.docs;

    for (var doc in empSnapshot) {
      empList.add(EmployeeModel.fromMap(mapData: (doc.data() as Map<dynamic,dynamic>)));
    }

    return empList;
  }

  // 나 포함
  Future<List<EmployeeModel>> getEmployeeMy(String? companyCode) async {
    List<EmployeeModel> empList = [];
    var empData = await _reository.getMyAndCompanyUser(companyCode: companyCode);

    List<QueryDocumentSnapshot> empSnapshot = empData.docs;

    for (var doc in empSnapshot) {
      empList.add(EmployeeModel.fromMap(mapData: (doc.data() as Map<dynamic,dynamic>)));
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
    required List<EmployeeModel> workColleagueChkList,
    required bool isAllDay,
    EmployeeModel? approvalUser,
  }) async {
    // 선택된 동료 리스트
    List<Map<String, String>>? colleaguesList;
    bool result = false;

    if(workName == "요청" || workName == "재택" || workName == "외출" || workName == "외근"){
      if(approvalUser == null || approvalUser.mail == ""){
        return await false;
      }
    }

    // 선택된 동료가 있으면
    if(workColleagueChkList.length != 0){
      colleaguesList = [{loginUser!.mail : loginUser!.name}];
      workColleagueChkList.map((e) {
        Map<String,String> map = {e.mail.toString() : e.name.toString()};
        colleaguesList!.add(map);
      }).toList();
    }

    WorkModel workModel = WorkModel(
      allDay: allDay,
      type: workName,
      title: title,
      contents: content,
      location: location,
      startTime: Timestamp.fromDate(startTime),
      endTime: Timestamp.fromDate(endTime),
      colleagues: colleaguesList,
      name: workName == "요청" ? approvalUser!.name : loginUser!.name,
      createUid: workName == "요청" ? approvalUser!.mail : loginUser!.mail,
    );

    switch(workName) {
      case "내근": case "미팅":
        result = await _reository.insertWorkNotApprovalDocument(workModel: workModel, companyCode: companyCode);
        break;
      case "외근": case "요청":
        result = await _reository.insertWorkApprovalDocument(workModel: workModel, approvalUser: approvalUser!, companyCode: companyCode);
        break;
      case "재택": case "외출": case "연차":
        result = await approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser!, companyCode: companyCode);
        break;
    }

    if(workModel.type == "기타" && approvalUser!.mail == ""){
      result = await _reository.insertWorkNotApprovalDocument(workModel: workModel, companyCode: companyCode);
    }else if(workModel.type == "기타" && approvalUser!.mail != "") {
      result = await _reository.insertWorkApprovalDocument(workModel: workModel, approvalUser: approvalUser, companyCode: companyCode);
    }

    return result;
  }

  // 스케줄 수정
  Future<bool> updateSchedule({
    required String documentId,
    required String companyCode,
    required bool allDay,
    required String workName,
    required String title,
    required String content,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    required List<EmployeeModel> workColleagueChkList,
    required bool isAllDay,
    EmployeeModel? approvalUser,
  }) async {
    // 선택된 동료 리스트
    List<Map<String,dynamic>>? colleaguesList;
    bool result = false;

    if(workName == "요청" || workName == "재택" || workName == "외출" || workName == "외근"){
      if(approvalUser == null || approvalUser.mail == ""){
        return false;
      }
    }

    // 선택된 동료가 있으면
    if(workColleagueChkList.length != 0){
      colleaguesList = [{loginUser!.mail : loginUser!.name}];

      workColleagueChkList.map((e) {
        Map<String,String> map = {e.mail.toString() : e.name.toString()};
        colleaguesList!.add(map);
      }).toList();
    }


    WorkModel workModel = WorkModel(
      allDay: allDay,
      type: workName,
      title: title,
      contents: content,
      location: location,
      startTime: Timestamp.fromDate(startTime),
      endTime: Timestamp.fromDate(endTime),
      colleagues: colleaguesList,
      name: workName == "요청" ? approvalUser!.name : loginUser!.name,
      createUid: workName == "요청" ? approvalUser!.mail : loginUser!.mail,
    );

    switch(workName) {
      case "내근": case "미팅":
      result = await _reository.updateWorkNotApprovalDocument(workModel: workModel, companyCode: companyCode, documentId: documentId);
      break;
      case "외근": case "요청":
      result = await _reository.updateWorkApprovalDocument(workModel: workModel, companyCode: companyCode, approvalUser: approvalUser!, documentId: documentId);
      break;
      case "재택": case "외출": case "연차":
      result = await approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser!, companyCode: companyCode);
      break;
    }

    if(workModel.type == "기타" && approvalUser!.mail == ""){
      result = await _reository.updateWorkNotApprovalDocument(workModel: workModel, companyCode: companyCode, documentId: documentId);
    }else if(workModel.type == "기타" && approvalUser!.mail != "") {
      result = await _reository.updateWorkApprovalDocument(workModel: workModel, companyCode: companyCode, approvalUser: approvalUser, documentId: documentId);
    }

    return result;
  }

  // 스케줄 수정
  Future<int> updateScheduleWork({
    required BuildContext context,
    required String companyCode,
    required String documentId,
    required Appointment appointment
  }) async {
    int resultCode = 0; // 0 : 성공, 404 : 결재 중인 항목일때, 405 : 스케줄 삭제 오류

    if(appointment.type == "반차" || appointment.type == "연차"){
      return 400;
    }

    var approvalResult = await _reository.getApprovalListSizeDocument(companyCode: companyCode, documentId: documentId);

    print(approvalResult);

    if(approvalResult){
      var scheduleResult = await Navigator.push(context, MaterialPageRoute(builder: (context) => ScheduleRegisrationUpdateView(documentId: documentId, appointment: appointment,)));
      if(!scheduleResult){
        resultCode = 407;
      }
    } else {
      resultCode = 406;
    }

    return resultCode;
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

  // 초대된 동료에서 빠지기
  Future<int> deleteColleagues({
    required String companyCode,
    required Appointment appointment
  }) async {
    int resultCode = 0;
    List<dynamic> colleagues = appointment.colleagues!;

    List<Map<String,String>> colleaguesList = [];

    for(var data in colleagues){
      String mail = data.keys.toString().replaceAll("(", "").replaceAll(")", "");
      String name = data.values.toString().replaceAll("(", "").replaceAll(")", "");

      if(mail != appointment.profile) {
        Map<String, String> map = {mail : name};
        colleaguesList.add(map);
      }
    }

    resultCode = await _reository.workColleaguesDelete(companyCode: companyCode, documentId: appointment.documentId.toString(), map: colleaguesList);


    return resultCode;
  }

}