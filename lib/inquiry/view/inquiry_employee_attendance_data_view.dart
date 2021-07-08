import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/attendance/db/attendance_firestore_repository.dart';
import 'package:mycompany/attendance/function/total_office_hours_calculation_function.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class EmployeeAttendanceDataView extends StatefulWidget {
  @override
  EmployeeAttendanceDataViewState createState() => EmployeeAttendanceDataViewState();
}

class EmployeeAttendanceDataViewState extends State<EmployeeAttendanceDataView> {
  LoginFirestoreRepository _loginFirestoreRepository = LoginFirestoreRepository();
  AttendanceFirestoreRepository _attendanceFirestoreRepository = AttendanceFirestoreRepository();
  DateFormatCustom dateFormatCustom = DateFormatCustom();
  TotalOfficeHoursCalculationFunction _totalOfficeHoursCalculationFunction = TotalOfficeHoursCalculationFunction();

  DateTime now = DateTime.now();

  ValueNotifier<bool> isUserSelect = ValueNotifier<bool>(false);
  ValueNotifier<bool> isAllSelect = ValueNotifier<bool>(false);
  ValueNotifier<bool> isSelectTeam = ValueNotifier<bool>(true);

  ValueNotifier<Map<String, bool>> teamList = ValueNotifier<Map<String, bool>>({});
  ValueNotifier<Map<EmployeeModel, bool>> employeeList = ValueNotifier<Map<EmployeeModel, bool>>({});

  @override
  Widget build(BuildContext context) {
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context);
    EmployeeModel? loginEmployeeData = employeeInfoProvider.getEmployeeData();

    DateTime today = DateTime(now.year, now.month, now.day);

