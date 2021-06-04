import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/schedule/model/team_model.dart';
import 'package:mycompany/schedule/model/testcompany_model.dart';
import 'package:mycompany/schedule/view/schedule_colleague_view.dart';

class ScheduleInsertWidget {
  final BuildContext context;
  //final DateTime timeZone;

  final String workName;
  final TextEditingController titleController;
  final TextEditingController noteController;
  final TextEditingController locationController;
  final List<String> colleagueList;
  final ValueNotifier<DateTime> startDateTime;
  final ValueNotifier<DateTime> endDateTime;
  final ValueNotifier<bool> isAllDay;
  final List<TeamModel> teamList;
  final List<CompanyUserModel> employeeList;
  final List<CompanyUserModel> workColleagueChkList;
  final List<String> workTeamChkList;

  DateFormat _format = DateFormat();

  ScheduleInsertWidget({
    required this.context,
    required this.workName,
    required this.titleController,
    required this.noteController,
    required this.locationController,
    required this.colleagueList,
    required this.startDateTime,
    required this.endDateTime,
    required this.isAllDay,
    required this.teamList,
    required this.employeeList,
    required this.workColleagueChkList,
    required this.workTeamChkList,

  });

  scheduleNavigation() {
    switch (this.workName) {
      case "내근":
        break;
      case "외근":
        break;
      case "미팅":
        return setMeeting(context);
        break;
      case "재택":
        break;
      case "외출":
        break;
      case "연차":
        break;
      case "기타":
        break;
    }
  }

