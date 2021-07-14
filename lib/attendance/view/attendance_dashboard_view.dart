import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/attendance/function/total_office_hours_calculation_function.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';

class AttendanceDataView extends StatefulWidget {
  List<AttendanceModel> attendanceData;

  AttendanceDataView({Key? key, required this.attendanceData}) : super(key: key);

  @override
  AttendanceDataViewState createState() => AttendanceDataViewState();
}

class AttendanceDataViewState extends State<AttendanceDataView> {
  DateFormatCustom dateFormatCustom = DateFormatCustom();
  TotalOfficeHoursCalculationFunction _totalOfficeHoursCalculationFunction = TotalOfficeHoursCalculationFunction();

  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    ValueNotifier<DateTime> queryEndDate = ValueNotifier<DateTime>(DateTime(now.year, now.month, now.day + (6 - now.weekday)));
    ValueNotifier<DateTime> queryStartDate = ValueNotifier<DateTime>(queryEndDate.value.subtract(Duration(days: 6)));
    ValueNotifier<List<AttendanceModel>> weekAttendanceData = ValueNotifier<List<AttendanceModel>>(_totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: widget.attendanceData, startDate: queryStartDate.value, endDate: queryEndDate.value));
    ValueNotifier<List<Duration>> weekTotalOfficeHours = ValueNotifier<List<Duration>>(_totalOfficeHoursCalculationFunction.weekTotalOfficeHoursCalculation(attendanceDataList: weekAttendanceData.value));

    DateTime snapshotLastDate = dateFormatCustom.changeTimestampToDateTime(timestamp: widget.attendanceData.last.createDate!);

    DateTime lastDate = DateTime(now.year, now.month, now.day + (6 - now.weekday));
    DateTime firstDate = DateTime(snapshotLastDate.year, snapshotLastDate.month, snapshotLastDate.day - (snapshotLastDate.weekday));

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
                    "출퇴근 기록",
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
              top: 20.0.h,
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
                              weekAttendanceData.value = _totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: widget.attendanceData, startDate: queryStartDate.value, endDate: queryEndDate.value);
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
                              weekAttendanceData.value = _totalOfficeHoursCalculationFunction.getWeekAttendanceData(attendanceDataList: widget.attendanceData, startDate: queryStartDate.value, endDate: queryEndDate.value);
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
              top: 20.0.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "일자",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Color(0xff9C9C9C),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "출근",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Color(0xff9C9C9C),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "퇴근",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Color(0xff9C9C9C),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "근무시간",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Color(0xff9C9C9C),
                      ),
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
            ),
            child: ValueListenableBuilder(
              valueListenable: weekAttendanceData,
              builder: (BuildContext context, List<AttendanceModel> value, Widget? child){
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: value.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.only(top: 20.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                dateFormatCustom.changeDateToString(date: queryStartDate.value.add(Duration(days: index)), isIncludeWeekday: true),
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: index == 0 ? Colors.red : index == 6 ? Color(0xff2093F0) : textColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                value[index].attendTime == null ? "-" : dateFormatCustom.changeTimeToString(time: value[index].attendTime),
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: Color(0xff9C9C9C),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                value[index].endTime == null ? "-" : dateFormatCustom.changeTimeToString(time: value[index].endTime),
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: Color(0xff9C9C9C),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: _totalOfficeHoursCalculationFunction.dayOfficeHoursCalculation(attendanceData: value[index])),
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: Color(0xff9C9C9C),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
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
            child: ValueListenableBuilder(
                valueListenable: weekTotalOfficeHours,
                builder: (BuildContext context, List<Duration> value, Widget? child) {
                  return Column(
                    children: [
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
        ],
      ),
    );
  }
}
