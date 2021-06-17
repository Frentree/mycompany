import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/function/calender_function.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class ScheduleDetailView extends StatefulWidget {
  final Appointment appointment;

  ScheduleDetailView({required this.appointment});

  @override
  _ScheduleDetailViewState createState() => _ScheduleDetailViewState();
}

class _ScheduleDetailViewState extends State<ScheduleDetailView> {
  DateFormatCustom _formatCustom = DateFormatCustom();
  PublicFunctionRepository _publicFunctionReprository = PublicFunctionRepository();
  bool isArrowChk = false;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    print(widget.appointment.content);

    return Scaffold(
      body: Container(
        color: whiteColor,
        padding: EdgeInsets.only(top: statusBarHeight),
        child: Column(
          children: [
            Container(
              height: 52.0.h,
              width: double.infinity,
              padding: EdgeInsets.only(left: 18.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      width: 30.0.w,
                      height: 30.0.h,
                      color: whiteColor.withOpacity(0.0),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/arrow_left.svg',
                          width: 15.8.w,
                          height: 15.76.h,
                          color: blackColor,
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pop(context),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.appointment.subject.toString(),
                          style: getNotoSantBold(fontSize: 14.0, color: textColor),
                        ),
                        Text(
                          widget.appointment.position.toString() + " / " +  widget.appointment.team.toString(),
                          style: getNotoSantMedium(fontSize: 10.0, color: textColor),
                        )
                      ],
                    ),
                  ),
                  PopupMenuButton<int>(
                    padding: EdgeInsets.all(0),
                    icon: SvgPicture.asset(
                      'assets/icons/vertical_menu.svg',
                      width: 15.8.w,
                      height: 15.76.h,
                      color: blackColor,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Text(
                          "update".tr(),
                          style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Text(
                          "delete".tr(),
                          style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                        ),
                      ),
                    ],
                    onSelected: (value) async {
                      var result = -1;
                      switch(value) {
                        case 1:   //수정
                          break;
                        case 2:   //삭제
                          result = await CalenderFunction().deleteSchedule(companyCode: "0S9YLBX", documentId: widget.appointment.documentId.toString());
                          break;
                      }
                      print(result);
                      switch(result) {
                        case 0: // 삭제 및 수정 성공
                          _publicFunctionReprository.onScheduleBackPressed(context: context);
                          break;
                        case 404: // 결재 중인 항목이 있어서 삭제 실패
                          break;
                        case 405: // 스케줄 등록 실패
                          break;
                        case 406: // 수정 실패 오류
                          break;
                      }

                    },
                  ),
                ],
              ),
            ),
            Card(
              child: Container(
                width: double.infinity,
                height: isArrowChk? null : 100.0.h ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _formatCustom.getDate(date:  widget.appointment.startTime),
                          style: getRobotoBold(fontSize: 12.0, color: textColor),
                        ),
                        Text(
                          " - " + _formatCustom.getDate(date:  widget.appointment.endTime),
                          style: getRobotoBold(fontSize: 12.0, color: hintTextColor),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0.h,),
                    Text(
                      widget.appointment.title.toString(),
                      style: getNotoSantBold(fontSize: 18.0, color: textColor),
                    ),
                    SizedBox(height: 10.0.h,),
                    Visibility(
                      visible: isArrowChk,
                      child: Column(
                        children: [
                          Text(
                            widget.appointment.content.toString(),
                            style: getNotoSantRegular(fontSize: 14.0, color: textColor),
                          ),
                          SizedBox(height: 10.0.h,),
                        ],
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        width: 30.0.w,
                        height: 30.0.h,
                        color: whiteColor.withOpacity(0.0),
                        child: Center(
                          child: SvgPicture.asset(
                            isArrowChk ? 'assets/icons/arrow_up.svg' : 'assets/icons/arrow_down.svg',
                            width: 20.8.w,
                            height: 19.76.h,
                            color: blackColor,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isArrowChk = !isArrowChk;
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
