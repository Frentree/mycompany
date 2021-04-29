import 'package:flutter/material.dart';
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
  }

  _getDataSource() async {
    List<Appointment> schedules = await ScheduleFunctionReprository().getSheduleData(companyCode: "0S9YLBX");

    setState(() {
      scheduleList= schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _getDataSource(),
        child: Container(
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
            onTap: (CalendarTapDetails details) {
              dynamic appointment = details.appointments;
              //DateTime date = details.date;
              //CalendarElement element = details.targetElement; //  달력 요소
              if(appointment != null){
                //showDialogCalender(context, appointment, date);
                /*if(pickDate != date) {
                    pickDate = date;
                  } else {
                  }*/
              }
            },
          ),
        ),
      ),
    );
  }
}
