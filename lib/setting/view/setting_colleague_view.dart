import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/setting/view/setting_team_colleague_view.dart';
import 'package:mycompany/setting/widget/setting_dialog.dart';

class SettingColleagueView extends StatefulWidget {
  @override
  _SettingColleagueViewState createState() => _SettingColleagueViewState();
}

class _SettingColleagueViewState extends State<SettingColleagueView> {

  late UserModel loginUser;

  DateFormatCustom _format = DateFormatCustom();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
    _getSetting();
  }

  _getSetting() async {
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                        "setting_menu_2".tr(),
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
                        "all_employee".tr(),
                        style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "team_employee".tr(),
                        style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: PublicFirebaseRepository().getCompanyUsers(loginUser: loginUser),
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
                                              empModel.enteredDate != "" ? empModel.enteredDate! + " 입사" : "입사일 미설정",
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
                                            width: 170.0.w,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                    children: [
                                                      Text("phone".tr() +  " ",
                                                        style: getNotoSantBold(fontSize: 11.0, color: textColor),
                                                      ),
                                                      Text("${empModel.phone}",
                                                        style: getNotoSantRegular(fontSize: 11.0, color: textColor),
                                                      ),
                                                    ]
                                                ),
                                                Row(
                                                    children: [
                                                      Text("email".tr() +  " ",
                                                        style: getNotoSantBold(fontSize: 11.0, color: textColor),
                                                      ),
                                                      Container(
                                                        width: 130.0.w,
                                                        child: Text("${empModel.mail}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: getNotoSantRegular(fontSize: 11.0, color: textColor),
                                                        ),
                                                      ),
                                                    ]
                                                ),
                                                Row(
                                                    children: [
                                                      Text("birthday".tr() +  " ",
                                                        style: getNotoSantBold(fontSize: 11.0, color: textColor),
                                                      ),
                                                      Text("${empModel.birthday}",
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
                                                  "colleague_dialog_menu".tr(),
                                                  style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                                ),
                                              ),
                                              PopupMenuItem(
                                                value: 2,
                                                child: Text(
                                                  "퇴사 처리",
                                                  style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                                                ),
                                              ),
                                            ],
                                            onSelected: (value) async {
                                              if(value== 1){
                                                colleagueUpdateDialog(context, empModel);
                                              }

                                              setState(() {});
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
                    StreamBuilder<QuerySnapshot>(
                      stream: ScheduleFirebaseReository().getTeamStream(companyCode: loginUser.companyCode!),
                      builder: (context, snapshot) {
                        if(!snapshot.hasData){
                          return Container();
                        }
                        List<DocumentSnapshot> docs = snapshot.data!.docs;

                        docs.sort((a, b) => a.get("teamName").compareTo(b.get("teamName")));

                        return ListView.builder(
                          itemCount: docs.length + 1,
                          itemBuilder: (context, index) {
                            late TeamModel teamModel;
                            if(index < docs.length){
                              teamModel = TeamModel.fromMap(mapData: (docs[index].data() as dynamic), reference: docs[index].reference);
                            } else {
                              teamModel = TeamModel(teamName: "other".tr());
                            }

                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 5.0.h),
                                child: Card(
                                  elevation: 5.0,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5.0.h, horizontal: 10.0.w),
                                    width: double.infinity,
                                    height: 50.0.h,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              teamModel.teamName != "other".tr() ? teamModel.teamName : "other".tr() + "unassigned_teams".tr(),
                                              style: getNotoSantBold(fontSize: 15.0, color: textColor),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SvgPicture.asset(
                                            'assets/icons/arrow_right.svg',
                                            width: 15.8.w,
                                            height: 15.76.h,
                                            color: blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (cotext) => SettingTeamColleagueView(teamName: teamModel.teamName, loginUser: loginUser)));
                              },
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
