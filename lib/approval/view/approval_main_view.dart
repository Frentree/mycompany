
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/approval/db/approval_firestore_repository.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/approval/view/approval_request_detail_view.dart';
import 'package:mycompany/approval/view/approval_response_detail_view.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';


class ApprovalMainView extends StatefulWidget {
  @override
  _ApprovalMainViewState createState() => _ApprovalMainViewState();
}

class _ApprovalMainViewState extends State<ApprovalMainView> {
  DateFormatCustom _format = DateFormatCustom();
  PublicFunctionRepository _publicFunctionReprository = PublicFunctionRepository();
  ApprovalFirebaseRepository _approvalFirebaseRepository = ApprovalFirebaseRepository();

  var _color = [checkColor, outWorkColor, Colors.purple, Colors.teal, annualColor, annualColor, annualColor, Colors.cyanAccent];
  int typeChoise = 1;
  var typeList = ["내근", "외근", "업무", "미팅", "연차", "반차", "휴가", "기타"];

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getApprovalData();
  }

  getApprovalData() async {
    List<ApprovalModel> requestApprovalData = await _approvalFirebaseRepository.getRequestApprovalData(companyCode: loginUser!.companyCode.toString());
    List<ApprovalModel> responseApprovalData = await _approvalFirebaseRepository.getResponseApprovalData(companyCode: loginUser!.companyCode.toString());
    List<EmployeeModel> employee = await ScheduleFunctionReprository().getEmployeeMy(companyCode: loginUser!.companyCode);

    setState(() {
      requestApproval = requestApprovalData;
      responseApproval = responseApprovalData;
      employeeList = employee;

      requestApproval.map((data) {
        if(data.status == "요청"){
          requestWaitingApproval.add(data);
        }else if(data.status == "승인"){
          requestCompleteApproval.add(data);
        }else if(data.status == "반려"){
          requestCancelApproval.add(data);
        }
      }).toList();

      responseApproval.map((data) {
        print(data.user);
        print(data.userMail);
        print(data.approvalMail);
        if(data.status == "요청"){
          responseWaitingApproval.add(data);
        }else if(data.status == "승인"){
          responseCompleteApproval.add(data);
        }else if(data.status == "반려"){
          responseCancelApproval.add(data);
        }
      }).toList();
    });
  }

  getApprovalClearDate() {
    requestWaitingApproval.clear();
    requestCompleteApproval.clear();
    requestCancelApproval.clear();
    responseWaitingApproval.clear();
    responseCompleteApproval.clear();
    responseCancelApproval.clear();
  }

  getRequestData({required BuildContext context, required List<ApprovalModel> approval, required int approvalName}){

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
            approvalName == 0 ? "approval_request".tr() : approvalName == 1 ? "approval_consent".tr() : "approval_return".tr(),
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
                      width: 50.0.w,
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
                          _format.getDate(date: _format.changeTimeStampToDateTime(timestamp: app.requestStartDate)),
                          style: TextStyle(
                              fontSize: 10.0.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Roboto"
                          ),
                        ),
                        Text(
                            _format.getDate(date: _format.changeTimeStampToDateTime(timestamp: app.requestEndDate)),
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
                getApprovalClearDate();
                getApprovalData();
              });
            }
          },
        ),
      );
    }

    return list;
  }

  getResponseData({required BuildContext context, required List<ApprovalModel> approval, required int approvalName}){

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
            approvalName == 0 ? "approval_request".tr() : approvalName == 1 ? "approval_consent".tr() : "approval_return".tr(),
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
                      width: 50.0.w,
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
                          _format.getDate(date: _format.changeTimeStampToDateTime(timestamp: app.requestStartDate)),
                          style: TextStyle(
                              fontSize: 10.0.sp,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Roboto"
                          ),
                        ),
                        Text(
                            _format.getDate(date: _format.changeTimeStampToDateTime(timestamp: app.requestEndDate)),
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
                getApprovalClearDate();
                getApprovalData();
              });
            }
          },
        ),
      );
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () => _publicFunctionReprository.onBackPressed(context: context),
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Container(
            width: double.infinity,
            color: whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 72.0.h + statusBarHeight,
                  width: double.infinity,
                  color: whiteColor,
                  padding: EdgeInsets.only(
                      top: statusBarHeight,
                      left: 26.0.w
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          color: whiteColor,
                          width: 20.0.w,
                          height: 30.0.h,
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            child: Container(
                                width: 14.9.w,
                                height: 14.9.h,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: workInsertColor,
                                )
                            ),
                          ),
                        ),
                        onTap: () => _publicFunctionReprository.onBackPressed(context: context),
                      ),
                      Text(
                          "approval".tr(),
                          style: getNotoSantRegular(
                              fontSize: 18.0,
                              color: textColor
                          )
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  height: 30.0.h,
                  width: double.infinity,
                  child: TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          "결재 신청함",
                          style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "결재 수신함",
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
                      SingleChildScrollView(
                        child: Column(
                            children: [
                              Column(
                                children: getRequestData(context: context, approval: requestWaitingApproval, approvalName: 0),
                              ),
                              Column(
                                children: getRequestData(context: context, approval: requestCompleteApproval, approvalName: 1),
                              ),
                              Column(
                                children: getRequestData(context: context, approval: requestCancelApproval, approvalName: 2),
                              ),
                            ]
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                            children: [
                              Column(
                                children: getResponseData(context: context, approval: responseWaitingApproval, approvalName: 0),
                              ),
                              Column(
                                children: getResponseData(context: context, approval: responseCompleteApproval, approvalName: 1),
                              ),
                              Column(
                                children: getResponseData(context: context, approval: responseCancelApproval, approvalName: 2),
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
