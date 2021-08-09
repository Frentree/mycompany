
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/approval/view/approval_expense_request_detail_view.dart';
import 'package:mycompany/approval/view/approval_expense_response_detail_view.dart';
import 'package:mycompany/approval/view/approval_request_detail_view.dart';
import 'package:mycompany/approval/view/approval_response_detail_view.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/widget/schedule_dialog_widget.dart';


class ApprovalMainView extends StatefulWidget {
  final bool? approvalChk;


  ApprovalMainView({this.approvalChk,});

  @override
  _ApprovalMainViewState createState() => _ApprovalMainViewState();
}

class _ApprovalMainViewState extends State<ApprovalMainView> {

  DateFormatCustom _format = DateFormatCustom();
  ApprovalFirebaseRepository _approvalFirebaseRepository = ApprovalFirebaseRepository();

  var _color = [checkColor, outWorkColor, Colors.purple, Colors.teal, annualColor, annualColor, annualColor, Colors.cyanAccent, Colors.amber, Colors.purple, Colors.cyan];
  int typeChoise = 1;
  var typeList = ["내근", "외근", "업무", "미팅", "연차", "반차", "휴가", "기타", "연장", "요청", "경비"];
  
  late DateTime startDate;
  late DateTime endDate;

  
  // 전체 직원
  List<EmployeeModel> employeeList = <EmployeeModel>[];

  List<ApprovalModel> requestApproval = [];
  List<ApprovalModel> responseApproval = [];

  // 결재 신청 승인 대기, 완료, 취소
  List<ApprovalModel> requestWaitingApproval = [];
  List<ApprovalModel> requestCompleteApproval = [];
  List<ApprovalModel> requestCancelApproval = [];

  // 결재 수신 승인 대기, 완료, 취소
  List<ApprovalModel> responseWaitingApproval = [];
  List<ApprovalModel> responseCompleteApproval = [];
  List<ApprovalModel> responseCancelApproval = [];

  late UserModel loginUser;

  late int approvalChk;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
    getApprovalData();

    endDate = DateTime.now();
    startDate = endDate.add(Duration(days: -30));


