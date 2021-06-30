import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/inquiry/view/inquiry_view.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_function_repository.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/model/public_comment_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/view/schedule_registration_view.dart';
import 'package:mycompany/schedule/view/schedule_view.dart';
import 'package:mycompany/schedule/widget/cirecular_button_item.dart';
import 'package:mycompany/schedule/widget/cirecular_button_menu.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';

getCommentsWidget(
    {required BuildContext context,
    required List<DocumentSnapshot> docs,
    required List<EmployeeModel> employeeList,
    required TextEditingController commentTextController,
    required ValueNotifier<CommentModel?> commentValue}) {
  var list = <Widget>[
    Container(
      width: 16.w,
    )
  ];

  UserModel loginUser = PublicFunction().getUserProviderSetting(context);
  DateFormatCustom _formatCustom = DateFormatCustom();

  docs.sort((a, b) => a.get("createDate").compareTo(b.get("createDate")));

  for (var doc in docs) {
    final model = CommentModel.fromMap(mapData: (doc.data() as dynamic), reference: doc.reference);

    EmployeeModel user = employeeList.where((element) => element.mail == model.uid).first;
    if (model.level == 0) {
      list.add(Container(
        padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 8.0.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getProfileImage(size: 35.0, ImageUri: user.profilePhoto),
                SizedBox(
                  width: 5.0.w,
                ),
                Container(
                  width: 55.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                      ),
                      Text(
                        "${user.position} / ${user.team}",
                        overflow: TextOverflow.ellipsis,
                        style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            width: 150.0.w,
                            padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 5.0.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0.r),
                              ),
                              color: Color(0xffC4C4C4).withOpacity(0.1),
                            ),
                            child: Text(
                              model.comment,
                              style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                            )),
                        SizedBox(
                          width: 5.0.w,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 3.0.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0.r),
                            ),
                            color: workInsertColor,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                  child: Icon(
                                    Icons.arrow_forward_outlined,
                                    color: whiteColor,
                                    size: 15.w,
                                  ),
                                  onTap: () {
                                    commentTextController.text = "@" + model.uname + " ";
                                    commentValue.value = model;
                                  }),
                              Visibility(
                                visible: loginUser.mail == user.mail,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5.0.w,
                                    ),
                                    InkWell(
                                        child: Icon(
                                          Icons.delete,
                                          color: whiteColor,
                                          size: 15.w,
                                        ),
                                        onTap: () => loginDialogWidget(context: context, message: "notice_detail_view_dialog_1".tr(), actions: [
                                              confirmElevatedButton(
                                                  topPadding: 81.0.h,
                                                  buttonName: "dialogConfirm".tr(),
                                                  buttonAction: () async {
                                                    await model.reference!.delete();
                                                    Navigator.pop(context);
                                                  },
                                                  customWidth: 80.0,
                                                  customHeight: 40.0),
                                              confirmElevatedButton(
                                                  topPadding: 81.0.h,
                                                  buttonName: "dialogCancel".tr(),
                                                  buttonAction: () => Navigator.pop(context, false),
                                                  customWidth: 80.0,
                                                  customHeight: 40.0),
                                            ])),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      "${_formatCustom.dateTimeFormat(date: _formatCustom.changeTimestampToDateTime(timestamp: model.createDate!))}",
                      style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ));
    } else {
      list.add(Container(
        padding: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 8.0.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getProfileImage(size: 35.0, ImageUri: user.profilePhoto),
                SizedBox(
                  width: 5.0.w,
                ),
                Container(
                  width: 55.0.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: getNotoSantMedium(fontSize: 12.0, color: textColor),
                      ),
                      Text(
                        "${user.position} / ${user.team}",
                        overflow: TextOverflow.ellipsis,
                        style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            width: 150.0.w,
                            padding: EdgeInsets.symmetric(vertical: 6.0.h, horizontal: 5.0.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0.r),
                              ),
                              color: Color(0xffC4C4C4).withOpacity(0.1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${model.upUname} 님에게 답글",
                                  maxLines: 1,
                                  style: getNotoSantBold(fontSize: 9.0, color: textColor),
                                ),
                                Text(
                                  model.upComment!,
                                  maxLines: 4,
                                  style: getNotoSantRegular(fontSize: 9.0, color: textColor),
                                ),
                                SizedBox(
                                  height: 3.0.h,
                                ),
                                Container(
                                  width: 150.w,
                                  height: 0.7.h,
                                  color: blackColor.withOpacity(0.3),
                                ),
                                SizedBox(
                                  height: 3.0.h,
                                ),
                                Text(
                                  model.comment,
                                  style: getNotoSantRegular(fontSize: 12.0, color: textColor),
                                ),
                              ],
                            )),
                        SizedBox(
                          width: 5.0.w,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2.0.h, horizontal: 3.0.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6.0.r),
                            ),
                            color: workInsertColor,
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                  child: Icon(
                                    Icons.arrow_forward_outlined,
                                    color: whiteColor,
                                    size: 15.w,
                                  ),
                                  onTap: () {
                                    commentTextController.text = "@" + model.uname + " ";
                                    commentValue.value = model;
                                    /*     setState(() {

                                        });*/
                                  }),
                              Visibility(
                                visible: loginUser.mail == user.mail,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5.0.w,
                                    ),
                                    InkWell(
                                        child: Icon(
                                          Icons.delete,
                                          color: whiteColor,
                                          size: 15.w,
                                        ),
                                        onTap: () => loginDialogWidget(context: context, message: "notice_detail_view_dialog_1".tr(), actions: [
                                              confirmElevatedButton(
                                                  topPadding: 81.0.h,
                                                  buttonName: "dialogConfirm".tr(),
                                                  buttonAction: () async {
                                                    await model.reference!.delete();
                                                    Navigator.pop(context);
                                                  },
                                                  customWidth: 80.0,
                                                  customHeight: 40.0),
                                              confirmElevatedButton(
                                                  topPadding: 81.0.h,
                                                  buttonName: "dialogCancel".tr(),
                                                  buttonAction: () => Navigator.pop(context),
                                                  customWidth: 80.0,
                                                  customHeight: 40.0),
                                            ])),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      "${_formatCustom.dateTimeFormat(date: _formatCustom.changeTimestampToDateTime(timestamp: model.createDate!))}",
                      style: getNotoSantMedium(fontSize: 8.0, color: hintTextColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ));
    }
  }
  return list;
}

