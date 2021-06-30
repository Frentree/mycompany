import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/schedule/model/company_user_model.dart';
import 'package:mycompany/schedule/view/schedule_approval_view.dart';
import 'package:mycompany/schedule/view/schedule_colleague_view.dart';
import 'package:mycompany/schedule/widget/schedule_dialog_widget.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';

class ScheduleInsertWidget extends StatefulWidget {
  //final DateTime timeZone;
  Key? key;
  final String workName;
  final TextEditingController titleController;
  final TextEditingController noteController;
  final TextEditingController locationController;
  final ValueNotifier<DateTime> startDateTime;
  final ValueNotifier<DateTime> endDateTime;
  final ValueNotifier<bool> isAllDay;
  final ValueNotifier<bool> isHalfway;
  final List<TeamModel> teamList;
  final List<EmployeeModel> employeeList;
  final List<EmployeeModel> workColleagueChkList;
  final List<String> workTeamChkList;
  final ValueNotifier<EmployeeModel> approvalUser;

  ScheduleInsertWidget({
    required this.workName,
    required this.titleController,
    required this.noteController,
    required this.locationController,
    required this.startDateTime,
    required this.endDateTime,
    required this.isAllDay,
    required this.isHalfway,
    required this.teamList,
    required this.employeeList,
    required this.workColleagueChkList,
    required this.workTeamChkList,
    required this.approvalUser,
  });


  @override
  _ScheduleInsertWidgetState createState() => _ScheduleInsertWidgetState();
}

class _ScheduleInsertWidgetState extends State<ScheduleInsertWidget> {
  DateFormatCustom _format = DateFormatCustom();

