
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/attendance/widget/attendance_bottom_sheet.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/expense/db/expense_firestore_repository.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/expense/view/expense_registration_update_view.dart';
import 'package:mycompany/expense/view/expense_registration_view.dart';
import 'package:mycompany/expense/widget/expense_bottom_sheet_widget.dart';
import 'package:mycompany/expense/widget/expense_dialog_widget.dart';
import 'package:mycompany/expense/widget/expense_widget.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_function_repository.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:provider/provider.dart';

class ExpenseView extends StatefulWidget {
  @override
  _ExpenseViewState createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();
  ExpenseFirebaseRepository expenseFirebaseRepository = ExpenseFirebaseRepository();
  int _chosenValue = 0;
  int _chosenSendValue = 0;
  DateFormatCustom _format = DateFormatCustom();

  List<String> docIdList = [];
  int totalCost = 0;

  List<String> seleteItem = <String>[
    '1개월',
    '3개월',
    '6개월',
    '12개월',
    '24개월',
    '전체',
  ];

  List<String> seleteSendItem = <String>[
    '전체',
    '미입금',
    '입금완료',
  ];

  @override
  Widget build(BuildContext context) {
    EmployeeModel loginEmployee = Provider.of<EmployeeModel>(context);
    UserModel loginUser = PublicFunction().getUserProviderSetting(context);
    return WillPopScope(
        onWillPop: () => _publicFunctionRepository.onScheduleBackPressed(context: context),
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
                      height: 98.0.h,
                      padding: EdgeInsets.only(
                        right: 27.5.w,
                        left: 27.5.w,
                        top: 33.0.h,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xff000000).withOpacity(0.16),
                                blurRadius: 3.0.h,
                                offset: Offset(0.0, 1.0)
                            )
                          ]
                      ),
                      child: SizedBox(
                        height: 55.0.h,
                        child: Row(
                          children: [
                            IconButton(
                              constraints: BoxConstraints(),
                              icon: Icon(
                                Icons.arrow_back_ios_outlined,
                              ),
                              iconSize: 24.0.h,
                              splashRadius: 24.0.r,
                              onPressed: () => _publicFunctionRepository.onBackPressed(context: context),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                              color: Color(0xff2093F0),
                            ),
                            SizedBox(
                              width: 14.7.w,
                            ),
                            Text(
                              "expense".tr(),
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                fontWeight: fontWeight['Medium'],
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0.h,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                      height: 30.0.h,
                      width: double.infinity,
                      child: TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              "경비 보관함".tr(),
                              style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                            ),
                          ),
                          Tab(
                            child: Text(
                              "경비 입금내역".tr(),
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
                          Column(
                            children: [
                              Container(
                                height: 60.0.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "기간 선택",
                                      style: getNotoSantBold(fontSize: 13, color: textColor),
                                    ),
                                    SizedBox(width: 20.0.w,),
                                    DropdownButton<int>(
                                      value: _chosenValue,
                                      focusColor: Colors.white,
                                      style: getNotoSantMedium(fontSize: 12, color: textColor),
                                      items: seleteItem.map((value) =>
                                        DropdownMenuItem<int>(
                                        value: seleteItem.indexOf(value),
                                        child: Text(value,style:TextStyle(color:Colors.black),),
                                      )).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _chosenValue  = val!;
                                        });
                                      },
                                    ),
                                    Expanded(child: Container(),),
                                    Container(
                                      height: 27.0.h,
                                      child: ElevatedButton(
                                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseRegistrationView())),
                                        style: ElevatedButton.styleFrom(
                                          primary: whiteColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14.0.r),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "경비 입력",
                                            style: TextStyle(
                                              fontSize: 13.0.sp,
                                              color: Color(0xff2093F0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: StreamBuilder<List<ExpenseModel>>(
                                    stream: expenseFirebaseRepository.getExpense(loginUser: loginUser),
                                    builder: (context, snapshot) {
                                      if(!snapshot.hasData){
                                        return Container();
                                      }
                                      List<ExpenseModel> expenseList = snapshot.data!;

                                      expenseList.sort((a, b) => b.buyDate.compareTo(a.buyDate));
                                      List<ExpenseModel> waitingExpense = [];   // 결재 미진행
                                      List<ExpenseModel> progressExpense = [];  // 결재 진행중
                                      List<ExpenseModel> successExpense = [];   // 결재 완료
                                      List<ExpenseModel> completeExpense = [];   // 입금 완료

                                      expenseList.map((e) {
                                        DateTime buyTime = _format.changeTimestampToDateTime(timestamp: e.buyDate);
                                        DateTime now = DateTime.now();
                                        if(e.status == "미"){
                                          waitingExpense.add(e);
                                        } else if (e.status == "진"){
                                          if(_chosenValue == 4){
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 0 && buyTime.difference(DateTime(now.year, now.month - 1, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 1 && buyTime.difference(DateTime(now.year, now.month - 3, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 2 && buyTime.difference(DateTime(now.year, now.month - 6, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 3 && buyTime.difference(DateTime(now.year, now.month - 12, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 5 && buyTime.difference(DateTime(now.year, now.month - 24, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          }
                                        } else if (e.status == "결"){
                                          if(_chosenValue == 4){
                                            successExpense.add(e);
                                          } else if (_chosenValue == 0 && buyTime.difference(DateTime(now.year, now.month - 1, 1)).inDays > 0) {
                                            successExpense.add(e);
                                          } else if (_chosenValue == 1 && buyTime.difference(DateTime(now.year, now.month - 3, 1)).inDays > 0) {
                                            successExpense.add(e);
                                          } else if (_chosenValue == 2 && buyTime.difference(DateTime(now.year, now.month - 6, 1)).inDays > 0) {
                                            successExpense.add(e);
                                          } else if (_chosenValue == 3 && buyTime.difference(DateTime(now.year, now.month - 12, 1)).inDays > 0) {
                                            successExpense.add(e);
                                          } else if (_chosenValue == 5 && buyTime.difference(DateTime(now.year, now.month - 24, 1)).inDays > 0) {
                                            successExpense.add(e);
                                          }
                                        }else {
                                          if(_chosenValue == 4){
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 0 && buyTime.difference(DateTime(now.year, now.month - 1, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 1 && buyTime.difference(DateTime(now.year, now.month - 3, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 2 && buyTime.difference(DateTime(now.year, now.month - 6, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 3 && buyTime.difference(DateTime(now.year, now.month - 12, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 5 && buyTime.difference(DateTime(now.year, now.month - 24, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          }
                                        }
                                      }).toList();

                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Column(
                                              children: getNotExpenseData(context: context, expenseList: waitingExpense, expenseName: "미결재 (선택가능)"),
                                            ),
                                            Column(
                                              children: getExpenseData(context: context, expenseList: successExpense, expenseName: "결재 진행중"),
                                            ),
                                            Column(
                                              children: getExpenseData(context: context, expenseList: progressExpense, expenseName: "입금 진행중"),
                                            ),
                                            Column(
                                              children: getExpenseData(context: context, expenseList: completeExpense, expenseName: "입금완료"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                height: 60.0.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "기간 선택",
                                      style: getNotoSantBold(fontSize: 13, color: textColor),
                                    ),
                                    SizedBox(width: 20.0.w,),
                                    DropdownButton<int>(
                                      value: _chosenValue,
                                      focusColor: Colors.white,
                                      style: getNotoSantMedium(fontSize: 12, color: textColor),
                                      items: seleteItem.map((value) =>
                                          DropdownMenuItem<int>(
                                            value: seleteItem.indexOf(value),
                                            child: Text(value,style:TextStyle(color:Colors.black),),
                                          )).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _chosenValue  = val!;
                                        });
                                      },
                                    ),
                                    Expanded(child: Container(),),
                                    Text(
                                      "입금",
                                      style: getNotoSantBold(fontSize: 13, color: textColor),
                                    ),
                                    SizedBox(width: 20.0.w,),
                                    DropdownButton<int>(
                                      value: _chosenSendValue,
                                      focusColor: Colors.white,
                                      style: getNotoSantMedium(fontSize: 12, color: textColor),
                                      items: seleteSendItem.map((value) =>
                                          DropdownMenuItem<int>(
                                            value: seleteSendItem.indexOf(value),
                                            child: Text(value,style:TextStyle(color:Colors.black),),
                                          )).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _chosenSendValue  = val!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: (loginEmployee.level!.contains(9) || loginEmployee.level!.contains(7)) ?
                                StreamBuilder<List<ApprovalModel>>(
                                  stream: expenseFirebaseRepository.getApprovalExpensed(loginUser: loginUser),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData){
                                      return Container();
                                    }
                                    List<ApprovalModel> approvalList = snapshot.data!;

                                    if(approvalList.length == 0) {
                                      return Container(child: Text("신청한 경비 내용이 없습니다.",
                                        style: getRobotoRegular(fontSize: 15, color: textColor),
                                      ),);
                                    }

                                    approvalList.sort((a, b) => a.requestStartDate.compareTo(b.requestStartDate));
                                    approvalList.sort((a, b) => a.userMail.compareTo(b.userMail));


                                    return SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Column(children: getNotApprovalExpenseData(context: context, approvalList: approvalList, loginUser: loginUser),),
                                        ]
                                      ),
                                    );
                                  },
                                ) : StreamBuilder<List<ApprovalModel>>(
                                  stream: expenseFirebaseRepository.getMyApprovalExpensed(loginUser: loginUser),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData){
                                      return Container();
                                    }
                                    List<ApprovalModel> approvalList = snapshot.data!;

                                    if(approvalList.length == 0) {
                                      return Container(child: Text("신청한 경비 내용이 없습니다.",
                                        style: getRobotoRegular(fontSize: 15, color: textColor),
                                      ),);
                                    }

                                    approvalList.sort((a, b) => a.requestStartDate.compareTo(b.requestStartDate));
                                    approvalList.sort((a, b) => a.userMail.compareTo(b.userMail));


                                    return SingleChildScrollView(
                                      child: Column(
                                          children: [
                                            Column(children: getNotMyApprovalExpenseData(context: context, approvalList: approvalList, loginUser: loginUser),),
                                          ]
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
            bottomSheet:  Visibility(
              visible: docIdList.length > 0,
              child: Row(
                children: [
                  expenseBottomSheetButton(
                    context: context,
                      buttonName: 'dialogCancel'.tr(),
                      buttonNameColor: textColor,
                      buttonColor: Color(0xffF7F7F7),
                      buttonAction: () {
                        docIdList.clear();
                        totalCost = 0;
                        setState(() {});
                      }
                  ),
                  expenseBottomSheetButton(
                      context: context,
                      buttonName: "결재자 지정",
                      buttonNameColor: whiteColor,
                      buttonColor: Color(0xff2093F0),
                      buttonAction: () async {
                        List<EmployeeModel> approvalList = await LoginFirestoreRepository().readAllEmployeeData(companyId: loginUser.companyCode!);
                        await selectExpenseApprovalBottomSheet(context: context, approvalList: approvalList, loginUser: loginUser, docId: docIdList, totalCost: totalCost);

                        docIdList.clear();
                        totalCost = 0;
                        setState(() {});
                      }
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }


  getNotMyApprovalExpenseData({required BuildContext context, required List<ApprovalModel> approvalList, required UserModel loginUser}){
    List<Widget> list = <Widget>[Container(width: 16.w)];
    List<ApprovalModel> approvalListChk =[];
    String email = "";
    DateTime now = DateTime.now();

    if(approvalList.isEmpty){
      return list;
    }
    int count = 0;
    Column column = Column(children: [],);

    for(ApprovalModel app in approvalList){
      DateTime approvalTime = _format.changeTimestampToDateTime(timestamp: app.requestStartDate);

      if(_chosenSendValue == 0){

      } else if(_chosenSendValue == 1 && app.isSend != false){
        continue;
      } else if(_chosenSendValue == 2 && app.isSend != true){
        continue;
      }

      if(_chosenValue == 4){
        approvalListChk.add(app);
      } else if (_chosenValue == 0 && approvalTime.difference(DateTime(now.year, now.month - 1, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 1 && approvalTime.difference(DateTime(now.year, now.month - 3, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 2 && approvalTime.difference(DateTime(now.year, now.month - 6, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 3 && approvalTime.difference(DateTime(now.year, now.month - 12, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 5 && approvalTime.difference(DateTime(now.year, now.month - 24, 1)).inDays > 0) {
        approvalListChk.add(app);
      }
    }

    for(ApprovalModel app in approvalListChk){
      if(email == app.userMail){
        count++;
      } else {
        email = app.userMail;
        count = 0;
        column = Column(children: [],);
      }

      column.children.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 5.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 60.0.w,
                    child: Text(
                      (app.isSend! == false) ? "미입금" : "입금완료",
                      style: getRobotoBold(fontSize: 13, color: (app.isSend! == false) ? Colors.red : Colors.blue),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    )
                ),
                Container(
                    width: 80.0.w,
                    child: Text(
                      app.requestStartDate.toDate().month.toString() + "월 경비" ,
                      style: getRobotoBold(fontSize: 13, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    )
                ),
                Container(
                    child: Text(app.totalCost!.toString() + "원",
                      style: getRobotoBold(fontSize: 13, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    )
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                      Icons.zoom_in
                  ),
                  onPressed: () {
                    showExpenseDataDetail(context: context, model: app, loginUser: loginUser);
                  },
                ),

              ],
            ),
          ],
        ),
      ));

      if(count == 0){
        list.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xff9C9C9C).withOpacity(0.3),
                  offset: Offset(1.0, 15.0),
                  blurRadius: 20.0,
                ),
              ],
              color: whiteColor,
              borderRadius: BorderRadius.circular(12.0.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 10.0.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff2093F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0.r),
                      topRight: Radius.circular(12.0.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.user,
                        style: getRobotoBold(fontSize: 13, color: whiteColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    column
                  ],
                ),
              ],
            ),
          ),
        ));
        list.add(SizedBox(height: 20.0.h,));
      }
    }

    return list;
  }

  getNotApprovalExpenseData({required BuildContext context, required List<ApprovalModel> approvalList, required UserModel loginUser}){
    List<Widget> list = <Widget>[Container(width: 16.w)];
    List<ApprovalModel> approvalListChk =[];
    String email = "";
    DateTime now = DateTime.now();

    if(approvalList.isEmpty){
      return list;
    }
    int count = 0;
    Column column = Column(children: [],);

    for(ApprovalModel app in approvalList){
      DateTime approvalTime = _format.changeTimestampToDateTime(timestamp: app.requestStartDate);

      if(_chosenSendValue == 0){

      } else if(_chosenSendValue == 1 && app.isSend != false){
        continue;
      } else if(_chosenSendValue == 2 && app.isSend != true){
        continue;
      }

      if(_chosenValue == 4){
        approvalListChk.add(app);
      } else if (_chosenValue == 0 && approvalTime.difference(DateTime(now.year, now.month - 1, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 1 && approvalTime.difference(DateTime(now.year, now.month - 3, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 2 && approvalTime.difference(DateTime(now.year, now.month - 6, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 3 && approvalTime.difference(DateTime(now.year, now.month - 12, 1)).inDays > 0) {
        approvalListChk.add(app);
      } else if (_chosenValue == 5 && approvalTime.difference(DateTime(now.year, now.month - 24, 1)).inDays > 0) {
        approvalListChk.add(app);
      }
    }

    for(ApprovalModel app in approvalListChk){
      if(email == app.userMail){
        count++;
      } else {
        email = app.userMail;
        count = 0;
        column = Column(children: [],);
      }

      column.children.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 5.0.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 60.0.w,
                    child: Text(
                      (app.isSend! == false) ? "미입금" : "입금완료",
                      style: getRobotoBold(fontSize: 13, color: (app.isSend! == false) ? Colors.red : Colors.blue),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    )
                ),
                Container(
                    width: 80.0.w,
                    child: Text(
                      app.requestStartDate.toDate().month.toString() + "월 경비" ,
                      style: getRobotoBold(fontSize: 13, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    )
                ),
                Container(
                    child: Text(app.totalCost!.toString() + "원",
                      style: getRobotoBold(fontSize: 13, color: textColor),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    )
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                      Icons.zoom_in
                  ),
                  onPressed: () {
                    showExpenseDataDetail(context: context, model: app, loginUser: loginUser);
                  },
                ),
                Visibility(
                  visible: app.isSend == false,
                  child: IconButton(
                    icon: Icon(
                        Icons.double_arrow
                    ),
                    onPressed: () async {
                      await loginDialogWidget(context: context, message: "expense_dialog_2".tr(),
                        actions: [
                          confirmElevatedButton(
                              topPadding: 81.0.h,
                              buttonName: "dialogConfirm".tr(),
                              buttonAction: () async {
                                await app.reference!.update({"isSend" : true});
                                await expenseFirebaseRepository.updatgeExpenseStatusData(loginUser: loginUser, mail: app.userMail, docsId: app.docIds!, status: "입완");
                                Navigator.pop(context, true);
                              },
                              customWidth: 80.0,
                              customHeight: 40.0),
                          confirmElevatedButton(
                              topPadding: 81.0.h,
                              buttonName: "dialogCancel".tr(),
                              buttonAction: () => Navigator.pop(context, false),
                              customWidth: 80.0,
                              customHeight: 40.0),
                      ]);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ));

      if(count == 0){
        list.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0.w),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Color(0xff9C9C9C).withOpacity(0.3),
                  offset: Offset(1.0, 15.0),
                  blurRadius: 20.0,
                ),
              ],
              color: whiteColor,
              borderRadius: BorderRadius.circular(12.0.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0.w,
                    vertical: 10.0.h,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xff2093F0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0.r),
                      topRight: Radius.circular(12.0.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        app.user,
                        style: getRobotoBold(fontSize: 13, color: whiteColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    column
                  ],
                ),
              ],
            ),
          ),
        ));
        list.add(SizedBox(height: 20.0.h,));
      }
    }

    return list;
  }


  getNotExpenseData({required BuildContext context, required List<ExpenseModel> expenseList, required String expenseName}){
    var list = <Widget>[Container(width: 16.w)];

    if(expenseList.isEmpty){
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
            expenseName,
            style: getNotoSantBold(fontSize: 12.0, color: textColor),
          ),
        ),
        SizedBox(height: 15.0.h,),
      ],
    ));

    for(ExpenseModel app in expenseList){
      list.add(
          InkWell(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 1.0.w, vertical: 1.0.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0.r),
                      ),
                      color: docIdList.contains(app.reference!.id) ? workInsertColor : whiteColor,
                    ),
                    child: Center(
                      child: Container(
                        height: 50.0.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0.r),
                          ),
                          color: whiteColor,
                        ),
                        padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.cyan,
                                  borderRadius: BorderRadius.all(Radius.circular(20.0.r))
                              ),
                              width: 34.0.w,
                              height: 19.0.h,
                              child: Center(
                                child: Text(
                                  app.contentType,
                                  style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0.w,),
                            Container(
                              width: 130.0.w,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _format.getDate(date: _format.changeTimestampToDateTime(timestamp: app.buyDate)).toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: getNotoSantBold(fontSize: 12.0, color: textColor),
                                  ),
                                  Text(
                                    app.detailNote.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.0.w,),
                            Container(
                              width: 50.0.w,
                              child: Text(
                                "${app.cost}원",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                              ),
                            ),
                            SizedBox(width: 10.0.w,),
                            Visibility(
                              visible: app.imageUrl != "",
                              child: InkWell(
                                child: SvgPicture.asset(
                                  'assets/icons/price.svg',
                                  width: 40.51.w,
                                  height: 23.37.h,
                                ),
                                onTap: () => expenseReceiptWidget(context: context, ImageUrl: app.imageUrl),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                width: 30.0.w,
                                child: PopupMenuButton<int>(
                                  padding: EdgeInsets.all(0),
                                  icon: SvgPicture.asset(
                                    'assets/icons/vertical_menu.svg',
                                    width: 15.8.w,
                                    height: 15.76.h,
                                    color: blackColor,
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 1,
                                      child: Text(
                                        "update".tr(),
                                        style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Text(
                                        "delete".tr(),
                                        style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) async {
                                    if(value == 1){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseRegistrationUpdateView(model: app,)));
                                    }else {
                                      await loginDialogWidget(
                                          context: context,
                                          message: "expense_dialog_1".tr(),
                                          actions: [
                                            confirmElevatedButton(
                                                topPadding: 81.0.h,
                                                buttonName: "dialogConfirm".tr(),
                                                buttonAction: () async {
                                                  app.reference!.delete();
                                                  Navigator.pop(context);
                                                },
                                                customWidth: 80.0,
                                                customHeight: 40.0
                                            ),
                                            confirmElevatedButton(
                                                topPadding: 81.0.h,
                                                buttonName: "dialogCancel".tr(),
                                                buttonAction: () => Navigator.pop(context),
                                                customWidth: 80.0,
                                                customHeight: 40.0
                                            ),
                                          ]
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.0.h,),
              ],
            ),
            onTap: () async {
              if(!docIdList.contains(app.reference!.id)){
                docIdList.add(app.reference!.id);
                totalCost += app.cost;
              } else {
                docIdList.remove(app.reference!.id);
                totalCost -= app.cost;
              }
              setState(() {});
            },
          )
      );
    }
    list.add(SizedBox(height: 20.0.h,));
    return list;
  }

  getExpenseData({required BuildContext context, required List<ExpenseModel> expenseList, required String expenseName}){
    var list = <Widget>[Container(width: 16.w)];

    if(expenseList.isEmpty){
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
            expenseName,
            style: getNotoSantBold(fontSize: 12.0, color: textColor),
          ),
        ),
        SizedBox(height: 15.0.h,),
      ],
    ));

    for(ExpenseModel app in expenseList){
      list.add(
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0.w),
              child: Container(
                height: 50.0.h,
                padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.cyan,
                          borderRadius: BorderRadius.all(Radius.circular(20.0.r))
                      ),
                      width: 34.0.w,
                      height: 19.0.h,
                      child: Center(
                        child: Text(
                          app.contentType,
                          style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0.w,),
                    Container(
                      width: 130.0.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _format.getDate(date: _format.changeTimestampToDateTime(timestamp: app.buyDate)).toString(),
                            overflow: TextOverflow.ellipsis,
                            style: getNotoSantBold(fontSize: 12.0, color: textColor),
                          ),
                          Text(
                            app.detailNote.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5.0.w,),
                    Container(
                      width: 50.0.w,
                      child: Text(
                        "${app.cost}원",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                      ),
                    ),
                    SizedBox(width: 10.0.w,),
                    Visibility(
                      visible: app.imageUrl != "",
                      child: InkWell(
                        child: SvgPicture.asset(
                          'assets/icons/price.svg',
                          width: 40.51.w,
                          height: 23.37.h,
                        ),
                        onTap: () => expenseReceiptWidget(context: context, ImageUrl: app.imageUrl),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.0.h,),
          ],
        ),
      );
    }
    list.add(SizedBox(height: 20.0.h,));
    return list;
  }
}