PublicFunctionRepository _reprository = PublicFunctionRepository();

Widget getMainCircularMenu({required BuildContext context, required ValueNotifier<bool> isMenu, required GlobalKey<CircularMenuState> key}) {
  return ValueListenableBuilder(
      valueListenable: isMenu,
      builder: (context, bool value, child) {
        return CircularMenu(
            key: key,
            alignment: Alignment.bottomRight,
            radius: 170.0,
            toggleButtonColor: workInsertColor,
            backgroundWidget: !value
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: blackColor.withOpacity(0.7),
                    child: InkWell(
                      onTap: () {
                        isMenu.value = true;
                        key.currentState!.reverseAnimation();
                      },
                    ),
                  )
                : Container(),
            toggleButtonBoxShadow: [BoxShadow(color: Colors.black)],
            toggleChk: (val) {
              isMenu.value = val;
            },
            items: [
              CircularMenuItem(
                  icon: Icons.home,
                  boxShadow: [BoxShadow(color: Colors.black)],
                  color: workInsertColor,
                  onTap: () => _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false)),
              CircularMenuItem(
                  icon: Icons.schedule,
                  boxShadow: [BoxShadow(color: Colors.black)],
                  color: workInsertColor,
                  onTap: () => _reprository.mainNavigator(context: context, navigator: ScheduleRegisrationView(), isMove: false)),
              CircularMenuItem(
                  icon: Icons.youtube_searched_for,
                  boxShadow: [BoxShadow(color: Colors.black)],
                  color: workInsertColor,
                  onTap: () => _reprository.mainNavigator(context: context, navigator: InquiryView(), isMove: false)),
              CircularMenuItem(
                  icon: Icons.star,
                  boxShadow: [BoxShadow(color: Colors.black)],
                  color: workInsertColor,
                  onTap: () => _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false)),
              CircularMenuItem(
                  icon: Icons.settings,
                  boxShadow: [BoxShadow(color: Colors.black)],
                  color: workInsertColor,
                  onTap: () => _reprository.mainNavigator(context: context, navigator: ScheduleView(), isMove: false)),
            ]);
      });
}
