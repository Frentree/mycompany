import 'package:flutter/material.dart';
import 'package:mycompany/public/widget/main_menu.dart';
import 'package:mycompany/schedule/function/schedule_function_repository.dart';
import 'package:mycompany/schedule/model/schedule_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleView extends StatefulWidget {
  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  List<Appointment> scheduleList = <Appointment>[];
  List<CalendarResource> resource = <CalendarResource>[];
  bool isChk = false;
  CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
    _getDataSource();
    setState(() {});
  }

  _getDataSource() async {
    List<Appointment> schedules = await ScheduleFunctionReprository().getSheduleData(companyCode: "0S9YLBX");

    setState(() {
      scheduleList= schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      floatingActionButton: getMainCircularMenu(context: context, navigator: 'home'),
      body: RefreshIndicator(
        onRefresh: () => _getDataSource(),
        child: Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          width: double.infinity,
          height: double.infinity,
          child: SfCalendar(
            controller: _controller,
            showDatePickerButton: true,
            showNavigationArrow: true,
            dataSource: ScheduleModel(scheduleList),
            view: CalendarView.month,
            monthViewSettings: MonthViewSettings(
                appointmentDisplayMode:
                MonthAppointmentDisplayMode.appointment,
                appointmentDisplayCount: 5,
                showTrailingAndLeadingDates: false
              //showAgenda: true,
            ),

            todayHighlightColor: Colors.teal,
            onTap: (CalendarTapDetails details) => ScheduleFunctionReprository().getScheduleDetail(details: details, context: context),
          ),
        ),
      ),
    );
  }
}
