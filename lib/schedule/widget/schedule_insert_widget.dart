import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:easy_localization/easy_localization.dart';

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
          Container(
            child: Text("gdgd")
          ),
        ],
      ),
    );
  }
}