  scheduleNavigation() {
    switch (widget.workName) {
      case "내근":
        return setInWork(context);
      case "외근":
        return setOutWork(context);
      case "요청":
        return setRequest(context);
      case "미팅":
        return setMeeting(context);
      case "재택":
        return setHomeWork(context);
      case "외출":
        break;
      case "연차" : case "Annual":
        return setAnnual(context);
      case "기타":
        return setOhter(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return scheduleNavigation();
  }

  Widget setInWork(BuildContext context) {
    widget.locationController.text = "";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getTitleWidget(),
          getDateTime(),
          getNote(),
          getColleague()
        ],
      ),
    );
  }

  Widget setOutWork(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getTitleWidget(),
          getDateTime(),
          getLocation(),
          getNote(),
          getColleague(),
          getApproval()
        ],
      ),
    );
  }

  Widget setRequest(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getTitleWidget(),
          getDateTime(),
          getLocation(),
          getNote(),
          getApproval()
        ],
      ),
    );
  }

  Widget setHomeWork(BuildContext context) {
    widget.workColleagueChkList.clear();
    widget.workTeamChkList.clear();
    widget.locationController.text = "";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getTitleWidget(),
          getDateTime(),
          getNote(),
          getApproval()
        ],
      ),
    );
  }

  Widget setAnnual(BuildContext context) {
    widget.workColleagueChkList.clear();
    widget.workTeamChkList.clear();
    widget.locationController.text = "";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getAnnual(),
          getNote(),
          getApproval()
        ],
      ),
    );
  }

  Widget setMeeting(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getTitleWidget(),
          getDateTime(),
          getLocation(),
          getNote(),
          getColleague()
        ],
      ),
    );
  }

  Widget setOhter(BuildContext context) {
    widget.locationController.text = "";
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24.0.w),
      child: Column(
        children: [
          getTitleWidget(),
          getDateTime(),
          getLocation(),
          getNote(),
          getColleague(),
          getApproval()
        ],
      ),
    );
  }

  // 제목
  Widget getTitleWidget() {
    return Column(
      children: [
        TextFormField(
            controller: widget.titleController,
            decoration: InputDecoration(
              hintText: "title_input".tr(),
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
                  valueListenable: widget.startDateTime,
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
                  widget.startDateTime.value = await ScheduleFunctionReprository().dateTimeSet(context: context, date: widget.startDateTime.value);
                  widget.isAllDay.value = false;
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
                  valueListenable: widget.endDateTime,
                  child: null,
                  builder: (context, DateTime value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _format.getDate(date: widget.endDateTime.value),
                          style: getRobotoRegular(
                            fontSize: 13.0,
                            color: textColor,
                          ),
                        ),
                        Text(
                          _format.getTime(date: widget.endDateTime.value),
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
                  widget.endDateTime.value = await ScheduleFunctionReprository().dateTimeSet(context: context, date: widget.endDateTime.value);
                  widget.isAllDay.value = false;
                }),
          ],
        ),
        SizedBox(
          height: 10.0.h,
        ),
        ValueListenableBuilder(
          valueListenable: widget.isAllDay,
          builder: (context, bool value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "all_day".tr(),
                  style: getNotoSantRegular(
                      fontSize: 14.0,
                      color: widget.isAllDay.value ? workInsertColor : hintTextColor
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
                    widget.isAllDay.value = values;
                    if(values){
                      widget.startDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 9, 00, 00);
                      widget.endDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 18, 00, 00);
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

  // 시간
  Widget getAnnual() {
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
                  valueListenable: widget.startDateTime,
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
                  widget.startDateTime.value = await showDatesPicker(context: context, date: widget.startDateTime.value);
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
                  valueListenable: widget.endDateTime,
                  child: null,
                  builder: (context, DateTime value, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _format.getDate(date: widget.endDateTime.value),
                          style: getRobotoRegular(
                            fontSize: 13.0,
                            color: textColor,
                          ),
                        ),
                        Text(
                          _format.getTime(date: widget.endDateTime.value),
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
                  widget.endDateTime.value = await showDatesPicker(context: context, date: widget.endDateTime.value);
                }),
          ],
        ),
        SizedBox(
          height: 10.0.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ValueListenableBuilder(
              valueListenable: widget.isAllDay,
              builder: (context, bool value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value? "halfway".tr() : "annual".tr(),
                      style: getNotoSantRegular(
                          fontSize: 14.0,
                          color: widget.isAllDay.value ? workInsertColor : hintTextColor
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
                        widget.isAllDay.value = values;

                        if(!values){
                          widget.isHalfway.value = false;

                          widget.startDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 9);
                          widget.endDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 18);
                        } else {
                          widget.startDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 9);
                          widget.endDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 12);
                        }
                      },
                    ),
                    SizedBox(
                      width: 10.0.w,
                    ),
                  ],
                );
              },
            ),
            ValueListenableBuilder(
              valueListenable: widget.isHalfway,
              builder: (context, bool value, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value ? "pm".tr() : "am".tr(),
                      style: getNotoSantRegular(
                          fontSize: 14.0,
                          color: value ? workInsertColor : hintTextColor
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
                        widget.isHalfway.value = values;

                        if(!values){
                          widget.startDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 9);
                          widget.endDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 12);
                        } else {
                          widget.startDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 12);
                          widget.endDateTime.value = DateTime(widget.startDateTime.value.year, widget.startDateTime.value.month, widget.startDateTime.value.day, 18);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ],
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 8.0.w),
              child: SvgPicture.asset(
                'assets/icons/note.svg',
                width: 24.0.w,
                height: 24.0.h,
              ),
            ),
            Expanded(
              child: TextFormField(
                  controller: widget.noteController,
                  autofocus: false,
                  minLines: 1,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "details".tr(),
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
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(right: 8.0.w),
                child: SvgPicture.asset(
                  'assets/icons/colleague.svg',
                  width: 24.0.w,
                  height: 24.0.h,
                ),
              ),
              Expanded(
                child: GestureDetector(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                              width: double.infinity,
                              height: 48.0.h,
                              child: widget.workColleagueChkList.length == 0 ? Text("동료 초대",style: getNotoSantRegular(
                                fontSize: 14.0,
                                color: hintTextColor,
                              ),) : GridView(
                                scrollDirection: Axis.horizontal,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5.0,
                                    mainAxisExtent: 80.0.w
                                ),
                                children: widget.workColleagueChkList.map((user) =>
                                    Row(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              getProfileImage(ImageUri: user.profilePhoto,size: 14),
                                              SizedBox(width: 5.0.w,),
                                              Text(
                                                user.name,
                                                style: getNotoSantRegular(fontSize: 14.0, color: textColor),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                ).toList(),
                              )
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5.0.h),
                          child: SvgPicture.asset(
                            'assets/icons/arrow_right.svg',
                            width: 6.59.w,
                            height: 10.66.h,
                            color: calendarLineColor,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final value = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          ScheduleColleagueView(
                            employeeList: widget.employeeList,
                            teamList: widget.teamList,
                            workColleagueChkList: widget.workColleagueChkList,
                            workTeamChkList: widget.workTeamChkList,
                          ))
                      );
                      if(value){
                        setState(() { });
                      }
                    }
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 31.0.h,
        )
      ],
    );
  }

  Widget getLocation() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 10.0.h, right: 8.0.w),
              child: SvgPicture.asset(
                'assets/icons/location.svg',
                width: 22.0.w,
                height: 22.0.h,
              ),
            ),
            Expanded(
              child: TextFormField(
                  controller: widget.locationController,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "위치",
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

  Widget getApproval() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(right: 8.0.w),
              child: SvgPicture.asset(
                'assets/icons/icon_approval.svg',
                width: 19.0.w,
                height: 19.0.h,
                color: workInsertColor,
              ),
            ),
            Expanded(
              child: GestureDetector(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                            width: double.infinity,
                            child: widget.approvalUser.value.mail == "" ?
                            Text(
                              "결재자 선택",
                              style: getNotoSantRegular(
                                fontSize: 14.0,
                                color: hintTextColor,
                              ),
                            ) :
                            Row(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      getProfileImage(ImageUri: widget.approvalUser.value.profilePhoto,size: 14),
                                      SizedBox(width: 5.0.w,),
                                      Text(
                                        widget.approvalUser.value.name.toString(),
                                        style: getNotoSantRegular(fontSize: 14.0, color: textColor),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0.h),
                        child: SvgPicture.asset(
                          'assets/icons/arrow_right.svg',
                          width: 6.59.w,
                          height: 10.66.h,
                          color: calendarLineColor,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    var value = await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        ScheduleApprovalView(
                          employeeList: widget.employeeList,
                          teamList: widget.teamList,
                          approvalUser: widget.approvalUser,
                        ))
                    );

                    if(value){
                      setState(() {});
                    }

                  }
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
}
