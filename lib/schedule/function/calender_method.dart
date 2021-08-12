import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/fcm/send_fcm.dart';
import 'package:mycompany/public/model/public_comment_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:mycompany/schedule/view/schedule_registration_update_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/schedule_dialog_widget.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';
import 'package:provider/provider.dart';

class CalenderMethod {
  final ScheduleFirebaseReository _repository = ScheduleFirebaseReository();
  ApprovalFirebaseRepository approvalRepository = ApprovalFirebaseRepository();

  Future<List<Appointment>> getSheduleData({required String companyCode, required List<EmployeeModel> empList}) async {
    var _color = [checkColor, outWorkColor, Colors.purple, Colors.purple, Colors.teal, annualColor, annualColor, annualColor, Colors.cyanAccent];

    int typeChoise = 1;
    var typeList = ["내근", "외근", "요청", "업무", "미팅", "연차", "반차", "휴가", "기타"];

    final List<Appointment> shedules = <Appointment>[];
    var schduleData = await _repository.getSchedules(companyCode: companyCode);

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

      if (typeList.contains(type)) {
        typeChoise = typeList.indexOf(type);
      } else {
        typeChoise = 6;
      }

      final DateTime startTime = DateTime.parse(startTimes.toDate().toString());
      final DateTime endTime = model.endTime == null ? startTime.add(const Duration(hours: 0)) : DateTime.parse(model.endTime!.toDate().toString());

      var colleagues = model.colleagues!;

      for (var data in colleagues) {
        Map<String, dynamic> map = data;
        String mail = map.keys.toString().replaceAll("(", "").replaceAll(")", "");
        String name = map.values.toString().replaceAll("(", "").replaceAll(")", "");
        EmployeeModel empModel = empList.where((element) => element.mail == mail).first;

        if (mailChkList.contains(mail)) {
          shedules.add(Appointment(
            isAllDay: model.allDay,
            startTime: startTime,
            endTime: endTime,
            subject: name,
            color: _color[typeChoise],
            notes: notes,
            type: type,
            profile: mail.toString(),
            userName: name,
            userMail: mail,
            team: empModel.team,
            title: title,
            content: content,
            colleagues: model.colleagues,
            documentId: doc.id,
            position: empModel.position,
            location: location != null ? location : "",
            organizerId: model.createUid,
            organizerName: model.name,
          ));
        }
      }
    }

    return shedules;
  }

  void getScheduleDetail({required CalendarTapDetails details, required BuildContext context, required UserModel loginUser, required List<EmployeeModel> employeeList}) {
    List<dynamic> appointment = details.appointments!;
    DateTime? dates = details.date;
    //CalendarElement element = details.targetElement; //  달력 요소

    if (appointment.length != 0) {
      showScheduleDetail(context: context, data: appointment, date: dates!, loginUser: loginUser, employeeList: employeeList);
    } else {
      showNotScheduleDetail(context: context, date: dates!, loginUser: loginUser, employeeList: employeeList);
    }
  }

  Future<DateTime> dateSet(DateTime date, BuildContext context) async {
    DateTime pickTime = await showDatesPicker(context: context, date: date);
    //CalendarElement element = details.targetElement; //  달력 요소

    return pickTime;
  }

  Future<DateTime> dateTimeSet(DateTime date, BuildContext context) async {
    DateTime pickTime = await showDateTimePicker(context: context, date: date);
    //CalendarElement element = details.targetElement; //  달력 요소

    return pickTime;
  }

