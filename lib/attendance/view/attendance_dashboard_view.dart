import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/attendance/widget/attendance_bottom_sheet.dart';
import 'package:mycompany/attendance/widget/attendance_dialog_widget.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:provider/provider.dart';

class AttendanceDashboardView extends StatefulWidget {
  @override
  AttendanceDashboardViewState createState() => AttendanceDashboardViewState();
}

class AttendanceDashboardViewState extends State<AttendanceDashboardView> {
  DateFormatCustom dateFormatCustom = DateFormatCustom();

  double test = (3360/3120);

  @override
  Widget build(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
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
                    onPressed: () => backPage(context: context),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    color: Color(0xff2093F0),
                  ),
                  SizedBox(
                    width: 14.7.w,
                  ),
                  Text(
                    "근태 관리",
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

          Container(
            padding: EdgeInsets.only(
              right: 27.5.w,
              left: 27.5.w,
              top: 29.0.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateFormatCustom.todayStringFormat()+" 근무시간",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: textColor,
                      ),
                    ),
                    Text(
                      "4시간 20분",
                      style: TextStyle(
                        fontSize: 26.0.sp,
                        fontWeight: fontWeight['Bold'],
                        color: Color(0xff2093F0),
                      ),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () => viewWorkingStatusDialog(context: context),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "근무형태",
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            color: Color(0xff9C9C9C),
                          ),
                        ),
                        Text(
                          "내근",
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            fontWeight: fontWeight['Medium'],
                            color: Color(0xff2093F0),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: 27.5.w,
              left: 27.5.w,
              top: 20.0.h,
            ),
            child: Center(
              child: SizedBox(
                width: 213.0.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 80.0.w,
                      child: MaterialButton(
                        height: 80.0.h,
                        onPressed: () => changeWorkingStatusDialog(context: context, buttonName: "출근"),
                        color: Color(0xff2093F0),
                        textColor: whiteColor,
                        shape: CircleBorder(),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/icon_start_work.svg',
                              width: 18.0.w,
                              height: 18.0.h,
                            ),
                            Text(
                              "출근",
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                fontWeight: fontWeight['Medium'],
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                    Container(
                      width: 80.0.w,
                      child: MaterialButton(
                        height: 80.0.h,
                        onPressed: () => finishWorkDialog(context: context),
                        color: Color(0xffECECEC),
                        textColor: Color(0xff9C9C9C),
                        shape: CircleBorder(),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/icon_finish_work.svg',
                              width: 18.0.w,
                              height: 18.0.h,
                            ),
                            Text(
                              "퇴근",
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                fontWeight: fontWeight['Medium'],
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: 27.5.w,
              left: 27.5.w,
              top: 20.0.h,
            ),
            child: SizedBox(
              height: 43.0.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 125.0.w,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "출근시간",
                              style: TextStyle(
                                fontSize: 13.0.sp,
                                color: Color(0xff9C9C9C)
                              ),
                            ),
                            Text(
                              "9:00",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 13.0.sp,
                                fontWeight: fontWeight['Medium'],
                                color: Color(0xff2093F0)
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "퇴근시간",
                              style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: Color(0xff9C9C9C)
                              ),
                            ),
                            Text(
                              "-",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 13.0.sp,
                                  fontWeight: fontWeight['Medium'],
                                  color: Color(0xff2093F0)
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                  SizedBox(
                    width: 116.0.w,
                    height: 29.0.h,
                    child: ElevatedButton(
                      onPressed: () => applyOvertimeBottomSheet(context: context),
                      style: ElevatedButton.styleFrom(
                        primary: whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0.r),
                        ),
                      ),
                      child: Text(
                        "연장근무신청 +",
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Color(0xff2093F0),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 20.0.h,
            ),
            child: Divider(
              color: Color(0xffECECEC),
              thickness: 1.0.h,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: 27.5.w,
              left: 27.5.w,
              top: 20.0.h,
            ),
            child: Center(
              child: Text(
                "주간 근무현황",
                style: TextStyle(
                  fontSize: 15.0.sp,
                  fontWeight: fontWeight['Medium'],
                  color: textColor,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: 27.5.w,
              left: 27.5.w,
              top: 21.0.h,
            ),
            child: Center(
              child: SizedBox(
                width: 194.0.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                      iconSize: 24.0.h,
                      splashRadius: 24.0.r,
                      onPressed: (){},
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Text(
                      "4/25 - 5/1",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.0.sp,
                        fontWeight: fontWeight['Medium'],
                        color: Color(0xff2093F0),
                      ),
                    ),
                    IconButton(
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 24.0.h,
                      splashRadius: 24.0.r,
                      onPressed: null,
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                      disabledColor: Color(0xff2093F0).withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              right: 27.5.w,
              left: 27.5.w,
              top: 21.0.h,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7.0.r),
              child: Container(
                height: 8.0.h,
                child: LinearProgressIndicator(
                  backgroundColor: test > 1 ? Colors.blue : Colors.grey,
                  value: test > 1 ? (test - 1) : test,
                  valueColor: test > 1 ? AlwaysStoppedAnimation<Color>(Colors.red) : AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
