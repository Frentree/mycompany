
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/public/model/team_model.dart';

import 'package:mycompany/public/style/text_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:easy_localization/easy_localization.dart';

class ScheduleColleagueApprovalView extends StatefulWidget {

  Key? key;
  final List<TeamModel> teamList;
  final List<EmployeeModel> employeeList;
  ValueNotifier<EmployeeModel> approvalUser;

  ScheduleColleagueApprovalView({key, required this.teamList, required this.employeeList, required this.approvalUser});

  @override
  _ScheduleColleagueApprovalViewState createState() => _ScheduleColleagueApprovalViewState();
}

class _ScheduleColleagueApprovalViewState extends State<ScheduleColleagueApprovalView> {

  late List<TeamModel> teamList = widget.teamList;
  late List<EmployeeModel> employeeList = widget.employeeList;

  late EmployeeModel approvalUsers = widget.approvalUser.value;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context,false);
        return true;
      },
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
                        onPressed: () => Navigator.pop(context,true),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                        color: Color(0xff2093F0),
                      ),
                      SizedBox(
                        width: 14.7.w,
                      ),
                      Text(
                        "approver_choise".tr(),
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
              Expanded(
                child: ListView.builder(
                  itemCount: widget.teamList.length + 1,
                  itemBuilder: (context, index) {
                    List<EmployeeModel> list = [];

                    employeeList.map((data) {
                      if(index != teamList.length){
                        if(data.team == teamList[index].teamName){
                          list.add(data);
                        }
                      } else {
                        if(data.team == "" || data.team == null){
                          list.add(data);
                        }

                      }
                    }).toList();

                    if(list.length == 0) {
                      return Container();
                    }

                    if(teamList.length == 0 || index >= teamList.length){
                      return getTeam(
                          index: index,
                          list: list,
                          teamName: "other_team".tr(),
                      );
                    }
                    return getTeam(
                      index: index,
                      list: list,
                      teamName: teamList[index].teamName.toString(),
                    );
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 57.0.h,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: calendarLineColor.withOpacity(0.1),
                        child: InkWell(
                          child: Center(
                            child: Text(
                              "cencel".tr(),
                              style: getNotoSantMedium(fontSize: 15.0, color: textColor),
                            ),
                          ),
                          onTap: () => Navigator.pop(context, true),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: workInsertColor,
                        child: InkWell(
                          child: Center(
                            child: Text(
                              "chose".tr(),
                              style: getNotoSantMedium(fontSize: 15.0, color: whiteColor),
                            ),
                          ),
                          onTap: () {
                            widget.approvalUser.value = approvalUsers;
                            Navigator.pop(context, true);
                          },
                        ),
                      ),
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


  Widget getTeam({required int index,required List<EmployeeModel> list, required String teamName}) {

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 35.0.h,
          padding: EdgeInsets.only(left: 23.0.w, right: 26.0.w),
          color: calendarLineColor.withOpacity(0.1),
          child: InkWell(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: SvgPicture.asset(
                        'assets/icons/colleague.svg',
                        width: 20.0.w,
                        height: 20.0.h,
                        color: workInsertColor,
                      ),
                    ),
                    SizedBox(width: 4.0.w,),
                    Text(
                      teamName,
                      style: getNotoSantBold(fontSize: 14.0.sp, color: textColor),
                    )
                  ],
                ),
              ],
            ),
            onTap: () {
              setState(() {
              });
            },
          ),
        ),
        Container(
          height: list.length * 48.0.h,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                child: Container(
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
                                          child: list[index].profilePhoto != '' ?
                                          FadeInImage.assetNetwork(
                                            placeholder: 'assets/images/logo_blue.png',
                                            image: list[index].profilePhoto.toString(),
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
                              Text(list[index].name,
                                style: getNotoSantBold(fontSize: 14.0, color: textColor),
                              ),
                              Text(list[index].position!,
                                style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                          child: Container(
                            width: 18.0.w,
                            height: 18.0.h,
                            decoration: BoxDecoration(
                              border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                              shape: BoxShape.circle,
                              color:  approvalUsers == list[index] ? workInsertColor : whiteColor,
                            ),
                            child: Center(
                                child: Icon(
                                  Icons.check,
                                  size: 16.0.w,
                                  color: whiteColor,
                                )
                            ),
                          ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  approvalUsers = list[index];
                  setState(() {
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

}