  Widget setMeeting(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getTitleWidget(),
          getDateTime(),
          getNote(),
          getColleague(),
        ],
      ),
    );
  }

  // 제목
  Widget getTitleWidget() {
    return Column(
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: "제목을 입력하세요",
            hintStyle: getNotoSantRegular(
              fontSize: 18.0,
              color: hintTextColor,
            ),
          ),
          style: getNotoSantRegular(
              fontSize: 18.0,
              color: textColor
          )
        ),
        SizedBox(
          height: 38.0.h,
        )
      ],
    );
  }

  // 시간
  Widget getDateTime() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 5.0.h, right: 12.0.w),
              child: SvgPicture.asset(
                'assets/icons/time.svg',
                width: 18.0.w,
                height: 18.0.h,
              ),
            ),
            InkWell(
                child: ValueListenableBuilder(
                  valueListenable: startDateTime,
                  child: null,
                  builder: (context, DateTime value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _format.getDate(date: value),
                          style: getRobotoRegular(
                            fontSize: 13.0,
                            color: textColor,
                          ),
                        ),
                        Text(
                          _format.getTime(date: value),
                          style: getRobotoBold(
                            fontSize: 21.0,
                            color: textColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                onTap: () async {
                  startDateTime.value = await ScheduleFunctionReprository().dateTimeSet(context: context, date: startDateTime.value);
                  isAllDay.value = false;
                }),
            Container(
              padding: EdgeInsets.only(top: 9.7.h, left: 20.2.w, right: 20.2.w),
              child: SvgPicture.asset(
                'assets/icons/arrow_right.svg',
                width: 11.55.w,
                height: 21.83.h,
              ),
            ),
            InkWell(
                child: ValueListenableBuilder(
                  valueListenable: endDateTime,
                  child: null,
                  builder: (context, DateTime value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _format.getDate(date: endDateTime.value),
                          style: getRobotoRegular(
                            fontSize: 13.0,
                            color: textColor,
                          ),
                        ),
                        Text(
                          _format.getTime(date: endDateTime.value),
                          style: getRobotoBold(
                            fontSize: 21.0,
                            color: textColor,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                onTap: () async {
                  endDateTime.value = await ScheduleFunctionReprository().dateTimeSet(context: context, date: endDateTime.value);
                  isAllDay.value = false;
                }),
          ],
        ),
        SizedBox(
          height: 10.0.h,
        ),
        ValueListenableBuilder(
          valueListenable: isAllDay,
          builder: (context, bool value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "all_day".tr(),
                  style: getNotoSantRegular(
                      fontSize: 14.0,
                      color: isAllDay.value ? workInsertColor : hintTextColor
                  ),
                ),
                SizedBox(
                  width: 5.0.w,
                ),
                FlutterSwitch(
                  width: 30.0.w,
                  height: 15.0.h,
                  toggleSize: 16.0.w,
                  padding: 0,
                  value: value,
                  onToggle: (values){
                    isAllDay.value = values;
                    if(values){
                      startDateTime.value = DateTime(startDateTime.value.year, startDateTime.value.month, startDateTime.value.day, 9, 00, 00);
                      endDateTime.value = DateTime(startDateTime.value.year, startDateTime.value.month, startDateTime.value.day, 18, 00, 00);
                    }
                  },
                ),
              ],
            );
          },
        ),
        SizedBox(
          height: 11.0.h,
        )
      ],
    );
  }

  Widget getNote() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0.h, right: 8.0.w),
              child: SvgPicture.asset(
                'assets/icons/note.svg',
                width: 24.0.w,
                height: 24.0.h,
              ),
            ),
            Expanded(
              child: TextFormField(
                  controller: noteController,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "세부 내용",
                    hintStyle: getNotoSantRegular(
                      fontSize: 14.0,
                      color: hintTextColor,
                    ),
                  ),
                  style: getNotoSantRegular(
                      fontSize: 14.0,
                      color: textColor
                  )
              ),
            ),
          ],
        ),
        SizedBox(
          height: 31.0.h,
        )
      ],
    );
  }

  Widget getColleague() {
    return Container(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5.0.h, right: 8.0.w),
            child: SvgPicture.asset(
              'assets/icons/colleague.svg',
              width: 24.0.w,
              height: 24.0.h,
            ),
          ),
          GestureDetector(
            child: Container(
              width: double.infinity,
              child: GridView.count(
                crossAxisCount: 4,
                children: workColleagueChkList.map((user) =>
                  Container(
                    width: 57.0.w,
                    height: 20.0.h,
                    child: Text(user.name),
                  )
                ).toList(),
              )
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ScheduleColleagueView(
                  employeeList: employeeList,
                  teamList: teamList,
                  workColleagueChkList: workColleagueChkList,
                  workTeamChkList: workTeamChkList,
                )))
          ),
        ],
      ),
    );
  }
}
/*
Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot, User user, isChk) {
  return CustomScrollView(
    slivers: [
      SliverList(
        delegate: SliverChildBuilderDelegate(
                (context, index) => _buildListItem(context, snapshot[index], user, isChk),
            childCount: snapshot.length),
      ),
    ],
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data, UserModel user, isChk) {
  final companyUser = CompanyUser.fromSnapshow(data);
  if(companyUser.mail != user.email) {
    return Container(
      padding: cardPadding,
      height: 5.0.h,
      child: _buildUserList(context, companyUser, user.companyCode, isChk),
    );
  } else {
    return Container();
  }
}

Map<dynamic,dynamic> chkUser = Map();


Widget _buildUserList(BuildContext context, CompanyUser user, String companyCode, isChk) {
  isChk = chkUser.containsKey(user.mail);
  return StatefulBuilder(
    builder: (context, setState) {
      return InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: isChk,
              onChanged: (val){
                setState((){
                  isChk = val;
                  if(isChk) {
                    chkUser[user.mail] = user.name;
                  } else {
                    chkUser.remove(user.mail);
                  }
                });
              },
            ),
            CircleAvatar(
              backgroundColor: whiteColor,
              radius: SizerUtil.deviceType == DeviceType.Tablet ? 4.5.w : 6.0.w,
              backgroundImage: NetworkImage(user.profilePhoto),
            ),
            Text(
              user.team,
              style: defaultRegularStyleGray,
            ),
            cardSpace,
            Text(
              user.name,
              style: defaultRegularStyle,
            ),
            cardSpace,
            Text(
              user.position,
              style: defaultRegularStyleGray,
            ),
          ],
        ),
        onTap: () {
          setState((){
            isChk = !isChk;
            if(isChk) {
              chkUser[user.mail] = user.name;
            } else {
              chkUser.remove(user.mail);
            }
          });
        },
      );
    },
  );
}*/
