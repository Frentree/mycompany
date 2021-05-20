import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/widget/main_menu.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:mycompany/schedule/db/schedule_firestore_repository.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/model/schedule_model.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_picker_widget.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_theme.dart';
import 'package:mycompany/schedule/widget/schedule_calender_widget.dart';
import 'package:mycompany/schedule/widget/schedule_circular_menu.dart';
import 'package:mycompany/schedule/widget/sfcalender/src/calendar.dart';

class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  List<Appointment> scheduleList = <Appointment>[];
  List<CalendarResource> resource = <CalendarResource>[];
  bool _isDatePopup = false;
  bool _isColleague = false;
  bool _isColleagueChk = false;
  bool _isPersonalChk = false;
  late CalendarController _controller;
  late GlobalKey<ScaffoldState> _key;

  String _headerText = '';
  DateTime _time = DateTime.now();

  @override
  void initState() {
    mailChkList.clear();
    mailChkList.add("bsc2079@naver.com");
    _key = GlobalKey<ScaffoldState>();
    _controller = CalendarController();
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
          padding: EdgeInsets.only(top: statusBarHeight + 10.0.h, left: 16.0.w, right: 16.0.w),
          color: whiteColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Container(
                color: whiteColor,
                width: double.infinity,
                height: 52.0.h,
                child: _isColleague ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Text(
                        "전체 선택",
                        style: TextStyle(
                          color: _isColleagueChk ? checkColor : textColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      onTap: () {
                        _isColleagueChk = !_isColleagueChk;
                        _getDataSource();
                        setState(() {});
                      },
                    ),
                    GestureDetector(
                      child: Row(
                        children: [
                          Container(
                            height: 50.0.h,
                            child: SizedBox(
                              width: 16.51.w,
                              height: 11.37.h,
                              child: SvgPicture.asset(
                                'assets/icons/switch.svg',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4.0.w,
                          ),
                          Text(
                            "직원",
                            style: TextStyle(
                                color: _isColleagueChk ? checkColor : textColor,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _isColleague = !_isColleague;
                        });
                      },
                    ),
                  ],
                ) :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: SvgPicture.asset(
                        'assets/icons/menu_icon.svg',
                        width: 24.0.w,
                        height: 24.0.h,
                      ),
                      onTap: () => _key.currentState!.openDrawer(),
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
                              _isDatePopup ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                              color: checkColor,
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isDatePopup = !_isDatePopup;
                        });
                      },
                    ),
                    GestureDetector(
                      child: SvgPicture.asset(
                        'assets/icons/user_add.svg',
                        width: 27.8.w,
                        height: 23.76.h,
                      ),
                      onTap: () {
                        setState(() {
                          _isColleague = !_isColleague;
                          _isDatePopup = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0.h,
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
                          /*monthCellStyle: MonthCellStyle(
                            textStyle: TextStyle(fontSize: 9.sp, color: Colors.black87, fontFamily: 'Roboto'),
                            trailingDatesTextStyle: TextStyle(fontSize: 9.sp, color: calenderLineColor.withOpacity(0.6), fontFamily: 'Roboto'),
                            leadingDatesTextStyle: TextStyle(fontSize: 9.sp, color: calenderLineColor.withOpacity(0.6), fontFamily: 'Roboto'),
                          ),*/
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
                    _isDatePopup
                        ? Container(
                            height: 200.0.h,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: calendarLineColor.withOpacity(0.1),
                                  width: 0.5.w
                                )
                              )
                            ),
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
                    _isColleague ? Container(
                      width: double.infinity,
                      height: 92.0.h,
                      decoration: BoxDecoration(
                        color: whiteColor,
                          border: Border(
                              bottom: BorderSide(
                                  color: calendarLineColor.withOpacity(0.1),
                                  width: 0.5.w
                              )
                          )
                      ),
                      child: FutureBuilder<QuerySnapshot>(
                        future: ScheduleFirebaseReository().getCompanyUser(companyCode: "0S9YLBX"),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData){
                            return Container();
                          }
                          List<QueryDocumentSnapshot> doc = snapshot.data!.docs;

                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: doc.map((data) => _buildColleague(context, data, _getDataSource, _isColleagueChk)).toList(),
                          );
                        },
                      )
                    ) : Container(),
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

List<String> mailChkList = [];

Widget _buildColleague(BuildContext context, QueryDocumentSnapshot data, getDataSource, bool _isColleagueChk) {
  String mail = data.data()['mail'];

  return Row(
    children: [
      getClipOverProfile(
          context: context,
          ImageUri: data.data()['profilePhoto'] ?? '',
          name: data.data()['name'].toString(),
          mail: mail,
          isChks: mailChkList.contains(mail),
          getDataSource: getDataSource
      ),
      SizedBox(width: 26.0.w,)
    ],
  );

}
