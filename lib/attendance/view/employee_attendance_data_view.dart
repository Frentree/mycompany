/*
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/attendance/db/attendance_firestore_repository.dart';
import 'package:mycompany/attendance/function/show_work_type.dart';
import 'package:mycompany/attendance/function/total_office_hours_calculation_function.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/attendance/widget/attendance_bottom_sheet.dart';
import 'package:mycompany/attendance/widget/attendance_dialog_widget.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';
import 'package:provider/provider.dart';

class EmployeeAttendanceDataView extends StatefulWidget {
  @override
  EmployeeAttendanceDataViewState createState() => EmployeeAttendanceDataViewState();
}

class EmployeeAttendanceDataViewState extends State<EmployeeAttendanceDataView> {
  AttendanceFirestoreRepository _attendanceFirestoreRepository = AttendanceFirestoreRepository();
  DateFormatCustom dateFormatCustom = DateFormatCustom();
  TotalOfficeHoursCalculationFunction _totalOfficeHoursCalculationFunction = TotalOfficeHoursCalculationFunction();

  DateTime now = DateTime.now();

  ValueNotifier<bool> isUserSelect = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();

    DateTime today = DateTime(now.year, now.month, now.day);


    */
/*ValueNotifier<DateTime> queryStartDate = ValueNotifier<DateTime>(queryEndDate.value.subtract(Duration(days: 6)));
    ValueNotifier<DateTime> queryEndDate = ValueNotifier<DateTime>(DateTime(now.year, now.month, now.day + (6 - now.weekday)));
    ValueNotifier<List<AttendanceModel>> weekAttendanceData = ValueNotifier<List<AttendanceModel>>(_totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: widget.attendanceData, startDate: queryStartDate.value, endDate: queryEndDate.value));
    ValueNotifier<List<Duration>> weekTotalOfficeHours = ValueNotifier<List<Duration>>(_totalOfficeHoursCalculationFunction.weekTotalOfficeHoursCalculation(attendanceDataList: weekAttendanceData.value));
*//*

    DateTime lastDate = DateTime(now.year, now.month, now.day + (6 - now.weekday));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder(
            valueListenable: isUserSelect,
            builder: (BuildContext context, bool value, Widget? child){
              return value == true ? userSelectAppBar() : defaultAppBar();
            },
          ),
          FutureBuilder<List<AttendanceModel>>(
            future: _attendanceFirestoreRepository.readEmployeeAttendanceData(employeeData: loginEmployeeData!, today: dateFormatCustom.changeDateTimeToTimestamp(dateTime: today)),
            builder: (context, snapshot) {
              if(snapshot.hasData == false){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              snapshot.data!.sort()

              ValueNotifier<Map<String, List<AttendanceModel>>> weekAttendanceData = ValueNotifier<Map<String, List<AttendanceModel>>>(_totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: snapshot.data!, startDate: queryStartDate.value, endDate: queryEndDate.value));

              return Container();
            },
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                    Text("min"),
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: isUserSelect,
                  builder: (BuildContext context, bool value, Widget? child){
                    return value == true ? userSelectAppBar() : Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container defaultAppBar(){
    return Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
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
                    "직원 출퇴근 기록",
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: fontWeight['Medium'],
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/user_add.svg',
                width: 27.8.w,
                height: 23.76.h,
              ),
              onTap: () {
                isUserSelect.value = true;
              },
            ),
          ],
        ),
      ),
    );
  }
  Container userSelectAppBar(){
    return Container(
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
        height: 20.0.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
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
                    "사용자 선택",
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      fontWeight: fontWeight['Medium'],
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/user_add.svg',
                width: 27.8.w,
                height: 23.76.h,
              ),
              onTap: () {
                isUserSelect.value = false;
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/
