import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/db/public_firestore_repository.dart';
import 'package:mycompany/public/function/public_firebase_repository.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/function/vacation/vacation.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/setting/widget/setting_dialog.dart';

class SettingTeamVacationView extends StatefulWidget {
  final teamName;
  final UserModel loginUser;

  SettingTeamVacationView({required this.teamName, required this.loginUser});

  @override
  _SettingTeamVacationViewState createState() => _SettingTeamVacationViewState();
}

class _SettingTeamVacationViewState extends State<SettingTeamVacationView> {

  bool companyVacation = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSetting();
  }

  _getSetting() async {
    CompanyModel company = await PublicFirebaseReository().getVacation(widget.loginUser.companyCode!);
    companyVacation = company.vacation!;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Container(
                          color: whiteColor.withOpacity(0),
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
                        onTap: () => Navigator.pop(context),
                      ),
                      Text(
                          widget.teamName + " " + "annual".tr(),
                          style: getNotoSantRegular(
                              fontSize: 18.0,
                              color: textColor
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: PublicFirebaseRepository().getCompanyTeamUsers(loginUser: widget.loginUser, teamName: widget.teamName != "other".tr() ? widget.teamName : ""),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container();
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;

                  docs.sort((a, b) => a.get("name").compareTo(b.get("name")));

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      EmployeeModel empModel = EmployeeModel.fromMap(mapData: (docs[index].data() as dynamic), reference: docs[index].reference);
                      double? userVacation = empModel.vacation?.toDouble();
                      double? totalVacation = TotalVacation(empModel.enteredDate!, companyVacation, userVacation ?? 0);
                      double? useVacation = UsedVacation(empModel.companyCode, empModel.mail, empModel.enteredDate!, companyVacation);

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 5.0.h),
                        child: Card(
                          elevation: 5.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 10.0.w),
                            width: double.infinity,
                            height: 90.0.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      empModel.name,
                                      style: getNotoSantBold(fontSize: 12.0, color: textColor),
                                    ),
                                    Container(
                                      width: 100.0.w,
                                      child: Text(
                                        empModel.position! + " / " + empModel.team!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                      ),
                                    ),
                                    Container(
                                      width: 100.0.w,
                                      child: Text(
                                        empModel.enteredDate! + " 입사",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 120.0.w,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                              children: [
                                                Text("vacation_content_1".tr() +  " : ",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                                Text("${totalVacation.toString()}",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                              ]
                                          ),
                                          Row(
                                              children: [
                                                Text("vacation_content_2".tr() +  " : ",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                                Text("${useVacation.toString()}",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                              ]
                                          ),
                                          Row(
                                              children: [
                                                Text("vacation_content_3".tr() +  " : ",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                                Text("${(totalVacation - useVacation)}",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                              ]
                                          ),
                                          Row(
                                              children: [
                                                Text("vacation_content_4".tr() +  " : ",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                                Text("${(empModel.vacation)}",
                                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                                ),
                                              ]
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<int>(
                                      padding: EdgeInsets.all(0),
                                      icon: SvgPicture.asset(
                                        'assets/icons/arrow_right.svg',
                                        width: 15.8.w,
                                        height: 15.76.h,
                                        color: blackColor,
                                      ),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Text(
                                            "vacation_dialog_1".tr(),
                                            style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                          ),
                                        ),
                                        /*PopupMenuItem(
                                          value: 2,
                                          child: Text(
                                            "vacation_dialog_2".tr(),
                                            style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                          ),
                                        ),*/
                                      ],
                                      onSelected: (value) async {
                                        if(value== 1){
                                          addAnnualUpdateDialog(context, empModel);
                                        }else {
                                          enteredDateUpdateDialog(context, empModel);
                                        }
                                        setState(() {
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}