    ValueNotifier<DateTime> queryEndDate = ValueNotifier<DateTime>(DateTime(now.year, now.month, now.day + (6 - now.weekday)));
    ValueNotifier<DateTime> queryStartDate = ValueNotifier<DateTime>(queryEndDate.value.subtract(Duration(days: 6)));

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
              return value == true ? userSelectTopWidget() : defaultTopWidget(loginEmployeeData: loginEmployeeData!);
            },
          ),
          FutureBuilder<List<AttendanceModel>>(
            future: _attendanceFirestoreRepository.readEmployeeAttendanceData(employeeData: loginEmployeeData!, today: dateFormatCustom.changeDateTimeToTimestamp(dateTime: today)),
            builder: (context, attendanceSnapshot) {
              if(attendanceSnapshot.hasData == false){
                return Center(
                  child: Container(),
                );
              }

              attendanceSnapshot.data!.sort((a, b) => b.createDate!.compareTo(a.createDate!));

              DateTime snapshotLastDate = dateFormatCustom.changeTimestampToDateTime(timestamp: attendanceSnapshot.data!.last.createDate!);
              DateTime firstDate = DateTime(snapshotLastDate.year, snapshotLastDate.month, snapshotLastDate.day - (snapshotLastDate.weekday));

              return FutureBuilder<List<EmployeeModel>>(
                future: _loginFirestoreRepository.readMyTeamEmployeeData(employeeModel: loginEmployeeData),
                builder: (context, employeeSnapshot){
                  if(employeeSnapshot.hasData == false){
                    return Center(
                      child: Container(),
                    );
                  }

                  if(employeeList.value.isEmpty){
                    employeeSnapshot.data!.forEach((element) {
                      employeeList.value = Map.from(employeeList.value)..putIfAbsent(element, () => true);
                    });
                  }

                  ValueNotifier<Map<String, List<AttendanceModel>>> employeeWeekAttendanceData = ValueNotifier<Map<String, List<AttendanceModel>>>(
                    _totalOfficeHoursCalculationFunction.getEmployeeWeekAttendanceData(
                      attendanceDataList: attendanceSnapshot.data!,
                      employeeData: employeeList.value.keys.toList(),
                      startDate: queryStartDate.value,
                      endDate: queryEndDate.value,
                    )
                  );

                  ValueNotifier<Map<String, List<Duration>>> employeeWeekTotalOfficeHours = ValueNotifier<Map<String, List<Duration>>>(
                    _totalOfficeHoursCalculationFunction.employeeWeekTotalOfficeHoursCalculation(
                      employeeAttendanceDataList: employeeWeekAttendanceData.value,
                    )
                  );

                  return Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            //조회 기간
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
                                                employeeWeekAttendanceData.value = _totalOfficeHoursCalculationFunction.getEmployeeWeekAttendanceData(
                                                  attendanceDataList: attendanceSnapshot.data!,
                                                  employeeData: employeeList.value.keys.toList(),
                                                  startDate: queryStartDate.value,
                                                  endDate: queryEndDate.value,
                                                );

                                                employeeWeekTotalOfficeHours.value = _totalOfficeHoursCalculationFunction.employeeWeekTotalOfficeHoursCalculation(
                                                  employeeAttendanceDataList: employeeWeekAttendanceData.value,
                                                );
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

                                                employeeWeekAttendanceData.value = _totalOfficeHoursCalculationFunction.getEmployeeWeekAttendanceData(
                                                  attendanceDataList: attendanceSnapshot.data!,
                                                  employeeData: employeeList.value.keys.toList(),
                                                  startDate: queryStartDate.value,
                                                  endDate: queryEndDate.value,
                                                );

                                                employeeWeekTotalOfficeHours.value = _totalOfficeHoursCalculationFunction.employeeWeekTotalOfficeHoursCalculation(
                                                  employeeAttendanceDataList: employeeWeekAttendanceData.value,
                                                );
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
                                bottom: 20.0.h,
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
                            ValueListenableBuilder(
                              valueListenable: employeeList,
                              builder: (BuildContext context, Map<EmployeeModel, bool> employeeListValue, Widget? child){
                                employeeWeekAttendanceData.value = _totalOfficeHoursCalculationFunction.getEmployeeWeekAttendanceData(
                                  attendanceDataList: attendanceSnapshot.data!,
                                  employeeData: employeeList.value.keys.toList(),
                                  startDate: queryStartDate.value,
                                  endDate: queryEndDate.value,
                                );

                                employeeWeekTotalOfficeHours.value = _totalOfficeHoursCalculationFunction.employeeWeekTotalOfficeHoursCalculation(
                                  employeeAttendanceDataList: employeeWeekAttendanceData.value,
                                );
                                return ValueListenableBuilder(
                                  valueListenable: employeeWeekAttendanceData,
                                  builder: (BuildContext context, Map<String, List<AttendanceModel>> employeeWeekAttendanceDataValue, Widget? child) {
                                    return Expanded(
                                      child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: employeeListValue.values.length,
                                        itemBuilder: (context, employeeIndex){
                                          ValueNotifier<bool> isDetail = ValueNotifier<bool>(true);
                                          if(employeeListValue.values.elementAt(employeeIndex) == true){
                                            return Column(
                                              children: [
                                                Container(
                                                  height: 35.0.h,
                                                  color: calendarLineColor.withOpacity(0.1),
                                                  padding: EdgeInsets.only(
                                                    left: 23.0.w,
                                                    right: 20.0.w,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            employeeListValue.keys.elementAt(employeeIndex).name + " ",
                                                            style: TextStyle(
                                                              fontWeight: fontWeight["Medium"],
                                                              fontSize: 13.0.sp,
                                                              color: textColor,
                                                            ),
                                                          ),
                                                          (employeeListValue.keys.elementAt(employeeIndex).position == "" && employeeListValue.keys.elementAt(employeeIndex).team == "") ? Text(
                                                            ""
                                                          ) : Text(
                                                            (employeeListValue.keys.elementAt(employeeIndex).position != "" && employeeListValue.keys.elementAt(employeeIndex).team != "") ? "(${employeeListValue.keys.elementAt(employeeIndex).position}/${employeeListValue.keys.elementAt(employeeIndex).team})" : "(${employeeListValue.keys.elementAt(employeeIndex).position}${employeeListValue.keys.elementAt(employeeIndex).team})",
                                                            style: TextStyle(
                                                              fontWeight: fontWeight["Medium"],
                                                              fontSize: 13.0.sp,
                                                              color: textColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      ValueListenableBuilder(
                                                        valueListenable: isDetail,
                                                        builder: (BuildContext context, bool isDetailValue, Widget? child) {
                                                          return IconButton(
                                                            padding: EdgeInsets.zero,
                                                            constraints: BoxConstraints(),
                                                            icon: Icon(
                                                              isDetail.value == true ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                                              size: 20.0.w,
                                                            ),
                                                            onPressed: (){
                                                              isDetail.value = !isDetail.value;
                                                            },
                                                          );
                                                        }
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    left: 27.5.w,
                                                    right: 27.5.w,
                                                    bottom: 20.0.h,
                                                  ),
                                                  child: ValueListenableBuilder(
                                                    valueListenable: isDetail,
                                                    builder: (BuildContext context, bool isDetailValue, Widget? child){
                                                      return Visibility(
                                                        visible: isDetailValue,
                                                        child: Column(
                                                          children: [
                                                            ListView.builder(
                                                              shrinkWrap: true,
                                                              padding: EdgeInsets.zero,
                                                              physics: ScrollPhysics(),
                                                              itemCount: 7,
                                                              itemBuilder: (context, attendanceIndex){
                                                                List<AttendanceModel> attendanceData = employeeWeekAttendanceDataValue[employeeListValue.keys.elementAt(employeeIndex).mail]!;
                                                                return Padding(
                                                                  padding: EdgeInsets.only(top: 20.0.h),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child: Center(
                                                                          child: Text(
                                                                            dateFormatCustom.changeDateToString(date: queryStartDate.value.add(Duration(days: attendanceIndex)), isIncludeWeekday: true),
                                                                            style: TextStyle(
                                                                              fontSize: 13.0.sp,
                                                                              color: attendanceIndex == 0 ? Colors.red : attendanceIndex == 6 ? Color(0xff2093F0) : textColor,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child: Center(
                                                                          child: Text(
                                                                            attendanceData[attendanceIndex].attendTime == null ? "-" : dateFormatCustom.changeTimeToString(time: attendanceData[attendanceIndex].attendTime),
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
                                                                            attendanceData[attendanceIndex].endTime == null ? "-" : dateFormatCustom.changeTimeToString(time: attendanceData[attendanceIndex].endTime),
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
                                                                            _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: _totalOfficeHoursCalculationFunction.dayOfficeHoursCalculation(attendanceData: attendanceData[attendanceIndex])),
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
                                                            ),
                                                            Container(
                                                              child: Divider(
                                                                color: Color(0xffECECEC),
                                                                thickness: 1.0.h,
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(
                                                                top: 20.0.h,
                                                              ),
                                                              child: ValueListenableBuilder(
                                                                  valueListenable: employeeWeekTotalOfficeHours,
                                                                  builder: (BuildContext context, Map<String, List<Duration>> employeeWeekTotalOfficeHoursValue, Widget? child) {
                                                                    List<Duration> weekTotalOfficeHoursData = employeeWeekTotalOfficeHoursValue[employeeListValue.keys.elementAt(employeeIndex).mail]!;
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
                                                                                _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: weekTotalOfficeHoursData[0]),
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
                                                                                _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: weekTotalOfficeHoursData[1]),
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
                                                                                _totalOfficeHoursCalculationFunction.changeOfficeHoursToString(officeHours: weekTotalOfficeHoursData[2]),
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
                                                    },
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          else{
                                            return SizedBox();
                                          }
                                        },
                                      ),
                                    );
                                  }
                                );
                              },
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                          valueListenable: isUserSelect,
                          builder: (BuildContext context, bool value, Widget? child){
                            return value == false ? Container() : ValueListenableBuilder(
                              valueListenable: isSelectTeam,
                              builder: (BuildContext context, bool isSelectTeamValue, Widget? child){
                                return isSelectTeamValue == true ? teamSelectWidget() : employeeSelectWidget();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

        ],
      ),
    );
  }

  Container defaultTopWidget({required EmployeeModel loginEmployeeData}){
    return Container(
      padding: EdgeInsets.only(
        right: 27.5.w,
        left: 27.5.w,
        top: 10.0.h,
      ),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        child: SvgPicture.asset(
          'assets/icons/user_add.svg',
          width: 27.8.w,
          height: 23.76.h,
        ),
        onTap: () async {
          isUserSelect.value = !isUserSelect.value;
          //팀 데이터 입력
          await _loginFirestoreRepository.readTeamData(companyId: loginEmployeeData.companyCode).then((value){
            value.sort((a, b) => a.teamName.compareTo(b.teamName));
            
            value.forEach((element) {
              if(!teamList.value.containsKey(element)){
                if(element.teamName == loginEmployeeData.team){
                  teamList.value = Map.from(teamList.value)..putIfAbsent(element.teamName, () => true);
                }
                else{
                  teamList.value = Map.from(teamList.value)..putIfAbsent(element.teamName, () => false);
                }
              }
            });
          });

          //직원 데이터 입력
          await _loginFirestoreRepository.readAllEmployeeData(companyId: loginEmployeeData.companyCode).then((value){
            value.sort((a, b) => a.name.compareTo(b.name));

            value.forEach((element) {
              if(employeeList.value.keys.where((keyValue) => keyValue.mail == element.mail).isEmpty){
                if(element.team == loginEmployeeData.team){
                  employeeList.value = Map.from(employeeList.value)..putIfAbsent(element, () => true);
                }
                else{
                  employeeList.value = Map.from(employeeList.value)..putIfAbsent(element, () => false);
                }
              }
            });
          });
        },
      ),
    );
  }

  Container userSelectTopWidget(){
    return Container(
      padding: EdgeInsets.only(
        right: 27.5.w,
        left: 27.5.w,
        top: 20.0.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: IconButton(
              constraints: BoxConstraints(),
              icon: Icon(
                Icons.clear,
              ),
              onPressed: () => isUserSelect.value = false,
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              color: Color(0xff2093F0),
            ),
          ),
          Row(
            children: [
              ValueListenableBuilder(
                valueListenable: isAllSelect,
                builder: (BuildContext context, bool isAllSelectValue, Widget? child) {
                  return GestureDetector(
                    onTap: (){
                      isAllSelect.value = !isAllSelect.value;
                      if(isAllSelect.value == true){
                        teamList.value = Map.from(teamList.value)..updateAll((key, value) => value = true);
                        employeeList.value = Map.from(employeeList.value)..updateAll((key, value) => value = true);
                      }
                      else{
                        teamList.value = Map.from(teamList.value)..updateAll((key, value) => value = false);
                        employeeList.value = Map.from(employeeList.value)..updateAll((key, value) => value = false);
                      }
                    },
                    child: Text(
                      isAllSelectValue == true ? "deselect".tr() : "select_all".tr(),
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: isAllSelectValue == true ? checkColor : textColor,
                      ),
                    ),
                  );
                }
              ),
              SizedBox(
                width: 10.0.w,
              ),
              GestureDetector(
                onTap: (){
                  isSelectTeam.value = !isSelectTeam.value;
                },
                child: SvgPicture.asset(
                  'assets/icons/switch.svg',
                  width: 16.51.w,
                  height: 11.37.h,
                ),
              ),
              SizedBox(
                width: 10.0.w,
              ),
              ValueListenableBuilder(
                valueListenable: isSelectTeam,
                builder: (BuildContext context, bool isSelectTeamValue, Widget? child) {
                  return Text(
                    isSelectTeamValue == true ? "department".tr() : "employee".tr(),
                    style: TextStyle(
                      fontSize: 13.0.sp,
                      color: textColor,
                    ),
                  );
                }
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container teamSelectWidget(){
    return Container(
      padding: EdgeInsets.only(
        right: 27.5.w,
        left: 27.5.w,
        top: 10.0.h,
      ),
      height: 83.0.h,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(
          bottom: BorderSide(
              color: calendarLineColor.withOpacity(0.1),
              width: 0.5.w,
          ),
        ),
      ),
      child: ValueListenableBuilder(
          valueListenable: teamList,
          builder: (BuildContext context, Map<String, bool> teamListValue, Widget? child) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: teamListValue.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                     if(teamListValue.values.elementAt(index) == true){
                       teamList.value = Map.from(teamList.value)..update(teamListValue.keys.elementAt(index), (value) => false);
                       employeeList.value.keys.where((element) => element.team == teamListValue.keys.elementAt(index)).forEach((element) {
                         employeeList.value = Map.from(employeeList.value)..update(element, (value) => false);
                       });
                     }
                     
                     else{
                       teamList.value = Map.from(teamList.value)..update(teamListValue.keys.elementAt(index), (value) => true);
                       employeeList.value.keys.where((element) => element.team == teamListValue.keys.elementAt(index)).forEach((element) {
                         employeeList.value = Map.from(employeeList.value)..update(element, (value) => true);
                       });
                     }

                      //전체 선택 / 해제 변경
                      if(teamList.value.values.contains(false)){
                        isAllSelect.value = false;
                      }
                      else{
                        isAllSelect.value = true;
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        right: 20.0.w,
                      ),
                      child: Column(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 50.0.h,
                              height: 50.0.h,
                              color: teamListValue.values.elementAt(index) == true ? Color(0xff2093F0) : cirecularLineColor,
                              alignment: Alignment.center,
                              child: ClipOval(
                                child: Container(
                                  width: 46.0.h,
                                  height: 46.0.h,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 42.0.h,
                                    height: 42.0.h,
                                    child: SvgPicture.asset(
                                      'assets/icons/icon_team.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            teamList.value.keys.elementAt(index),
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }

  Container employeeSelectWidget(){
    return Container(
      padding: EdgeInsets.only(
        right: 27.5.w,
        left: 27.5.w,
        top: 10.0.h,
      ),
      height: 83.0.h,
      decoration: BoxDecoration(
        color: whiteColor,
        border: Border(
          bottom: BorderSide(
            color: calendarLineColor.withOpacity(0.1),
            width: 0.5.w,
          ),
        ),
      ),
      child: ValueListenableBuilder(
          valueListenable: employeeList,
          builder: (BuildContext context, Map<EmployeeModel, bool> employeeDataValue, Widget? child) {
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: employeeDataValue.keys.length,
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      employeeList.value = Map.from(employeeList.value)..update(employeeDataValue.keys.elementAt(index), (value) => !value);

                      //팀 선택
                      if(employeeList.value.values.elementAt(index) == false){
                        teamList.value.keys.where((element) => element == employeeList.value.keys.elementAt(index).team).forEach((element) {
                          teamList.value = Map.from(teamList.value)..update(element, (value) => false,);
                        });
                      }

                      //전체 선택 / 해제 변경
                      if(employeeList.value.values.contains(false)){
                        isAllSelect.value = false;
                      }
                      else{
                        isAllSelect.value = true;
                        teamList.value = Map.from(teamList.value)..updateAll((key, value) => true);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        right: 20.0.w,
                      ),
                      child: Column(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 50.0.h,
                              height: 50.0.h,
                              color: employeeDataValue.values.elementAt(index) == true ? Color(0xff2093F0) : cirecularLineColor,
                              alignment: Alignment.center,
                              child: ClipOval(
                                child: Container(
                                  width: 46.0.h,
                                  height: 46.0.h,
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 42.0.h,
                                    height: 42.0.h,
                                    child: employeeDataValue.keys.elementAt(index).profilePhoto != "" ? FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/logo_blue.png',
                                      image: employeeDataValue.keys.elementAt(index).profilePhoto!,
                                      height: 50.0.h,
                                    )
                                        : SvgPicture.asset(
                                      'assets/icons/personal.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            employeeDataValue.keys.elementAt(index).name,
                            style: TextStyle(
                              fontSize: 13.0.sp,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