    if(widget.approvalChk != null){
      approvalChk = 1;
    }else {
      approvalChk = 0;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  getApprovalData() async {
    List<EmployeeModel> employee = await ScheduleFunctionReprository().getEmployeeMy(companyCode: loginUser.companyCode);

    setState(() {
      employeeList = employee;
    });
  }

  getApprovalRequestClearDate() {
    requestWaitingApproval.clear();
    requestCompleteApproval.clear();
    requestCancelApproval.clear();
  }

  getApprovalResponseClearDate() {
    responseWaitingApproval.clear();
    responseCompleteApproval.clear();
    responseCancelApproval.clear();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: approvalChk,
      child: Container(
        width: double.infinity,
        color: whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              height: 30.0.h,
              width: double.infinity,
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "approval_application_box".tr(),
                      style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "approve_inbox".tr(),
                      style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _approvalFirebaseRepository.getRequestApprovalDataSnashot(loginUser: loginUser),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) {
                        return Container();
                      }

                      getApprovalRequestClearDate();

                      List<DocumentSnapshot> docs = snapshot.data!.docs;

                      docs.sort((a, b) => b.get("createDate").compareTo(a.get("createDate")));

                      docs.map((data) {
                        ApprovalModel model = ApprovalModel.fromMap(mapData: (data.data() as dynamic), reference: data.reference);
                        if(model.status == "요청"){
                          requestWaitingApproval.add(model);
                        }else if(model.status == "승인" && startDate.difference(model.createDate!.toDate()).inDays < 0 && endDate.difference(model.createDate!.toDate()).inDays > 0){
                          requestCompleteApproval.add(model);
                        }else if(model.status == "반려" && startDate.difference(model.createDate!.toDate()).inDays < 0 && endDate.difference(model.createDate!.toDate()).inDays > 0){
                          requestCancelApproval.add(model);
                        }
                      }).toList();

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: 60.0.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "신청일",
                                    style: getNotoSantBold(fontSize: 13, color: textColor),
                                  ),
                                  SizedBox(width: 20.0.w,),
                                  Row(
                                    children: [
                                      Container(
                                        width: 110.0.w,
                                        child: ElevatedButton(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _format.getDateSummary(date: startDate),
                                                style: TextStyle(
                                                  fontSize: 12.0.sp,
                                                  fontWeight: fontWeight["Medium"],
                                                  color: textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: blackColor.withOpacity(0.01),
                                            elevation: 10.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(13.0.r),
                                            ),
                                            shadowColor: blackColor.withOpacity(0.3),
                                          ),
                                          onPressed: () async {
                                            startDate = await showDatesPicker(context: context, date: startDate);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 15.0.w,),
                                      Container(
                                        width: 110.0.w,
                                        child: ElevatedButton(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _format.getDateSummary(date: endDate),
                                                style: TextStyle(
                                                  fontSize: 12.0.sp,
                                                  fontWeight: fontWeight["Medium"],
                                                  color: textColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: blackColor.withOpacity(0.01),
                                            elevation: 10.0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(13.0.r),
                                            ),
                                            shadowColor: blackColor.withOpacity(0.3),
                                          ),
                                          onPressed: () async{
                                            endDate = await showDatesPicker(context: context, date: endDate);
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ),
                            Column(
                              children: getRequestData(context: context, approval: requestWaitingApproval, approvalName: "approval_request".tr()),
                            ),
                            Column(
                              children: getRequestData(context: context, approval: requestCompleteApproval, approvalName: "approval_consent".tr()),
                            ),
                            Column(
                              children: getRequestData(context: context, approval: requestCancelApproval, approvalName: "approval_return".tr()),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _approvalFirebaseRepository.getResponseApprovalDataSnashot(loginUser: loginUser),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) {
                        return Container();
                      }

                      getApprovalResponseClearDate();

                      List<DocumentSnapshot> docs = snapshot.data!.docs;

                      docs.sort((a, b) => b.get("createDate").compareTo(a.get("createDate")));


                      docs.map((data) {
                        ApprovalModel model = ApprovalModel.fromMap(mapData: (data.data() as dynamic), reference: data.reference);
                        if(model.status == "요청"){
                          responseWaitingApproval.add(model);
                        }else if(model.status == "승인" && startDate.difference(model.createDate!.toDate()).inDays < 0 && endDate.difference(model.createDate!.toDate()).inDays > 0){
                          responseCompleteApproval.add(model);
                        }else if(model.status == "반려" && startDate.difference(model.createDate!.toDate()).inDays < 0 && endDate.difference(model.createDate!.toDate()).inDays > 0){
                          responseCancelApproval.add(model);
                        }
                      }).toList();

                      return SingleChildScrollView(
                        child: Column(
                            children: [
                              Container(
                                height: 60.0.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "신청일",
                                      style: getNotoSantBold(fontSize: 13, color: textColor),
                                    ),
                                    SizedBox(width: 20.0.w,),
                                    Row(
                                      children: [
                                        Container(
                                          width: 110.0.w,
                                          child: ElevatedButton(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _format.getDateSummary(date: startDate),
                                                  style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    fontWeight: fontWeight["Medium"],
                                                    color: textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: blackColor.withOpacity(0.01),
                                              elevation: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(13.0.r),
                                              ),
                                              shadowColor: blackColor.withOpacity(0.3),
                                            ),
                                            onPressed: () async {
                                              startDate = await showDatesPicker(context: context, date: startDate);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 15.0.w,),
                                        Container(
                                          width: 110.0.w,
                                          child: ElevatedButton(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _format.getDateSummary(date: endDate),
                                                  style: TextStyle(
                                                    fontSize: 12.0.sp,
                                                    fontWeight: fontWeight["Medium"],
                                                    color: textColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: blackColor.withOpacity(0.01),
                                              elevation: 10.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(13.0.r),
                                              ),
                                              shadowColor: blackColor.withOpacity(0.3),
                                            ),
                                            onPressed: () async{
                                              endDate = await showDatesPicker(context: context, date: endDate);
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Column(
                                children: getResponseData(context: context, approval: responseWaitingApproval, approvalName: "approval_request".tr()),
                              ),
                              Column(
                                children: getResponseData(context: context, approval: responseCompleteApproval, approvalName: "approval_consent".tr()),
                              ),
                              Column(
                                children: getResponseData(context: context, approval: responseCancelApproval, approvalName: "approval_return".tr()),
                              ),
                            ]
                        ),
                      );
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  getRequestData({required BuildContext context, required List<ApprovalModel> approval, required String approvalName}){

    var list = <Widget>[Container(width: 16.w)];

    if(approval.isEmpty){
      return list;
    }

    list.add(Column(
      children: [
        Container(
          width: double.infinity,
          height: 23.0.h,
          color: calendarDetailLineColor,
          padding: EdgeInsets.only(left: 17.0.w),
          alignment: Alignment.centerLeft,
          child: Text(
            approvalName,
            style: getNotoSantBold(fontSize: 12.0, color: textColor),
          ),
        ),
        SizedBox(height: 15.0.h,),
      ],
    ));

    for(ApprovalModel app in approval){
      int count = employeeList.indexWhere((element) => element.mail == app.approvalMail);
      String position = "";
      if(count != -1){
        position = employeeList[count].position!;
      }

      if(typeList.contains(app.approvalType)){
        typeChoise = typeList.indexOf(app.approvalType);
      } else {
        typeChoise = 6;
      }

      if(app.approvalType == "경비"){
        list.add(
          InkWell(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 36.0.h,
                  padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                              color: _color[typeChoise],
                              borderRadius: BorderRadius.all(Radius.circular(20.0.r))
                          ),
                          width: 34.0.w,
                          height: 19.0.h,
                          child: Center(
                            child: Text(
                              app.approvalType.toString(),
                              style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0.w,),
                      Container(
                        width: 50.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                app.approvalUser,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantBold(fontSize: 12.0, color: textColor)
                            ),
                            Text(
                                position,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30.0.w,
                      ),
                      Container(
                        width: 80.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.title.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantBold(fontSize: 12.0, color: textColor),
                            ),
                            Text(
                              _format.getDate(date: _format.changeTimestampToDateTime(timestamp: app.requestStartDate)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 13.0.w,
                      ),
                      Container(
                        width: 2.0.w,
                        height: 29.0.h,
                        color: _color[typeChoise],
                      ),
                      SizedBox(
                        width: 6.0.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            app.totalCost!.toString() + "원",
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Roboto"
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0.h,),
              ],
            ),
            onTap: () async {
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ApprovalExpenseRequestDetailView(model: app,)));

              if(result) {
                setState(() {
                  getApprovalRequestClearDate();
                  getApprovalData();
                });
              }
            },
          ),
        );
      } else {
        list.add(
          InkWell(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 36.0.h,
                  padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                              color: _color[typeChoise],
                              borderRadius: BorderRadius.all(Radius.circular(20.0.r))
                          ),
                          width: 34.0.w,
                          height: 19.0.h,
                          child: Center(
                            child: Text(
                              app.approvalType.toString(),
                              style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0.w,),
                      Container(
                        width: 50.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                app.approvalUser,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantBold(fontSize: 12.0, color: textColor)
                            ),
                            Text(
                                position,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30.0.w,
                      ),
                      Container(
                        width: 80.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.title.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantBold(fontSize: 12.0, color: textColor),
                            ),
                            Text(
                              app.requestContent.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 13.0.w,
                      ),
                      Container(
                        width: 2.0.w,
                        height: 29.0.h,
                        color: _color[typeChoise],
                      ),
                      SizedBox(
                        width: 6.0.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _format.getDateTimes(date: _format.changeTimestampToDateTime(timestamp: app.requestStartDate)),
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Roboto"
                            ),
                          ),
                          Text(
                              _format.getDateTimes(date: _format.changeTimestampToDateTime(timestamp: app.requestEndDate)),
                              style: getRobotoMedium(fontSize: 10.0, color: hintTextColor)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0.h,),
              ],
            ),
            onTap: () async {
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ApprovalRequestDetailView(model: app,)));

              if(result) {
                setState(() {
                  getApprovalRequestClearDate();
                  getApprovalData();
                });
              }
            },
          ),
        );
      }
    }
    list.add(SizedBox(height: 20.0.h,));

    return list;
  }

  getResponseData({required BuildContext context, required List<ApprovalModel> approval, required String approvalName}){

    var list = <Widget>[Container(width: 16.w)];

    if(approval.isEmpty){
      return list;
    }

    list.add(Column(
      children: [
        Container(
          width: double.infinity,
          height: 23.0.h,
          color: calendarDetailLineColor,
          padding: EdgeInsets.only(left: 17.0.w),
          alignment: Alignment.centerLeft,
          child: Text(
            approvalName,
            style: getNotoSantBold(fontSize: 12.0, color: textColor),
          ),
        ),
        SizedBox(height: 15.0.h,),
      ],
    ));

    for(ApprovalModel app in approval){
      int count = employeeList.indexWhere((element) => element.mail == app.userMail);
      String position = "";
      if(count != -1){
        position = employeeList[count].position!;
      }

      if(typeList.contains(app.approvalType)){
        typeChoise = typeList.indexOf(app.approvalType);
      } else {
        typeChoise = 6;
      }
      if(app.approvalType == "경비"){
        list.add(
          InkWell(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 36.0.h,
                  padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                  child: Row(
                    children: [
                      Container(
                        child: Container(
                          decoration: BoxDecoration(
                              color: _color[typeChoise],
                              borderRadius: BorderRadius.all(Radius.circular(20.0.r))
                          ),
                          width: 34.0.w,
                          height: 19.0.h,
                          child: Center(
                            child: Text(
                              app.approvalType.toString(),
                              style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0.w,),
                      Container(
                        width: 50.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                app.user,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantBold(fontSize: 12.0, color: textColor)
                            ),
                            Text(
                                position,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30.0.w,
                      ),
                      Container(
                        width: 80.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.title.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantBold(fontSize: 12.0, color: textColor),
                            ),
                            Text(
                              _format.getDate(date: _format.changeTimestampToDateTime(timestamp: app.requestStartDate)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 13.0.w,
                      ),
                      Container(
                        width: 2.0.w,
                        height: 29.0.h,
                        color: _color[typeChoise],
                      ),
                      SizedBox(
                        width: 6.0.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            app.totalCost!.toString() + "원",
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Roboto"
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0.h,),
              ],
            ),
            onTap: () async {
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ApprovalExpenseResponseDetailView(model: app,)));

              if(result) {
                setState(() {
                  getApprovalRequestClearDate();
                  getApprovalData();
                });
              }
            },
          ),
        );
      } else {
        list.add(
          InkWell(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 36.0.h,
                  padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                              color: _color[typeChoise],
                              borderRadius: BorderRadius.all(Radius.circular(20.0))
                          ),
                          width: 34.0.w,
                          height: 19.0.h,
                          child: Center(
                            child: Text(
                              app.approvalType.toString(),
                              style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0.w,),
                      Container(
                        width: 50.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                app.user,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantBold(fontSize: 12.0, color: textColor)
                            ),
                            Text(
                                position,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor)
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30.0.w,
                      ),
                      Container(
                        width: 80.0.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              app.title.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantBold(fontSize: 12.0, color: textColor),
                            ),
                            Text(
                              app.requestContent.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 13.0.w,
                      ),
                      Container(
                        width: 2.0.w,
                        height: 29.0.h,
                        color: _color[typeChoise],
                      ),
                      SizedBox(
                        width: 6.0.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _format.getDateTimes(date: _format.changeTimestampToDateTime(timestamp: app.requestStartDate)),
                            style: TextStyle(
                                fontSize: 10.0.sp,
                                fontWeight: FontWeight.w800,
                                fontFamily: "Roboto"
                            ),
                          ),
                          Text(
                              _format.getDateTimes(date: _format.changeTimestampToDateTime(timestamp: app.requestEndDate)),
                              style: getRobotoMedium(fontSize: 10.0, color: hintTextColor)
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0.h,),
              ],
            ),
            onTap: () async {
              var result = await Navigator.push(context, MaterialPageRoute(builder: (context) => ApprovalResponseDetailView(model: app,)));

              if(result) {
                setState(() {
                  getApprovalResponseClearDate();
                  getApprovalData();
                });
              }
            },
          ),
        );
      }
    }

    list.add(SizedBox(height: 20.0.h,));

    return list;
  }
}
