
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/expense/view/expense_registration_update_view.dart';
import 'package:mycompany/expense/view/expense_registration_view.dart';
import 'package:mycompany/expense/widget/expense_dialog_widget.dart';
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

class ExpenseView extends StatefulWidget {
  @override
  _ExpenseViewState createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();
  int _chosenValue = 0;
  DateFormatCustom _format = DateFormatCustom();

  List<String> docIdList = [];

  List<String> seleteItem = <String>[
    '전체',
    '1개월',
    '3개월',
    '6개월',
    '12개월',
  ];

  @override
  Widget build(BuildContext context) {
    
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
                                    stream: PublicFirebaseRepository().getExpense(loginUser: loginUser),
                                    builder: (context, snapshot) {
                                      if(!snapshot.hasData){
                                        return Container();
                                      }
                                      List<ExpenseModel> expenseList = snapshot.data!;

                                      expenseList.sort((a, b) => b.buyDate.compareTo(a.buyDate));
                                      List<ExpenseModel> waitingExpense = [];
                                      List<ExpenseModel> progressExpense = [];
                                      List<ExpenseModel> completeExpense = [];

                                      expenseList.map((e) {
                                        DateTime butTime = _format.changeTimestampToDateTime(timestamp: e.buyDate);
                                        DateTime now = DateTime.now();
                                        if(e.status == "미"){
                                          waitingExpense.add(e);
                                        } else if (e.status == "결"){
                                          if(_chosenValue == 0){
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 1 && butTime.difference(DateTime(now.year, now.month - 1, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 2 && butTime.difference(DateTime(now.year, now.month - 3, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 3 && butTime.difference(DateTime(now.year, now.month - 6, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          } else if (_chosenValue == 4 && butTime.difference(DateTime(now.year, now.month - 12, 1)).inDays > 0) {
                                            progressExpense.add(e);
                                          }
                                        } else {
                                          if(_chosenValue == 0){
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 1 && butTime.difference(DateTime(now.year, now.month - 1, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 2 && butTime.difference(DateTime(now.year, now.month - 3, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 3 && butTime.difference(DateTime(now.year, now.month - 6, 1)).inDays > 0) {
                                            completeExpense.add(e);
                                          } else if (_chosenValue == 4 && butTime.difference(DateTime(now.year, now.month - 12, 1)).inDays > 0) {
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
                                              children: getExpenseData(context: context, expenseList: progressExpense, expenseName: "진행중"),
                                            ),
                                            Column(
                                              children: getExpenseData(context: context, expenseList: completeExpense                                                                                                                                                          , expenseName: "입금완료"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                              ),
                            ],
                          ),
                          Text("gdgd"),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        )
    );
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
            onTap: () {
              if(!docIdList.contains(app.reference!.id)){
                docIdList.add(app.reference!.id);
              } else {
                docIdList.remove(app.reference!.id);
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
