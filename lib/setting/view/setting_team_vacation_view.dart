import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/function/vacation/vacation.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
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
    CompanyModel company = await PublicFirebaseRepository().getVacation(companyCode: widget.loginUser.companyCode!);
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
              height: 98.0.h,
              padding: EdgeInsets.only(
                right: 27.5.w,
                left: 27.5.w,
                top: 33.0.h,
              ),
              decoration: BoxDecoration(
                  color: Colors.white, boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.16), blurRadius: 3.0.h, offset: Offset(0.0, 1.0))]),
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
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    SizedBox(
                      width: 14.7.w,
                    ),
                    Text(
                      widget.teamName + " " + "annual".tr(),
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

                      return FutureBuilder(
                          future: UsedVacation(empModel.companyCode, empModel.mail, empModel.enteredDate!, companyVacation),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return Container();
                            }
                            double useVacation = (snapshot.data as double);
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
                                          width: 90.0.w,
                                          child: Text(
                                            empModel.position! + " / " + empModel.team!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                          ),
                                        ),
                                        Container(
                                          width: 90.0.w,
                                          child: Text(
                                            empModel.enteredDate != "" ? empModel.enteredDate! + " ??????" : "????????? ?????????",
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
                                          width: 110.0.w,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  children: [
                                                    Text("vacation_content_1".tr() +  " ",
                                                      style: getNotoSantBold(fontSize: 11.0, color: textColor),
                                                    ),
                                                    Text("${totalVacation.toString()}",
                                                      style: getNotoSantRegular(fontSize: 11.0, color: textColor),
                                                    ),
                                                  ]
                                              ),
                                              Row(
                                                  children: [
                                                    Text("vacation_content_2".tr() +  " ",
                                                      style: getNotoSantBold(fontSize: 11.0, color: textColor),
                                                    ),
                                                    Text("${useVacation.toString()}",
                                                      style: getNotoSantRegular(fontSize: 11.0, color: textColor),
                                                    ),
                                                  ]
                                              ),
                                              Row(
                                                  children: [
                                                    Text("vacation_content_3".tr() +  " ",
                                                      style: getNotoSantBold(fontSize: 11.0, color: textColor),
                                                    ),
                                                    Text("${(totalVacation - useVacation)}",
                                                      style: getNotoSantRegular(fontSize: 11.0, color: textColor),
                                                    ),
                                                  ]
                                              ),
                                              Row(
                                                  children: [
                                                    Text("vacation_content_4".tr() +  " ",
                                                      style: getNotoSantBold(fontSize: 11.0, color: textColor),
                                                    ),
                                                    Text("${(empModel.vacation)}",
                                                      style: getNotoSantRegular(fontSize: 11.0, color: textColor),
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
                        }
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