/*  void mainNavigator(CalendarTapDetails details, BuildContext context, List<EmployeeModel> employeeList) {
    dynamic appointment = details.appointments;
    DateTime? date = details.date;
    //CalendarElement element = details.targetElement; //  달력 요소
    if (appointment != null) {
      showScheduleDetail(context: context, data: appointment, loginUser: loginUser, date: date!, employeeList: employeeList);
    }
  }*/

  Future<List<TeamModel>> getTeam(String? companyCode) async {
    List<TeamModel> teamList = [];
    var teamData = await _repository.getTeamDocument(companyCode: companyCode);

    List<QueryDocumentSnapshot> teamSnapshot = teamData.docs;

    for (var doc in teamSnapshot) {
      teamList.add(TeamModel.fromMap(mapData: (doc.data() as Map<dynamic, dynamic>), reference: doc.reference));
    }

    return teamList;
  }

  Future<List<EmployeeModel>> getEmployee(UserModel loginUser) async {
    List<EmployeeModel> empList = [];
    var empData = await _repository.getCompanyUser(loginUser: loginUser);

    List<QueryDocumentSnapshot> empSnapshot = empData.docs;

    for (var doc in empSnapshot) {
      empList.add(EmployeeModel.fromMap(mapData: (doc.data() as Map<dynamic, dynamic>)));
    }

    return empList;
  }

  // 나 포함
  Future<List<EmployeeModel>> getEmployeeMy(String? companyCode) async {
    List<EmployeeModel> empList = [];
    var empData = await _repository.getMyAndCompanyUser(companyCode: companyCode);

    List<QueryDocumentSnapshot> empSnapshot = empData.docs;

    for (var doc in empSnapshot) {
      empList.add(EmployeeModel.fromMap(mapData: (doc.data() as Map<dynamic, dynamic>), reference: doc.reference));
    }

    return empList;
  }

  // 스케줄 입력
  Future<bool> insertSchedule({
    required UserModel loginUser,
    required bool allDay,
    required String workName,
    required String title,
    required String content,
    String? location,
    required DateTime startTime,
    required DateTime endTime,
    required List<Map<String, String>>? colleaguesList,
    required bool isAllDay,
    EmployeeModel? approvalUser,
  }) async {
    // 선택된 동료 리스트
    bool result = false;

    if (workName == "요청" || workName == "재택" || workName == "외출" || workName == "외근" || workName == "연차") {
      if (approvalUser == null || approvalUser.mail == "") {
        return false;
      }
    }

    if (workName == "연차" && !allDay) {
      workName = "반차";
      title = "반차";
    } else if (workName == "연차" && allDay) {
      title = "연차";
    }

    WorkModel workModel = WorkModel(
      allDay: allDay,
      type: workName == "요청" ? "외근" : workName,
      title: title,
      contents: content,
      location: location,
      startTime: Timestamp.fromDate(startTime),
      endTime: Timestamp.fromDate(endTime),
      colleagues: colleaguesList,
      name: workName == "요청" ? approvalUser!.name : loginUser.name,
      createUid: workName == "요청" ? approvalUser!.mail : loginUser.mail,
    );

    switch (workName) {
      case "내근":
      case "미팅":
        result = await _repository.insertWorkNotApprovalDocument(workModel: workModel, companyCode: loginUser.companyCode!);
        break;
      case "외근":
      case "요청":
      case "업무":
        result = await _repository.insertWorkApprovalDocument(workModel: workModel, approvalUser: approvalUser!, loginUser: loginUser);
        sendFcmWithTokens(
            loginUser, [approvalUser.mail], "[결재 요청]", "[${loginUser.name}] 님이 ${workName == "요청" ? "업무 요청" : workName} 결재를 요청 했습니다.", "");
        break;
      case "재택":
      case "외출":
      case "연차":
      case "반차":
        result = await approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser!, loginUser: loginUser);
        sendFcmWithTokens(loginUser, [approvalUser.mail], "[결재 요청]", "[${loginUser.name}] 님이 ${workName} 결재를 요청 했습니다.", "");
        break;
    }

    if (workModel.type == "기타" && approvalUser!.mail == "") {
      result = await _repository.insertWorkNotApprovalDocument(workModel: workModel, companyCode: loginUser.companyCode!);
    } else if (workModel.type == "기타" && approvalUser!.mail != "") {
      result = await _repository.insertWorkApprovalDocument(workModel: workModel, approvalUser: approvalUser, loginUser: loginUser);
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
    required List<Map<String, dynamic>> colleaguesList,
    required bool isAllDay,
    EmployeeModel? approvalUser,
    required UserModel loginUser,
  }) async {
    // 선택된 동료 리스트
    bool result = false;

    if (workName == "요청" || workName == "재택" || workName == "외출" || workName == "외근") {
      if (approvalUser == null || approvalUser.mail == "") {
        return false;
      }
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
      name: workName == "요청" ? approvalUser!.name : loginUser.name,
      createUid: workName == "요청" ? approvalUser!.mail : loginUser.mail,
    );

    switch (workName) {
      case "내근":
      case "미팅":
        result = await _repository.updateWorkNotApprovalDocument(workModel: workModel, companyCode: companyCode, documentId: documentId);
        break;
      case "외근":
      case "요청":
        result = await _repository.updateWorkApprovalDocument(
            workModel: workModel, loginUser: loginUser, approvalUser: approvalUser!, documentId: documentId);
        break;
      case "재택":
      case "외출":
      case "연차":
        result = await approvalRepository.insertWorkApproval(workModel: workModel, approvalUser: approvalUser!, loginUser: loginUser);
        break;
    }

    if (workModel.type == "기타" && approvalUser!.mail == "") {
      result = await _repository.updateWorkNotApprovalDocument(workModel: workModel, companyCode: companyCode, documentId: documentId);
    } else if (workModel.type == "기타" && approvalUser!.mail != "") {
      result = await _repository.updateWorkApprovalDocument(
          workModel: workModel, loginUser: loginUser, approvalUser: approvalUser, documentId: documentId);
    }

    return result;
  }

  // 스케줄 수정
  Future<int> updateScheduleWork({
    required BuildContext context,
    required String companyCode,
    required String documentId,
    required Appointment appointment,
    required UserModel loginUser,
    required EmployeeModel loginEmployee,
  }) async {
    int resultCode = 0; // 0 : 성공, 404 : 결재 중인 항목일때, 405 : 스케줄 삭제 오류

    if (appointment.type == "반차" || appointment.type == "연차") {
      return 400;
    }

    var approvalResult = await _repository.getApprovalListSizeDocument(companyCode: companyCode, documentId: documentId);

    if (approvalResult) {
      var scheduleResult = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StreamProvider<EmployeeModel>(
                  create: (BuildContext context) => PublicFirebaseRepository().getEmployeeUser(loginUser: loginUser),
                  initialData: loginEmployee,
                  child: ScheduleRegisrationUpdateView(documentId: documentId, appointment: appointment))));
      if (!scheduleResult) {
        resultCode = 407;
      }
    } else {
      resultCode = 406;
    }

    return resultCode;
  }

  // 스케줄 삭제
  Future<int> deleteSchedule({required String companyCode, required String documentId}) async {
    int resultCode = 0; // 0 : 성공, 404 : 결재 중인 항목일때, 405 : 스케줄 삭제 오류

    var approvalResult = await _repository.getApprovalListSizeDocument(companyCode: companyCode, documentId: documentId);

    if (approvalResult) {
      var scheduleResult = await _repository.deleteScheduleDocument(companyCode: companyCode, documentId: documentId);
      if (!scheduleResult) {
        resultCode = 405;
      }
    } else {
      resultCode = 404;
    }

    return resultCode;
  }

  // 초대된 동료에서 빠지기
  Future<int> deleteColleagues({required String companyCode, required Appointment appointment}) async {
    int resultCode = 0;
    List<dynamic> colleagues = appointment.colleagues!;

    List<Map<String, String>> colleaguesList = [];

    for (var data in colleagues) {
      String mail = data.keys.toString().replaceAll("(", "").replaceAll(")", "");
      String name = data.values.toString().replaceAll("(", "").replaceAll(")", "");

      if (mail != appointment.profile) {
        Map<String, String> map = {mail: name};
        colleaguesList.add(map);
      }
    }

    resultCode = await _repository.workColleaguesDelete(companyCode: companyCode, documentId: appointment.documentId.toString(), map: colleaguesList);

    return resultCode;
  }

  // 스케줄 댓글등록
  Future<int> insertScheduleCommentMethod(
      {required UserModel loginUser, CommentModel? model, required TextEditingController noticeComment, required Appointment mode}) async {
    late CommentModel insertModel;
    DateFormatCustom _formatCustom = DateFormatCustom();

    var result = -1;

    if (model == null) {
      insertModel =
          CommentModel(level: 0, comment: noticeComment.text, createDate: Timestamp.now(), uid: loginUser.mail, uname: loginUser.name, commentId: "");
      if(mode.userMail != loginUser.mail){
        sendFcmWithTokens(loginUser, [mode.userMail],
            "[댓글 입력]",
            "[${loginUser.name}] 님이 ${_formatCustom.getDate(date: mode.startTime)} 일정에 댓글을 달았습니다.", "");
      }
    } else {
      insertModel = CommentModel(
          level: 1,
          comment: noticeComment.text,
          upComment: model.comment,
          upUid: model.uid,
          upUname: model.uname,
          createDate: Timestamp.now(),
          uid: loginUser.mail,
          uname: loginUser.name,
          commentId: model.reference!.id);

      if(loginUser.mail != model.uid){
        sendFcmWithTokens(loginUser, [model.uid],
            "[댓글 입력]",
            "[${loginUser.name}] 님이 ${_formatCustom.getDate(date: mode.startTime)} 일정에 댓글을 달았습니다.", "");
      }
    }

    result = await _repository.insertScheduleComment(companyCode: loginUser.companyCode, scheduleId: mode.documentId, model: insertModel);

    noticeComment.text = "";

    return result;
  }
}
