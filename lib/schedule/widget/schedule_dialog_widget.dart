

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_widget.dart';

class ScheduleDialogWidget {
  DateFormatCustom _format = DateFormatCustom();

  Widget? showScheduleDetail({required BuildContext context,required List<dynamic> data,required DateTime date}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                _format.dateFormat(date: date) + " 일정",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      /*Navigator.pop(context);
                      Navigator.push(context,  MaterialPageRoute(
                        builder: (context) => ViewSchedules(date: date,),
                      ),);*/
                    },
                  ),
                ),
              )
            ],
          ),
          contentPadding: EdgeInsets.only(top: 20, bottom: 20),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2,
            child: ListView(
              children: data.map((e) => Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: e.color,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          e.subject + " " + e.startTime.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                        Text(
                          e.notes.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ),
                        e.location != '' ? Text(
                          e.location.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  )
                ],
              )).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime> showDatePicker({required BuildContext context, required DateTime date}) async {
    DateTime pickDate = date;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 20, bottom: 20),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: 270.0.h,
            child: Center(
              child: DateTimePickerWidget(
                minDateTime: DateTime.parse('1900-01-01'),
                dateFormat: 'yyyy년 MM월 dd일 HH시 mm분',
                locale: DateTimePickerLocale.ko,
                initDateTime: date,

                onConfirm: (dateTime, selectedIndex) {
                  pickDate = dateTime;
                },
                onChange: (dateTime, selectedIndex) {
                },
                onCancel: () {
                },
              ),
            )

            /*CupertinoDatePicker(
              minimumYear: 1900,
              mode: CupertinoDatePickerMode.time,
              initialDateTime: date,
              onDateTimeChanged: (value) {

              },
            ),*/
          ),
        );

      },

    );
    return pickDate;
  }
}