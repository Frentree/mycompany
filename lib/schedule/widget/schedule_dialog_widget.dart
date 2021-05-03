

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleDialogWidget {
  DateFormat _format = DateFormat();

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

}