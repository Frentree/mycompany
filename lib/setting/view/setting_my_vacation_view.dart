import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/function/vacation/vacation.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/model/work_model.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SettingMyVacationView extends StatefulWidget {

  @override
  SettingMyVacationViewState createState() => SettingMyVacationViewState();
}

class SettingMyVacationViewState extends State<SettingMyVacationView> {
  String? uploadImageUrl;
  bool companyVacation = false;
  late UserModel loginUser;

  DateFormatCustom dateFormatCustom = DateFormatCustom();
  DateTime now = DateTime.now();

  late ValueNotifier<DateTime> choiseDate = ValueNotifier<DateTime>(DateTime(now.year));

  @override
  void initState() {
    // TODO: implement initState
    loginUser = PublicFunction().getUserProviderSetting(context);
    _getSetting();
    super.initState();
  }

  _getSetting() async {
    CompanyModel company = await PublicFirebaseRepository().getVacation(companyCode: loginUser.companyCode!);
    companyVacation = company.vacation!;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    UserModel loginUser = userInfoProvider.getUserData()!;

    return Scaffold(
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
                color: Colors.white, boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.16), blurRadius: 3.0.h, offset: Offset(0.0, 1.0))]),
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
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    color: Color(0xff2093F0),
                  ),
                  SizedBox(
                    width: 14.7.w,
                  ),
                  Text(
                    "setting_menu_11".tr(),
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
              top: 29.0.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${now.year}년 연차 내역",
                  style: TextStyle(
                    fontSize: 15.0.sp,
                    color: Color(0xff2093F0),
                    fontWeight: fontWeight['Bold'],
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: PublicFirebaseRepository().getUserVacation(loginUser: loginUser),
            builder: (context, snapshot) {
              if(!snapshot.hasData){
                return Container();
              }
              EmployeeModel employeeUser = EmployeeModel.fromMap(mapData: (snapshot.data!.data() as dynamic), reference: snapshot.data!.reference);
              double totalVacation = TotalVacation(employeeUser.enteredDate!, companyVacation, employeeUser.vacation!.toDouble());
              return FutureBuilder(
                future: UsedVacation(loginUser.companyCode, loginUser.mail, employeeUser.enteredDate!, companyVacation),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container();
                  }
                  double useVacation = (snapshot.data as double);

                  List<ChartData> chartData = [
                    ChartData('사용 연차일', useVacation),
                    ChartData('남은 연차일', (totalVacation - useVacation)),
                  ];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          right: 27.5.w,
                          left: 27.5.w,
                        ),
                        child: SfCircularChart(
                          annotations: <CircularChartAnnotation>[
                            CircularChartAnnotation(
                            widget: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('총 연차일',
                                      style: getRobotoBold(fontSize: 12, color: textColor),
                                    ),
                                    Text('$totalVacation',
                                      style: getRobotoRegular(fontSize: 12, color: textColor),
                                    ),
                                  ],
                                )
                              ),
                            )
                          ],
                          series: <CircularSeries>[
                            DoughnutSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData sales, _) => sales.x,
                                yValueMapper: (ChartData sales, _) => sales.y,
                                dataLabelMapper: (ChartData data, _) => data.x.toString() + "\n" + data.y.toString(),

                                radius: '100%',
                                enableTooltip: true,
                                dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                )),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              );
            }
          ),
          Container(
            padding: EdgeInsets.only(
              top: 10.0.h,
            ),
            child: Divider(
              color: Color(0xffECECEC),
              thickness: 1.0.h,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: 20.0.h,
            ),
            child: Center(
              child: Text(
                "연간 연차 사용 내역",
                style: TextStyle(
                  fontSize: 15.0.sp,
                  fontWeight: fontWeight['Medium'],
                  color: textColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: choiseDate,
                builder: (BuildContext context, DateTime value, Widget? child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 21.0.h,
                      ),
                      child: Center(
                        child: SizedBox(
                          width: 194.0.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.arrow_back_ios_outlined,
                                ),
                                iconSize: 24.0.h,
                                splashRadius: 24.0.r,
                                onPressed: () {
                                  choiseDate.value = DateTime(choiseDate.value.year - 1);
                                },
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                                color: Color(0xff2093F0),
                                disabledColor: Color(0xff2093F0).withOpacity(0.2),
                              ),
                              Text(
                                "${choiseDate.value.year} 년",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14.0.sp,
                                  fontWeight: fontWeight['Medium'],
                                  color: Color(0xff2093F0),
                                ),
                              ),
                              IconButton(
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                ),
                                iconSize: 24.0.h,
                                splashRadius: 24.0.r,
                                onPressed: () {
                                  choiseDate.value = DateTime(choiseDate.value.year + 1);
                                },
                                padding: EdgeInsets.zero,
                                alignment: Alignment.centerLeft,
                                color: Color(0xff2093F0),
                                disabledColor: Color(0xff2093F0).withOpacity(0.2),
                              )
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
                                "타입",
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
                                "차감일",
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
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: PublicFirebaseRepository().usedVacation(loginUser: loginUser, time: choiseDate.value),
                          builder: (context, snapshot) {
                            if(!snapshot.hasData){
                              return Container();
                            }
                            List<DocumentSnapshot> docs = snapshot.data!.docs;

                            return ListView(
                              padding: EdgeInsets.all(0),
                              children: docs.map((doc) {
                                WorkModel workModel = WorkModel.fromMap(mapData: (doc.data() as dynamic), reference: doc.reference);

                                return Container(
                                  width: double.infinity,
                                  height: 42.0.h,
                                  padding: EdgeInsets.only(
                                    right: 27.5.w,
                                    left: 27.5.w,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                dateFormatCustom.getMonthAndDay(date: dateFormatCustom.changeTimestampToDateTime(timestamp: workModel.startTime)),
                                                style: getRobotoRegular(fontSize: 12, color: titleTextColor),
                                              ),
                                              Text(
                                                "~ ${dateFormatCustom.getMonthAndDay(date: dateFormatCustom.changeTimestampToDateTime(timestamp: workModel.endTime!))}",
                                                style: getRobotoRegular(fontSize: 12, color: outWorkColor),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Center(
                                        child: Text(
                                          "${workModel.type}",
                                          style: getRobotoRegular(fontSize: 12, color: textColor),
                                        ),
                                      )),
                                      Expanded(child: Center(
                                        child: Text(
                                          workModel.type == "연차" ? "${dateFormatCustom.changeTimestampToDateTime(timestamp: workModel.endTime!).add(Duration(hours: 9)).difference(dateFormatCustom.changeTimestampToDateTime(timestamp: workModel.startTime)).inDays + 1}"
                                          : "0.5",
                                          style: getRobotoRegular(fontSize: 12, color: textColor),
                                        ),
                                      )),
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          }
                      ),
                    )],
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);

  final String x;
  final double y;
  final Color? color;
}
