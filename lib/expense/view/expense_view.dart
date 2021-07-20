import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
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
  String _chosenValue = "전체";

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
                              "경비",
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
                                    DropdownButton<String>(
                                      value: _chosenValue,
                                      focusColor: Colors.white,
                                      style: getNotoSantMedium(fontSize: 12, color: textColor),
                                      items: <String>[
                                        '전체',
                                        '1개월',
                                        '3개월',
                                        '6개월',
                                        '12개월',
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value,style:TextStyle(color:Colors.black),),
                                          );
                                        }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          _chosenValue  = val!;
                                        });
                                      },
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

                                      expenseList.sort((a, b) => a.buyDate.compareTo(b.buyDate));
                                      List<ExpenseModel> waitingExpense = [];
                                      List<ExpenseModel> progressExpense = [];
                                      List<ExpenseModel> completeExpense = [];

                                      expenseList.map((e) {
                                        if(e.status == "미"){
                                          waitingExpense.add(e);
                                        } else if (e.status == "결"){
                                          progressExpense.add(e);
                                        } else {
                                          completeExpense.add(e);
                                        }
                                      }).toList();


                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Column(
                                              children: getExpenseData(context: context, expenseList: waitingExpense, expenseName: "미결재"),
                                            ),
                                            Column(
                                              children: getExpenseData(context: context, expenseList: waitingExpense, expenseName: "진행중"),
                                            ),
                                            Column(
                                              children: getExpenseData(context: context, expenseList: waitingExpense, expenseName: "입금완료"),
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

    /*for(ExpenseModel app in expenseList){
      list.add(

      );
    }*/

    list.add(SizedBox(height: 20.0.h,));

    return list;
  }
}
