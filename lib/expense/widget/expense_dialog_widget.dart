import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/attendance/widget/attendance_dialog_widget.dart';
import 'package:mycompany/expense/db/expense_firestore_repository.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_picker_widget.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';
import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_theme.dart';

Future<dynamic> expenseReceiptWidget({required BuildContext context, required String? ImageUrl}) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          child: Container(
            width: 200.0.w,
            padding: EdgeInsets.symmetric(horizontal: 5.0.w, vertical: 5.0.h),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/icons/spinner.gif',
              placeholderScale: 9.0,
              image: ImageUrl.toString(),
            ),
          ),
        );
      });
}

Widget? showExpenseDataDetail({required BuildContext context, required ApprovalModel model, required loginUser}) {
  ExpenseFirebaseRepository expenseFirebaseRepository = ExpenseFirebaseRepository();
  DateFormatCustom _format = DateFormatCustom();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
        titlePadding: EdgeInsets.all(0),
        title: Container(),
        contentPadding: EdgeInsets.all(0),
        //contentPadding: EdgeInsets.only(top: 21.0.h, bottom: 5.0.h),
        content: Container(
          width: 313.0.w,
          height: 621.0.h,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 17.0.w, top: 21.0.h, bottom: 17.0.h, right: 23.1.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "경비 상세 내역",
                      style: getNotoSantBold(fontSize: 14.0, color: textColor),
                    ),
                    GestureDetector(
                      child: Container(
                        color: whiteColor,
                        width: 40.0.w,
                        height: 30.0.h,
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          'assets/icons/close.svg',
                          width: 13.17.w,
                          height: 13.17.h,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<ExpenseModel>>(
                  future: expenseFirebaseRepository.getExpenseData(loginUser: loginUser, mail: model.userMail, docsId: model.docIds!),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }

                    List<ExpenseModel> expenseList = snapshot.data!;

                    expenseList.sort((a, b) => b.buyDate.compareTo(a.buyDate));
                    return ListView(
                      children: expenseList.map((app) {
                        return Container(
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                                child: Container(
                                  height: 50.0.h,
                                  padding: EdgeInsets.only(left: 17.0.w, right: 17.0.w),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.all(Radius.circular(20.0.r))),
                                            width: 34.0.w,
                                            height: 19.0.h,
                                            child: Center(
                                              child: Text(
                                                app.contentType,
                                                style: getNotoSantRegular(fontSize: 10.0, color: whiteColor),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.0.w,
                                          ),
                                          Container(
                                            width: 130.0.w,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _format.getDate(date: _format.changeTimestampToDateTime(timestamp: app.buyDate)).toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  style: getNotoSantBold(fontSize: 12.0, color: textColor),
                                                ),
                                                Text(
                                                  "${app.cost}원",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                        visible: app.imageUrl != "",
                                        child: InkWell(
                                          child: SvgPicture.asset(
                                            'assets/icons/price.svg',
                                            width: 40.51.w,
                                            height: 23.37.h,
                                          ),
                                          onTap: () => expenseReceiptWidget(context: context, ImageUrl: app.imageUrl),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 2.0.h,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<DateTime> showExpenseDatePicker({required BuildContext context, required DateTime date}) async {
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
              child: DatePickerWidget(
                dateFormat: "yyyy MM dd",
                minDateTime: DateTime(1900),
                maxDateTime: DateTime(3000),
                onMonthChangeStartWithFirstDate: true,
                pickerTheme: DateTimePickerTheme(
                  pickerHeight: 200.0.h,
                  showTitle: true,
                ),
                locale: DateTimePickerLocale.ko,
                initialDateTime: date,
                onCancel: () {},
                onConfirm: (dateTime, selectedIndex) {
                  pickDate = dateTime;
                },
                onChange: (dateTime, selectedIndex) {},
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

Future<dynamic> insertExpensePhotoDialog({required BuildContext context}) {
  int? selectOption = 0;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0.r),
            ),
            child: Container(
              width: 232.0.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0.w,
                      vertical: 10.0.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff2093F0),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0.r),
                        topRight: Radius.circular(12.0.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "영수증 사진 첨부",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 13.0.sp,
                            fontWeight: fontWeight['Medium'],
                            color: whiteColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 13.0.w,
                            color: whiteColor,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          onPressed: () => backPage(context: context, returnValue: selectOption),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 8.0.h),
                    child: dialogRadioItem(
                      itemName: "사진 삭제",
                      groupValue: selectOption!,
                      value: 1,
                      onChanged: (int? value) {
                        setState(() {
                          selectOption = value;
                        });
                      },
                    ),
                  ),
                  dialogRadioItem(
                    itemName: "앨범에서 사진 선택",
                    groupValue: selectOption!,
                    value: 2,
                    onChanged: (int? value) {
                      setState(() {
                        selectOption = value;
                      });
                    },
                  ),
                  dialogRadioItem(
                    itemName: "카메라로 사진 찍기",
                    groupValue: selectOption!,
                    value: 3,
                    onChanged: (int? value) {
                      setState(() {
                        selectOption = value;
                      });
                    },
                  ),
                  attendanceDialogElevatedButton(
                      topPadding: 11.0.h,
                      buttonName: "확인",
                      buttonAction: selectOption == 0
                          ? null
                          : () {
                              backPage(
                                context: context,
                                returnValue: selectOption,
                              );
                            }),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
