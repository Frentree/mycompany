import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/testcompany_model.dart';

import 'package:mycompany/public/style/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

class ScheduleColleagueView extends StatefulWidget {

  Key? key;
  final List<TeamModel> teamList;
  final List<CompanyUserModel> employeeList;

  ScheduleColleagueView({key, required this.teamList, required this.employeeList});

  @override
  _ScheduleColleagueViewState createState() => _ScheduleColleagueViewState();
}

class _ScheduleColleagueViewState extends State<ScheduleColleagueView> {

  late List<TeamModel> teamList = widget.teamList;
  late List<CompanyUserModel> employeeList = widget.employeeList;

  @override
  void initState() {
    super.initState();
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
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                          "Invite_colleague".tr(),
                          style: getNotoSantRegular(
                              fontSize: 18.0,
                              color: textColor
                          )
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Container(
                      width: 50.0.w,
                      height: 20.0.h,
                      alignment: Alignment.centerRight,
                      color: whiteColor.withOpacity(0),
                      padding: EdgeInsets.only(right: 27.0.w),
                      child: SvgPicture.asset(
                        'assets/icons/check.svg',
                        width: 16.51.w,
                        height: 11.37.h,
                        color: workInsertColor,
                      ),
                    ),
                    onTap: () {
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: super.widget.teamList.length + 1,
                itemBuilder: (context, index) {
                  List<CompanyUserModel> list = [];

                  employeeList.map((data) {
                    if(index != teamList.length){
                      if(data.team == teamList[index].teamName)
                        list.add(data);
                    } else {
                      if(data.team == "" || data.team == null)
                        list.add(data);
                    }
                  }).toList();

                  if(list.length == 0) {
                    return Container();
                  }

                  if(teamList.length == 0 || index >= teamList.length){
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 35.0.h,
                          padding: EdgeInsets.only(left: 23.0.w, right: 26.0.w),
                          color: calendarLineColor.withOpacity(0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: SvgPicture.asset(
                                      'assets/icons/colleague.svg',
                                      width: 28.0.w,
                                      height: 28.0.h,
                                      color: workInsertColor,
                                    ),
                                  ),
                                  Text(
                                    "기타팀",
                                    style: getNotoSantMedium(fontSize: 16.0.sp, color: textColor),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text("팀선택",
                                    style: getNotoSantMedium(fontSize: 13.0, color: hintTextColor),
                                  ),
                                  SizedBox(width: 6.0.w,),
                                  RoundCheckBox(
                                    isChecked: true,
                                    checkedColor: workInsertColor,
                                    size: 18.0.h,
                                    checkedWidget: Container(
                                      child: Center(
                                        child: SvgPicture.asset(
                                          'assets/icons/check.svg',
                                          color: whiteColor,
                                          width: 8.57.w,
                                          height: 6.43.h,
                                        ),
                                      ),
                                    ),
                                    onTap: (value) {

                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: list.length * 48.0.h,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return getColleague(list[index]);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  
                  
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 35.0.h,
                        padding: EdgeInsets.only(left: 23.0.w, right: 26.0.w),
                        color: calendarLineColor.withOpacity(0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  child: SvgPicture.asset(
                                    'assets/icons/colleague.svg',
                                    width: 28.0.w,
                                    height: 28.0.h,
                                    color: workInsertColor,
                                  ),
                                ),
                                Text(
                                  teamList[index].teamName.toString(),
                                  style: getNotoSantMedium(fontSize: 16.0.sp, color: textColor),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text("팀선택",
                                  style: getNotoSantMedium(fontSize: 13.0, color: hintTextColor),
                                ),
                                SizedBox(width: 6.0.w,),
                                RoundCheckBox(
                                  isChecked: true,
                                  checkedColor: workInsertColor,
                                  size: 18.0.h,
                                  checkedWidget: Container(
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/check.svg',
                                        color: whiteColor,
                                        width: 8.57.w,
                                        height: 6.43.h,
                                      ),
                                    ),
                                  ),
                                  onTap: (value) {

                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        height: list.length * 48.0.h,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return getColleague(list[index]);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getColleague(CompanyUserModel user) {
    return Container(
      width: double.infinity,
      height: 48.0.h,
      padding: EdgeInsets.symmetric(horizontal: 26.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 36.5.w,
                  height: 36.5.h,
                  color: hintTextColor,
                  child: Center(
                    child: ClipOval(
                      child: Container(
                        width: 36.5.w,
                        height: 36.5.h,
                        color: whiteColor,
                        child: Center(
                          child: ClipOval(
                            child: SizedBox(
                              width: 36.0.w,
                              height: 36.0.h,
                              child: user.profilePhoto != '' ?
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/images/logo_blue.png',
                                image: user.profilePhoto.toString(),
                                height: 36.0.h,
                              ): SvgPicture.asset(
                                'assets/icons/personal.svg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6.0.w,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                    style: getNotoSantBold(fontSize: 14.0, color: textColor),
                  ),
                  Text(user.position!,
                    style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                  ),
                ],
              ),
            ],
          ),
          RoundCheckBox(
            isChecked: true,
            checkedColor: workInsertColor,
            size: 18.0.h,
            checkedWidget: Container(
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/check.svg',
                  color: whiteColor,
                  width: 8.57.w,
                  height: 6.43.h,
                ),
              ),
            ),
            onTap: (value) {

            },
          )
        ],
      ),
    );
  }

}
