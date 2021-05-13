/*
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/widget/main_menu.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/model/schedule_model.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_picker_widget.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_theme.dart';
import 'package:mycompany/schedule/widget/schedule_calender_widget.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  List<Appointment> scheduleList = <Appointment>[];
  List<CalendarResource> resource = <CalendarResource>[];
  bool isChk = false;
  bool isDatePopup = false;
  CalendarController _controller = CalendarController();
  late GlobalKey<ScaffoldState> _key;

  String _headerText = '';
  DateTime _time = DateTime.now();

  @override
  void initState() {
    _key = GlobalKey<ScaffoldState>();
    super.initState();
    _getDataSource();
    setState(() {});
  }

  _getDataSource() async {
    List<Appointment> schedules = await ScheduleFunctionReprository().getSheduleData(companyCode: "0S9YLBX");

    setState(() {
      scheduleList = schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      key: _key,
      floatingActionButton: getMainCircularMenu(context: context, navigator: 'home'),
      drawer: Drawer(
        child: Center(child: Text('Left!')),
      ),
      body: RefreshIndicator(
        onRefresh: () => _getDataSource(),
        child: Container(
          padding: EdgeInsets.only(top: statusBarHeight, left: 16.0.w, right: 16.0.w),
          color: whiteColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                color: whiteColor,
                width: double.infinity,
                height: 52.0.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: SizedBox(
                        child: SvgPicture.asset(
                          'assets/icons/menu_icon.svg',
                          width: 24.0.w,
                          height: 24.0.h,
                        ),
                      ),
                      onTap: () {
                        _key.currentState!.openDrawer();
                      },
                    ),
                    GestureDetector(
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              _headerText,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: checkColor, fontSize: 21.0.sp, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                            ),
                            Icon(
                              isDatePopup ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: checkColor,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isDatePopup = !isDatePopup;
                        });
                      },
                    ),
                    SizedBox(
                      child: SvgPicture.asset(
                        'assets/icons/user_add.svg',
                        width: 24.7.w,
                        height: 21.7.h,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SfCalendar(
                      //allowViewNavigation: true,
                      controller: _controller,
                      showDatePickerButton: true,
                      showNavigationArrow: false,
                      dataSource: ScheduleModel(scheduleList),
                      view: CalendarView.month,
                      headerDateFormat: 'yyyy.MM',
                      headerHeight: 0.0.h,
                      //monthCellBuilder: (context, details) => ScheduleCalenderWidget().setMonthCellBuilder(context, details, _controller),
                      appointmentBuilder: (context, details) => ScheduleCalenderWidget().setAppointMentBuilder(context: context, details: details, selectTime: _time),
                      //cellBorderColor: whiteColor,
                      monthViewSettings: MonthViewSettings(
                          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                          appointmentDisplayCount: 5,
                          showTrailingAndLeadingDates: true,
                          */
/*monthCellStyle: MonthCellStyle(
                            textStyle: TextStyle(fontSize: 9.sp, color: Colors.black87, fontFamily: 'Roboto'),
                            trailingDatesTextStyle: TextStyle(fontSize: 9.sp, color: calenderLineColor.withOpacity(0.6), fontFamily: 'Roboto'),
                            leadingDatesTextStyle: TextStyle(fontSize: 9.sp, color: calenderLineColor.withOpacity(0.6), fontFamily: 'Roboto'),
                          ),*//*

                      ),
                      onViewChanged: (viewChangedDetails) {
                        if (_controller.view == CalendarView.month) {
                          _headerText =  DateFormat('yyyy.MM').format(viewChangedDetails.visibleDates[viewChangedDetails.visibleDates.length ~/ 2]).toString();
                          _time = DateTime.parse(viewChangedDetails.visibleDates[viewChangedDetails.visibleDates.length ~/ 2].toString());
                        }
                        SchedulerBinding.instance!.addPostFrameCallback((duration) {
                          setState(() {});
                        });
                      },
                      todayHighlightColor: checkColor,
                      onTap: (CalendarTapDetails details) => ScheduleFunctionReprository().getScheduleDetail(details: details, context: context),
                    ),
                    isDatePopup
                        ? Container(
                            height: 200.0.h,
                            color: whiteColor,
                            child: DatePickerWidget(
                              dateFormat: "yyyy MM",
                              minDateTime: DateTime(1900),
                              maxDateTime: DateTime(3000),
                              onMonthChangeStartWithFirstDate: true,
                              pickerTheme: DateTimePickerTheme(
                                pickerHeight: 200.0.h,
                                showTitle: false,
                              ),
                              locale: DateTimePickerLocale.ko,
                              initialDateTime: _time,
                              onCancel: () {},
                              onConfirm: (dateTime, selectedIndex) {},
                              onChange: (dateTime, selectedIndex) {
                                _controller.displayDate = dateTime;
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
