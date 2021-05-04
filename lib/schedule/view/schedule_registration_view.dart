import 'package:flutter/material.dart';
import 'package:mycompany/public/widget/main_menu.dart';

class ScheduleRegisrationView extends StatefulWidget {
  @override
  _ScheduleRegisrationViewState createState() => _ScheduleRegisrationViewState();
}

class _ScheduleRegisrationViewState extends State<ScheduleRegisrationView> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
      body: Container(
        padding: EdgeInsets.only(top: statusBarHeight),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Text("일정등록")
          ],
        ),
      ),
    );
  }
}
