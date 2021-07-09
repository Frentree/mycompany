import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/attendance/db/attendance_firestore_repository.dart';
import 'package:mycompany/attendance/function/show_work_type.dart';
import 'package:mycompany/attendance/function/total_office_hours_calculation_function.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/attendance/view/attendance_data_view.dart';
import 'package:mycompany/attendance/widget/attendance_bottom_sheet.dart';
import 'package:mycompany/attendance/widget/attendance_dialog_widget.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/fcm/send_fcm.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:provider/provider.dart';

class AttendanceDashboardView extends StatefulWidget {
  @override
  AttendanceDashboardViewState createState() => AttendanceDashboardViewState();
}

class AttendanceDashboardViewState extends State<AttendanceDashboardView> {
  AttendanceFirestoreRepository _attendanceFirestoreRepository = AttendanceFirestoreRepository();
  DateFormatCustom dateFormatCustom = DateFormatCustom();
  TotalOfficeHoursCalculationFunction _totalOfficeHoursCalculationFunction = TotalOfficeHoursCalculationFunction();

  PublicFunctionRepository _publicFunctionRepository = PublicFunctionRepository();

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();

    DateTime today = DateTime(now.year, now.month, now.day);

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
                    onPressed: () => _publicFunctionRepository.onBackPressed(context: context),
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
          FutureBuilder<List<AttendanceModel>>(
              future: _attendanceFirestoreRepository.readMyAttendanceData(employeeData: loginEmployeeData!, today: dateFormatCustom.changeDateTimeToTimestamp(dateTime: today)),
              builder: (context, snapshot) {
                if(snapshot.hasData == false || snapshot.data == null){
                  return Container();
                }

                snapshot.data!.sort((a, b) => b.createDate!.compareTo(a.createDate!));

                ValueNotifier<String> officeHours = ValueNotifier<String>("");
                ValueNotifier<int> attendanceStatus = ValueNotifier<int>(snapshot.data![0].status!);
                ValueNotifier<Timestamp?> attendanceAttendTime = ValueNotifier<Timestamp?>(snapshot.data![0].attendTime);
                ValueNotifier<Timestamp?> attendanceEndTime = ValueNotifier<Timestamp?>(snapshot.data![0].endTime);
                ValueNotifier<DateTime> queryEndDate = ValueNotifier<DateTime>(DateTime(now.year, now.month, now.day + (6 - now.weekday)));
                ValueNotifier<DateTime> queryStartDate = ValueNotifier<DateTime>(queryEndDate.value.subtract(Duration(days: 6)));
                ValueNotifier<List<AttendanceModel>> weekAttendanceData = ValueNotifier<List<AttendanceModel>>(_totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: snapshot.data!, startDate: queryStartDate.value, endDate: queryEndDate.value));
                ValueNotifier<List<Duration>> weekTotalOfficeHours = ValueNotifier<List<Duration>>(_totalOfficeHoursCalculationFunction.weekTotalOfficeHoursCalculation(attendanceDataList: weekAttendanceData.value));

                DateTime snapshotLastDate = dateFormatCustom.changeTimestampToDateTime(timestamp: snapshot.data!.last.createDate!);

                DateTime lastDate = DateTime(now.year, now.month, now.day + (6 - now.weekday));
                DateTime firstDate = DateTime(snapshotLastDate.year, snapshotLastDate.month, snapshotLastDate.day - (snapshotLastDate.weekday));

                Timer? timer = _totalOfficeHoursCalculationFunction.todayOfficeHoursCalculation(officeHours: officeHours, attendTime: attendanceAttendTime, endTime: attendanceEndTime);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              ValueListenableBuilder(
                                  valueListenable: officeHours,
                                  builder: (BuildContext context, String value, Widget? child) {
                                    return Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 26.0.sp,
                                        fontWeight: fontWeight['Bold'],
                                        color: Color(0xff2093F0),
                                      ),
                                    );
                                  }
                              )
                            ],
                          ),
                          ValueListenableBuilder(
                              valueListenable: attendanceStatus,
                              builder: (BuildContext context, int value, Widget? child) {
                                return GestureDetector(
                                  onTap: () async {
                                    dynamic changedWorkType = await viewWorkingStatusDialog(context: context, attendTime: attendanceAttendTime.value, endTime: attendanceEndTime.value, workTypeNumber: value);
                                    if(changedWorkType != 0 && changedWorkType != null){
                                      attendanceStatus.value = changedWorkType;
                                      attendanceEndTime.value = null;

                                      snapshot.data![0].status = changedWorkType;
                                      snapshot.data![0].endTime = null;
                                      snapshot.data![0].autoOffWork = 0;

                                      _attendanceFirestoreRepository.updateAttendanceData(companyId: loginEmployeeData.companyCode, attendanceModel: snapshot.data![0]);
                                      if(timer == null || timer!.isActive == false){
                                        timer = _totalOfficeHoursCalculationFunction.todayOfficeHoursCalculation(officeHours: officeHours, attendTime: attendanceAttendTime, endTime: attendanceEndTime);
                                      }

                                      if(queryEndDate.value == DateTime(now.year, now.month, now.day + (6 - now.weekday))){
                                        weekTotalOfficeHours.value = _totalOfficeHoursCalculationFunction.weekTotalOfficeHoursCalculation(attendanceDataList: weekAttendanceData.value);
                                      }
                                    }
                                  },
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
                                          changeWorkTypeNumberToString(workTypeNumber: value),
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            fontWeight: fontWeight['Medium'],
                                            color: Color(0xff2093F0),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
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
                      child: ValueListenableBuilder(
                          valueListenable: attendanceStatus,
                          builder: (BuildContext context, int value, Widget? child) {
                            return Center(
                              child: SizedBox(
                                width: 213.0.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 80.0.w,
                                      child: MaterialButton(
                                        height: 80.0.h,
                                        onPressed: value == 0 ? () async {
                                          dynamic changedWorkType = await changeWorkingStatusDialog(context: context, buttonName: "출근");

                                          if(changedWorkType != 0 && changedWorkType != null){
                                            attendanceStatus.value = changedWorkType;
                                            attendanceAttendTime.value = Timestamp.now();

                                            snapshot.data![0].status = changedWorkType;
                                            snapshot.data![0].attendTime = Timestamp.now();
                                            snapshot.data![0].certificationDevice = 1;
                                            snapshot.data![0].manualOnWorkReason = 0;

                                            _attendanceFirestoreRepository.updateAttendanceData(companyId: loginEmployeeData.companyCode, attendanceModel: snapshot.data![0]);

                                            timer = _totalOfficeHoursCalculationFunction.todayOfficeHoursCalculation(officeHours: officeHours, attendTime: attendanceAttendTime, endTime: attendanceEndTime);
                                          }
                                        } : null,
                                        color: Color(0xffECECEC),
                                        textColor: Color(0xff9C9C9C),
                                        disabledColor: value == 6 ? Color(0xffECECEC) : Color(0xff2093F0),
                                        disabledTextColor: value == 6 ? Color(0xff9C9C9C) : whiteColor,
                                        shape: CircleBorder(),
                                        child: Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/icon_start_work.svg',
                                              width: 18.0.w,
                                              height: 18.0.h,
                                              color: (value == 0 || value == 6) ? Color(0xff9C9C9C) : whiteColor,
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
                                      ),
                                    ),
                                    Container(
                                        width: 80.0.w,
                                        child: MaterialButton(
                                          height: 80.0.h,
                                          onPressed: (value != 0 && value != 6)? () async {
                                            dynamic offWorkResult = await finishWorkDialog(context: context);
                                            if(offWorkResult == true && offWorkResult != null){
                                              attendanceStatus.value = 6;
                                              attendanceEndTime.value = Timestamp.now();

                                              snapshot.data![0].status = 6;
                                              snapshot.data![0].endTime = Timestamp.now();
                                              snapshot.data![0].autoOffWork = 1;

                                              _attendanceFirestoreRepository.updateAttendanceData(companyId: loginEmployeeData.companyCode, attendanceModel: snapshot.data![0]);

                                              if(queryEndDate.value == DateTime(now.year, now.month, now.day + (6 - now.weekday))){
                                                weekTotalOfficeHours.value = _totalOfficeHoursCalculationFunction.weekTotalOfficeHoursCalculation(attendanceDataList: weekAttendanceData.value);
                                              }

                                              timer!.cancel();
                                            }
                                          } : null,
                                          color: Color(0xffECECEC),
                                          textColor: Color(0xff9C9C9C),
                                          disabledColor: Color(0xff2093F0),
                                          disabledTextColor: whiteColor,
                                          shape: CircleBorder(),
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/icon_finish_work.svg',
                                                width: 18.0.w,
                                                height: 18.0.h,
                                                color: (value != 0 && value != 6) ? Color(0xff9C9C9C) : whiteColor,
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
                            );
                          }
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
                                        ValueListenableBuilder(
                                            valueListenable: attendanceAttendTime,
                                            builder: (BuildContext context, Timestamp? value, Widget? child) {
                                              return Text(
                                                value == null? "-" : dateFormatCustom.changeTimeToString(time: value),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13.0.sp,
                                                  fontWeight: fontWeight['Medium'],
                                                  color: Color(0xff2093F0),
                                                ),
                                              );
                                            }
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
                                            color: Color(0xff9C9C9C),
                                          ),
                                        ),
                                        ValueListenableBuilder(
                                            valueListenable: attendanceEndTime,
                                            builder: (BuildContext context, Timestamp? value, Widget? child) {
                                              return Text(
                                                value == null? "-" : dateFormatCustom.changeTimeToString(time: value),
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 13.0.sp,
                                                  fontWeight: fontWeight['Medium'],
                                                  color: Color(0xff2093F0),
                                                ),
                                              );
                                            }
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(
                              width: 116.0.w,
                              height: 29.0.h,
                              child: ValueListenableBuilder(
                                  valueListenable: attendanceStatus,
                                  builder: (BuildContext context, int value, Widget? child) {
                                    return ElevatedButton(
                                      onPressed: (value != 0 && value != 5 && value != 6) ? () async {
                                        int? overtimeValue = await applyOvertimeBottomSheet(context: context);

                                        if(overtimeValue != null){
                                          List<EmployeeModel> approvalList = await LoginFirestoreRepository().readAllEmployeeData(companyId: loginEmployeeData.companyCode);
                                          await selectOvertimeApprovalBottomSheet(context: context, employeeModel: loginEmployeeData, approvalList: approvalList, overtime: overtimeValue);
                                        }
                                      } : null,
                                      style: ElevatedButton.styleFrom(
                                        primary: whiteColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(14.0.r),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "연장근무신청 +",
                                          style: TextStyle(
                                            fontSize: 13.0.sp,
                                            color: (value != 0 && value != 5 && value != 6) ? Color(0xff2093F0) : Color(0xff9C9C9C),
                                          ),
                                        ),
                                      ),
                                    );
                                  }
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
                              ValueListenableBuilder(
                                  valueListenable: queryStartDate,
                                  builder: (BuildContext context, DateTime value, Widget? child) {
                                    return IconButton(
                                      constraints: BoxConstraints(),
                                      icon: Icon(
                                        Icons.arrow_back_ios_outlined,
                                      ),
                                      iconSize: 24.0.h,
                                      splashRadius: 24.0.r,
                                      onPressed: value == firstDate ? null : (){
                                        queryEndDate.value = queryEndDate.value.subtract(Duration(days: 7));
                                        queryStartDate.value = queryEndDate.value.subtract(Duration(days: 6));

                                        weekAttendanceData.value = _totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: snapshot.data!, startDate: queryStartDate.value, endDate: queryEndDate.value);
                                        weekTotalOfficeHours.value = _totalOfficeHoursCalculationFunction.weekTotalOfficeHoursCalculation(attendanceDataList: weekAttendanceData.value);
                                      },
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.centerLeft,
                                      color: Color(0xff2093F0),
                                      disabledColor: Color(0xff2093F0).withOpacity(0.2),
                                    );
                                  }
                              ),
                              ValueListenableBuilder(
                                  valueListenable: queryEndDate,
                                  builder: (BuildContext context, DateTime value, Widget? child) {
                                    return Text(
                                      "${dateFormatCustom.changeDateToString(date: queryStartDate.value)} - ${dateFormatCustom.changeDateToString(date: value)}",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14.0.sp,
                                        fontWeight: fontWeight['Medium'],
                                        color: Color(0xff2093F0),
                                      ),
                                    );
                                  }
                              ),
                              ValueListenableBuilder(
                                  valueListenable: queryEndDate,
                                  builder: (BuildContext context, DateTime value, Widget? child) {
                                    return IconButton(
                                      constraints: BoxConstraints(),
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                      ),
                                      iconSize: 24.0.h,
                                      splashRadius: 24.0.r,
                                      onPressed: queryEndDate.value == lastDate ? null : (){
                                        queryEndDate.value = queryEndDate.value.add(Duration(days: 7));
                                        queryStartDate.value = queryEndDate.value.subtract(Duration(days: 6));
                                        weekAttendanceData.value = _totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: snapshot.data!, startDate: queryStartDate.value, endDate: queryEndDate.value);
                                        weekTotalOfficeHours.value = _totalOfficeHoursCalculationFunction.weekTotalOfficeHoursCalculation(attendanceDataList: weekAttendanceData.value);
                                      },
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.centerLeft,
                                      color: Color(0xff2093F0),
                                      disabledColor: Color(0xff2093F0).withOpacity(0.2),
                                    );
                                  }
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
                      child: ValueListenableBuilder(
                          valueListenable: weekTotalOfficeHours,
                          builder: (BuildContext context, List<Duration> value, Widget? child) {

                            double officeHoursRatio = (value[0].inMinutes / 3120);

                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 20.0.h),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7.0.r),
                                    child: Container(
                                      height: 8.0.h,
                                      child: LinearProgressIndicator(
                                        backgroundColor: officeHoursRatio > 1 ? Colors.blue : Colors.grey,
                                        value: officeHoursRatio > 1 ? (officeHoursRatio - 1) : officeHoursRatio,
                                        valueColor: officeHoursRatio > 1 ? AlwaysStoppedAnimation<Color>(Colors.red) : AlwaysStoppedAnimation<Color>(Colors.blue),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 6.0.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "주간 총 근무시간",
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Color(0xff9C9C9C),
                                        ),
                                      ),
                                      Text(
                                        _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: value[0]),
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14.0.sp,
                                          fontWeight: fontWeight['Medium'],
                                          color: Color(0xff2093F0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 6.0.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "연장 근무시간",
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Color(0xff9C9C9C),
                                        ),
                                      ),
                                      Text(
                                        _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: value[1]),
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14.0.sp,
                                          fontWeight: fontWeight['Medium'],
                                          color: Color(0xff2093F0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 6.0.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "주간 근무가능 잔여시간",
                                        style: TextStyle(
                                          fontSize: 13.0.sp,
                                          color: Color(0xffF23662),
                                        ),
                                      ),
                                      Text(
                                        _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: value[2]),
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 14.0.sp,
                                          fontWeight: fontWeight['Medium'],
                                          color: Color(0xffF23662),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "최대 근무시간",
                                      style: TextStyle(
                                        fontSize: 13.0.sp,
                                        color: Color(0xff9C9C9C),
                                      ),
                                    ),
                                    Text(
                                      "52시간",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14.0.sp,
                                        fontWeight: fontWeight['Medium'],
                                        color: Color(0xff131313),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 27.5.w,
                        left: 27.5.w,
                        top: 20.0.h,
                      ),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AttendanceDataView(attendanceData: snapshot.data!)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "출퇴근 기록 보기",
                              style: TextStyle(
                                fontSize: 12.0.sp,
                                fontWeight: fontWeight["Medium"],
                                color: Color(0xff2093F0),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 10.0.h,
                              color: Color(0xff2093F0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
          ),
        ],
      ),
    );
  }
}
