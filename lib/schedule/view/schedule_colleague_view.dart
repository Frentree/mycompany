
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';

class ScheduleColleagueView extends StatefulWidget {

  Key? key;
  final List<TeamModel> teamList;
  final List<EmployeeModel> employeeList;
  final List<EmployeeModel> workColleagueChkList;
  final List<String> workTeamChkList;

  ScheduleColleagueView({key, required this.teamList, required this.employeeList, required this.workColleagueChkList, required this.workTeamChkList});

  @override
  _ScheduleColleagueViewState createState() => _ScheduleColleagueViewState();
}

class _ScheduleColleagueViewState extends State<ScheduleColleagueView> {

  late List<TeamModel> teamList = widget.teamList;
  late List<EmployeeModel> employeeList = widget.employeeList;

  late List<EmployeeModel> workColleague = List.from(widget.workColleagueChkList);
  late List<String> workTeam = List.from(widget.workTeamChkList);

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
                          onTap: () => Navigator.pop(context,true),
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
                    /*GestureDetector(
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
                    ),*/
                  ],
                ),
              ),

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
                          onTap: () => Navigator.pop(context,true),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: workInsertColor,
                        child: InkWell(
                          child: Center(
                            child: Text(
                              "invite".tr(),
                              style: getNotoSantMedium(fontSize: 15.0, color: whiteColor),
                            ),
                          ),
                          onTap: () {
                            widget.workColleagueChkList.clear();
                            widget.workTeamChkList.clear();

                            workColleague.map((data) {
                              if(!widget.workColleagueChkList.contains(data))
                                widget.workColleagueChkList.add(data);
                            }).toList();
                            workTeam.map((data) {
                              if(!widget.workTeamChkList.contains(data))
                                widget.workTeamChkList.add(data);
                            }).toList();

                            Navigator.pop(context,true);
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
                Row(
                  children: [
                    GestureDetector(
                      child: Text(workTeam.contains(teamName) ? "deselect".tr() : "team_selection".tr(),
                        style: getNotoSantMedium(fontSize: 13.0, color: workTeam.contains(teamName) ? workInsertColor : hintTextColor),
                      ),
                      onTap: () {
                        if(!workTeam.contains(teamName)){
                          workTeam.add(teamName);
                            list.map((user) {
                              if(!workColleague.contains(user)) workColleague.add(user);
                            }).toList();
                        } else {
                          workTeam.remove(teamName);
                          list.map((user) => workColleague.remove(user)).toList();
                        }
                        setState(() {
                        });
                      },
                    ),
                    SizedBox(width: 6.0.w,),
                    Center(
                        child: Container(
                          width: 18.0.w,
                          height: 18.0.h,
                          decoration: BoxDecoration(
                            border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                            shape: BoxShape.circle,
                            color: workTeam.contains(teamName) ? workInsertColor : whiteColor,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              size: 16.0.w,
                              color: whiteColor,
                            )
                          ),
                        )
                    ),
                  ],
                )
              ],
            ),
            onTap: () {
              if(!workTeam.contains(teamName)){
                workTeam.add(teamName);
                list.map((user) {
                  if(!workColleague.contains(user)) workColleague.add(user);
                }).toList();
              } else {
                workTeam.remove(teamName);
                list.map((user) => workColleague.remove(user)).toList();
              }
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
                              color: workColleague.contains(list[index]) ? workInsertColor : whiteColor,
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
                  workTeam.remove(teamName);
                  if(!workColleague.contains(list[index])){
                    workColleague.add(list[index]);
                  } else {
                    workColleague.remove(list[index]);
                  }
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
