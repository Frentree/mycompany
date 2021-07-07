import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/db/public_firestore_repository.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/login/function/form_validation_function.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/setting/model/grade_model.dart';

/* 조직도 관련 다이얼로그 시작 */
Future<bool> addTeamDialog(BuildContext context, String companyCode, TextEditingController teamNameContoller) async {
  PublicFirebaseReository _publicFirebaseReository = PublicFirebaseReository();
  bool result = false;
  teamNameContoller.text = "";
  await loginDialogWidget(
    context: context,
    message: "team_setting_dialog_1".tr(),
    actions: [
      Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            TextFormField(
                controller: teamNameContoller,
                decoration: InputDecoration(
                  hintText: "team_setting_dialog_2".tr(),
                  hintStyle: getNotoSantRegular(
                    fontSize: 12.0,
                    color: hintTextColor,
                  ),
                ),
                style: getNotoSantRegular(fontSize: 12.0, color: textColor)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogConfirm".tr(),
                    buttonAction: () async {
                      if (teamNameContoller.text.trim() == "") {
                        return;
                      }

                      TeamModel model = TeamModel(teamName: teamNameContoller.text);
                      result = await _publicFirebaseReository.createTeam(companyCode: companyCode, team: model);
                      teamNameContoller.text = "";
                      Navigator.pop(context, true);
                    },
                    customWidth: 70.0,
                    customHeight: 40.0),
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogCancel".tr(),
                    buttonAction: () => Navigator.pop(context, false),
                    customWidth: 70.0,
                    customHeight: 40.0),
              ],
            )
          ],
        ),
      )
    ],
  );
  return result;
}

Future<bool> addTeamUserDialog(BuildContext context, TeamModel model, List<EmployeeModel> employeeList, List<EmployeeModel> list) async {
  bool result = false;
  List<EmployeeModel> getUserList = List.from(employeeList);

  List<EmployeeModel> userChkList = [];

  list.map((data) => getUserList.remove(data)).toList();

  await loginDialogWidget(context: context, message: "team_menu_2".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          Container(
            height: 230.0.h,
            child: ListView.builder(
              itemCount: getUserList.length,
              itemBuilder: (context, index) {
                ValueNotifier<bool> isChks = ValueNotifier<bool>(false);

                return ValueListenableBuilder(
                  valueListenable: isChks,
                  builder: (context, bool value, child) {
                    return InkWell(
                      child: Container(
                        width: 100.0.w,
                        height: 50.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getProfileImage(
                                  size: 36,
                                  ImageUri: getUserList[index].profilePhoto.toString(),
                                ),
                                SizedBox(
                                  width: 6.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getUserList[index].name,
                                      style: getNotoSantBold(fontSize: 14.0, color: textColor),
                                    ),
                                    Text(
                                      getUserList[index].position! + " / " + getUserList[index].team!,
                                      style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 18.0.w,
                              height: 18.0.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                                shape: BoxShape.circle,
                                color: value ? workInsertColor : whiteColor,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.check,
                                size: 16.0.w,
                                color: whiteColor,
                              )),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        isChks.value = !value;
                        if (isChks.value) {
                          userChkList.add(getUserList[index]);
                        } else {
                          userChkList.remove(getUserList[index]);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    await userChkList.map((e) => e.reference!.update({"team": model.teamName, "teamNum": model.teamNum})).toList();
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<bool> deleteTeamUserDialog(BuildContext context, List<EmployeeModel> list) async {
  bool result = false;
  List<EmployeeModel> userChkList = [];

  await loginDialogWidget(context: context, message: "team_menu_4".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          Container(
            height: 220.0.h,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                ValueNotifier<bool> isChks = ValueNotifier<bool>(false);

                return ValueListenableBuilder(
                  valueListenable: isChks,
                  builder: (context, bool value, child) {
                    return InkWell(
                      child: Container(
                        width: 100.0.w,
                        height: 50.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getProfileImage(
                                  size: 36,
                                  ImageUri: list[index].profilePhoto.toString(),
                                ),
                                SizedBox(
                                  width: 6.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index].name,
                                      style: getNotoSantBold(fontSize: 14.0, color: textColor),
                                    ),
                                    Text(
                                      list[index].position! + " / " + list[index].team!,
                                      style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 18.0.w,
                              height: 18.0.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                                shape: BoxShape.circle,
                                color: value ? workInsertColor : whiteColor,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.check,
                                size: 16.0.w,
                                color: whiteColor,
                              )),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        isChks.value = !value;
                        if (isChks.value) {
                          userChkList.add(list[index]);
                        } else {
                          userChkList.remove(list[index]);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    await userChkList.map((e) => e.reference!.update({"team": "", "teamNum": 999})).toList();
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<bool> updateTeamNameDialog(BuildContext context, TeamModel model, TextEditingController teamNameContoller, List<EmployeeModel> list) async {
  bool result = false;
  teamNameContoller.text = model.teamName;
  await loginDialogWidget(context: context, message: "team_setting_dialog_5".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 5.0.h,
          ),
          TextFormField(
              controller: teamNameContoller,
              decoration: InputDecoration(
                hintText: "team_setting_dialog_2".tr(),
                hintStyle: getNotoSantRegular(
                  fontSize: 12.0,
                  color: hintTextColor,
                ),
              ),
              style: getNotoSantRegular(fontSize: 12.0, color: textColor)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    if (teamNameContoller.text.trim() == "") {
                      return;
                    }
                    for (var data in list) {
                      data.reference!.update({"team": teamNameContoller.text});
                    }
                    model.reference!.update({"teamName": teamNameContoller.text});

                    teamNameContoller.text = "";
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<bool> deleteTeamDialog(BuildContext context, TeamModel model, List<EmployeeModel> list) async {
  bool result = false;
  await loginDialogWidget(context: context, message: "team_setting_dialog_3".tr(), actions: [
    confirmElevatedButton(
        topPadding: 81.0.h,
        buttonName: "dialogConfirm".tr(),
        buttonAction: () async {
          for (var data in list) {
            data.reference!.update({"team": "", "teamNum": 999});
          }
          model.reference!.delete();
          result = true;
          Navigator.pop(context, true);
        },
        customWidth: 80.0,
        customHeight: 40.0),
    confirmElevatedButton(
        topPadding: 81.0.h,
        buttonName: "dialogCancel".tr(),
        buttonAction: () => Navigator.pop(context, false),
        customWidth: 80.0,
        customHeight: 40.0),
  ]);
  return result;
}

/* 조직도 관련 다이얼로그 끝 */

/* 직급 관련 다이얼로그 시작 */
Future<bool> addPositionDialog(BuildContext context, String companyCode, TextEditingController positionNameController) async {
  PublicFirebaseReository _publicFirebaseReository = PublicFirebaseReository();
  bool result = false;
  positionNameController.text = "";
  await loginDialogWidget(
    context: context,
    message: "position_setting_dialog_1".tr(),
    actions: [
      Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            TextFormField(
                controller: positionNameController,
                decoration: InputDecoration(
                  hintText: "position_setting_dialog_2".tr(),
                  hintStyle: getNotoSantRegular(
                    fontSize: 12.0,
                    color: hintTextColor,
                  ),
                ),
                style: getNotoSantRegular(fontSize: 12.0, color: textColor)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogConfirm".tr(),
                    buttonAction: () async {
                      if (positionNameController.text.trim() == "") {
                        return;
                      }

                      PositionModel model = PositionModel(position: positionNameController.text);
                      result = await _publicFirebaseReository.createPosition(companyCode: companyCode, position: model);
                      positionNameController.text = "";
                      Navigator.pop(context, true);
                    },
                    customWidth: 70.0,
                    customHeight: 40.0),
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogCancel".tr(),
                    buttonAction: () => Navigator.pop(context, false),
                    customWidth: 70.0,
                    customHeight: 40.0),
              ],
            )
          ],
        ),
      )
    ],
  );
  return result;
}

Future<bool> addPositionUserDialog(BuildContext context, PositionModel model, List<EmployeeModel> employeeList, List<EmployeeModel> list) async {
  bool result = false;
  List<EmployeeModel> getUserList = List.from(employeeList);

  List<EmployeeModel> userChkList = [];

  list.map((data) => getUserList.remove(data)).toList();

  await loginDialogWidget(context: context, message: "position_menu_2".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          Container(
            height: 230.0.h,
            child: ListView.builder(
              itemCount: getUserList.length,
              itemBuilder: (context, index) {
                ValueNotifier<bool> isChks = ValueNotifier<bool>(false);

                return ValueListenableBuilder(
                  valueListenable: isChks,
                  builder: (context, bool value, child) {
                    return InkWell(
                      child: Container(
                        width: 100.0.w,
                        height: 50.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getProfileImage(
                                  size: 36,
                                  ImageUri: getUserList[index].profilePhoto.toString(),
                                ),
                                SizedBox(
                                  width: 6.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getUserList[index].name,
                                      style: getNotoSantBold(fontSize: 14.0, color: textColor),
                                    ),
                                    Text(
                                      getUserList[index].position! + " / " + getUserList[index].team!,
                                      style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 18.0.w,
                              height: 18.0.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                                shape: BoxShape.circle,
                                color: value ? workInsertColor : whiteColor,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.check,
                                size: 16.0.w,
                                color: whiteColor,
                              )),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        isChks.value = !value;
                        if (isChks.value) {
                          userChkList.add(getUserList[index]);
                        } else {
                          userChkList.remove(getUserList[index]);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    await userChkList.map((e) => e.reference!.update({"position": model.position, "positionNum": model.positionNum})).toList();
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<bool> deletePositionUserDialog(BuildContext context, List<EmployeeModel> list) async {
  bool result = false;
  List<EmployeeModel> userChkList = [];

  await loginDialogWidget(context: context, message: "position_menu_4".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          Container(
            height: 220.0.h,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                ValueNotifier<bool> isChks = ValueNotifier<bool>(false);

                return ValueListenableBuilder(
                  valueListenable: isChks,
                  builder: (context, bool value, child) {
                    return InkWell(
                      child: Container(
                        width: 100.0.w,
                        height: 50.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getProfileImage(
                                  size: 36,
                                  ImageUri: list[index].profilePhoto.toString(),
                                ),
                                SizedBox(
                                  width: 6.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index].name,
                                      style: getNotoSantBold(fontSize: 14.0, color: textColor),
                                    ),
                                    Text(
                                      list[index].position! + " / " + list[index].team!,
                                      style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 18.0.w,
                              height: 18.0.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                                shape: BoxShape.circle,
                                color: value ? workInsertColor : whiteColor,
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.check,
                                size: 16.0.w,
                                color: whiteColor,
                              )),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        isChks.value = !value;
                        if (isChks.value) {
                          userChkList.add(list[index]);
                        } else {
                          userChkList.remove(list[index]);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    await userChkList.map((e) => e.reference!.update({"position": "", "positionNum": 999})).toList();
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<bool> updatePositionNameDialog(
    BuildContext context, PositionModel model, TextEditingController positionNameController, List<EmployeeModel> list) async {
  bool result = false;
  positionNameController.text = model.position;
  await loginDialogWidget(context: context, message: "position_setting_dialog_5".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 5.0.h,
          ),
          TextFormField(
              controller: positionNameController,
              decoration: InputDecoration(
                hintText: "position_setting_dialog_2".tr(),
                hintStyle: getNotoSantRegular(
                  fontSize: 12.0,
                  color: hintTextColor,
                ),
              ),
              style: getNotoSantRegular(fontSize: 12.0, color: textColor)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    if (positionNameController.text.trim() == "") {
                      return;
                    }
                    for (var data in list) {
                      data.reference!.update({"position": positionNameController.text});
                    }
                    model.reference!.update({"position": positionNameController.text});

                    positionNameController.text = "";
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<bool> deletePositionDialog(BuildContext context, PositionModel model, List<EmployeeModel> list) async {
  bool result = false;
  await loginDialogWidget(context: context, message: "position_setting_dialog_3".tr(), actions: [
    confirmElevatedButton(
        topPadding: 81.0.h,
        buttonName: "dialogConfirm".tr(),
        buttonAction: () async {
          for (var data in list) {
            data.reference!.update({"position": "", "positionNum": 999});
          }
          model.reference!.delete();
          result = true;
          Navigator.pop(context, true);
        },
        customWidth: 80.0,
        customHeight: 40.0),
    confirmElevatedButton(
        topPadding: 81.0.h,
        buttonName: "dialogCancel".tr(),
        buttonAction: () => Navigator.pop(context, false),
        customWidth: 80.0,
        customHeight: 40.0),
  ]);
  return result;
}

Future<bool> priorityPositionDialog(BuildContext context, List<PositionModel> positionList) async {
  bool result = false;

  List<PositionModel> positions = List.from(positionList);

  ValueNotifier<List<PositionModel>> positionValue = ValueNotifier<List<PositionModel>>(positionList);

  await loginDialogWidget(context: context, message: "position_setting_dialog_7".tr(), actions: [
    StatefulBuilder(builder: (context, setState) {
      return Expanded(
        child: Column(
          children: [
            Container(
              height: 220.0.h,
              child: ListView.builder(
                itemCount: positions.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Container(
                      width: 100.0.w,
                      height: 41.0.h,
                      padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            positions[index].position,
                            style: getNotoSantBold(fontSize: 14.0, color: textColor),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: 30.0.w,
                                  color: whiteColor.withOpacity(0),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow_up.svg',
                                      width: 24.0.w,
                                      height: 24.0.h,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if ((index - 1) >= 0) {
                                    PositionModel position = positions[index];
                                    positions.remove(position);
                                    positions.insert((index - 1), position);
                                  }
                                  setState(() {});
                                },
                              ),
                              SizedBox(
                                width: 10.0.w,
                              ),
                              GestureDetector(
                                child: Container(
                                  width: 30.0.w,
                                  color: whiteColor.withOpacity(0),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/arrow_down.svg',
                                      width: 24.0.w,
                                      height: 24.0.h,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  if ((index + 1) < positions.length) {
                                    PositionModel position = positions[index];
                                    positions.remove(position);
                                    positions.insert((index + 1), position);
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 5.0.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                confirmElevatedButton(
                    topPadding: 30.0.h,
                    buttonName: "dialogConfirm".tr(),
                    buttonAction: () async {
                      for(int i = 0; i < positions.length; i ++){
                        positions[i].reference!.update({"positionNum" : i });
                      }
                      result = true;
                      Navigator.pop(context, true);
                    },
                    customWidth: 70.0,
                    customHeight: 40.0),
                confirmElevatedButton(
                    topPadding: 30.0.h,
                    buttonName: "dialogCancel".tr(),
                    buttonAction: () => Navigator.pop(context, false),
                    customWidth: 70.0,
                    customHeight: 40.0),
              ],
            )
          ],
        ),
      );
    })
  ]);
  return result;
}

/* 직급 관련 다이얼로그 종료 */

/* 내정보 관련 다이얼로그 시작 */
Future<dynamic> changeProfileDialog({required BuildContext context}) {
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
                          "프로필 사진 변경",
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
                      itemName: "프로필 사진 삭제",
                      groupValue: selectOption!,
                      value: 1,
                      onChanged: (int? value) {
                        setState((){
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
                      setState((){
                        selectOption = value;
                      });
                    },
                  ),
                  dialogRadioItem(
                    itemName: "카메라로 사진 찍기",
                    groupValue: selectOption!,
                    value: 3,
                    onChanged: (int? value) {
                      setState((){
                        selectOption = value;
                      });
                    },
                  ),
                  attendanceDialogElevatedButton(
                      topPadding: 11.0.h,
                      buttonName: "확인",
                      buttonAction: selectOption == 0 ? null : (){
                        backPage(context: context, returnValue: selectOption,);
                      }
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Container dialogRadioItem(
    {required String itemName,
      required int groupValue,
      required int value,
      required ValueChanged<int?> onChanged}) {
  return Container(
    padding: EdgeInsets.only(
      left: 16.0.w,
      right: 16.0.w,
    ),
    color: groupValue == value ? Color(0xff2093F0).withOpacity(0.1) : null,
    child: RadioListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(
        itemName,
        style: TextStyle(
          fontSize: 13.0.sp,
          fontWeight: fontWeight["Medium"],
          color: textColor,
        ),
      ),
      value: value,
      onChanged: onChanged,
      groupValue: groupValue,
      controlAffinity: ListTileControlAffinity.trailing,
    ),
  );
}

Future<dynamic> selectBankDialog({required BuildContext context}) {
  List<String> bankList = [
    "선택안함", "NH농협", "KB국민", "신한", "우리",
    "하나", "IBK기업", "SC제일", "씨티", "KDB산업",
    "SBI처축은행", "새마을", "대구", "광주", "우체국",
    "신협", "전북", "경남", "부산", "수협",
    "제주", "저축은행", "산림조합", "케이뱅크", "카카오뱅크",
    "HSBC", "중국공상", "JP모간", "도이치", "BNP파리바",
    "BOA", "중국건설", "토스증권", "키움", "KB증권",
    "미래에셋대우", "삼성", "NH투자", "유안타", "대신",
    "한국투자", "신한금융투자", "유진투자", "한화투자", "DB금융투자",
    "하나금융", "하이투자", "현대차증권", "신영", "이베스트",
    "교보", "메리츠증권", "KTB투자", "SK", "부국",
    "케이프투자", "한국포스증권", "카카오페이증권"
  ];

  return showDialog(
      context: context,
      builder: (BuildContext context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0.r),
          ),
          child: Container(
            width: 232.0.w,
            child: Column(
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
                        "은행 선택",
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
                        onPressed: () => backPage(context: context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.only(
                      left: 16.0.w,
                      right: 16.0.w,
                      top: 20.0.h,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: bankList.length,
                    itemBuilder: (BuildContext context, int index){
                      return GridTile(
                        child: GestureDetector(
                          onTap: (){
                            backPage(context: context, returnValue: bankList[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff2093F0).withOpacity(0.1)
                              ),
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12.0.r),
                            ),
                            child: Center(
                              child: Text(
                                bankList[index],
                                style: TextStyle(
                                  fontSize: 13.0.sp,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        );
      }
  );
}

Future<dynamic> oldPasswordConfirmDialog({required BuildContext context, required UserModel userModel}) {
  LoginServiceRepository loginServiceRepository = LoginServiceRepository();

  TextEditingController _oldPasswordTextController = TextEditingController();

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
                          "현재 비밀번호 확인",
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
                          onPressed: () => backPage(context: context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 8.0.h,
                      left: 16.0.w,
                      right: 16.0.w,
                    ),
                    child: SizedBox(
                      height: 40.0.h,
                      child: TextFormField(
                        obscureText: true,
                        controller: _oldPasswordTextController,
                        decoration: loginTextFormRoundBorderDecoration(
                          hintText: "현재 비밀번호 입력",
                        ),
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),

                  attendanceDialogElevatedButton(
                      topPadding: 11.0.h,
                      buttonName: "확인",
                      buttonAction: () async {
                        bool result = await loginServiceRepository.passwordConfirm(email: userModel.mail, password: _oldPasswordTextController.text);
                        if(result == false){
                          await loginDialogWidget(
                              context: context,
                              message: "비밀번호가 틀립니다\n다시 입력해주세요.",
                              actions: [
                                loginDialogConfirmButton(
                                    buttonName: 'dialogConfirm'.tr(),
                                    buttonAction: () {
                                      backPage(context: context);
                                    }
                                ),
                              ]
                          );
                        }
                        else {
                          backPage(context: context, returnValue: true);
                        }
                      }
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Future<dynamic> changePasswordDialog({required BuildContext context}) {
  LoginServiceRepository loginServiceRepository = LoginServiceRepository();
  FormValidationFunction formValidationFunction = FormValidationFunction();

  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _confirmPasswordFormKey = GlobalKey<FormState>();

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();

  ValueNotifier<List<bool>> isFormValid = ValueNotifier<List<bool>>([false, false]);
  ValueNotifier<String> passwordErrorMessage = ValueNotifier<String>("");
  ValueNotifier<String> confirmPasswordErrorMessage = ValueNotifier<String>("");

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
                          "비밀번호 변경",
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
                          onPressed: () => backPage(context: context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 8.0.h,
                      left: 16.0.w,
                      right: 16.0.w,
                    ),
                    child: ValueListenableBuilder(
                        valueListenable: passwordErrorMessage,
                        builder: (BuildContext context, String value, Widget? child) {
                          return Form(
                            key: _passwordFormKey,
                            onChanged: (){
                              _passwordFormKey.currentState!.validate();
                              _confirmPasswordFormKey.currentState!.validate();

                              if(passwordErrorMessage.value != ""){
                                isFormValid.value = List.from(isFormValid.value)..replaceRange(0, 1, [false]);
                              }
                              else {
                                isFormValid.value = List.from(isFormValid.value)..replaceRange(0, 1, [true]);
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40.0.h,
                                  child: TextFormField(
                                    controller: _passwordTextController,
                                    obscureText: true,
                                    maxLength: 20,
                                    validator: ((text) {
                                      String? result = formValidationFunction.formValidationFunction(
                                        type: "password",
                                        value: text!,
                                      );
                                      if(result != null){
                                        passwordErrorMessage.value = result;
                                      }
                                      else{
                                        passwordErrorMessage.value = "";
                                      }
                                    }),
                                    decoration: loginTextFormRoundBorderDecoration(
                                      hintText: "새 비밀번호 입력",
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: passwordErrorMessage.value != "",
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0.w),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: errorTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 8.0.h,
                      left: 16.0.w,
                      right: 16.0.w,
                    ),
                    child: ValueListenableBuilder(
                        valueListenable: confirmPasswordErrorMessage,
                        builder: (BuildContext context, String value, Widget? child) {
                          return Form(
                            key: _confirmPasswordFormKey,
                            onChanged: (){
                              _confirmPasswordFormKey.currentState!.validate();
                              if(confirmPasswordErrorMessage.value != ""){
                                isFormValid.value = List.from(isFormValid.value)..replaceRange(1, 2, [false]);
                              }
                              else {
                                isFormValid.value = List.from(isFormValid.value)..replaceRange(1, 2, [true]);
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 40.0.h,
                                  child: TextFormField(
                                    controller: _confirmPasswordTextController,
                                    obscureText: true,
                                    maxLength: 20,
                                    validator: ((text) {
                                      String? result = formValidationFunction.formValidationFunction(
                                        type: "confirmPassword",
                                        value: text!,
                                        value2: _passwordTextController,
                                      );
                                      if(result != null){
                                        confirmPasswordErrorMessage.value = result;
                                      }
                                      else{
                                        confirmPasswordErrorMessage.value = "";
                                      }
                                    }),
                                    decoration: loginTextFormRoundBorderDecoration(
                                      hintText: "새 비밀번호 확인",
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: confirmPasswordErrorMessage.value != "",
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 12.0.w),
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 12.0.sp,
                                        color: errorTextColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: isFormValid,
                    builder: (BuildContext context, List<bool> value, Widget? child){
                      return attendanceDialogElevatedButton(
                        topPadding: 11.0.h,
                        buttonName: "확인",
                        buttonAction: value.contains(false) ? null : () async {
                          bool result = await loginServiceRepository.changePassword(password: _passwordTextController.text);
                          backPage(context: context, returnValue: result);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


/* 입사일 변경 */
Future<bool> enteredDateUpdateDialog(BuildContext context, EmployeeModel employeeModel) async {
  bool result = false;
  TextEditingController enteredDateController = MaskedTextController(mask: '0000.00.00');
  enteredDateController.text = employeeModel.enteredDate ?? "";

  await loginDialogWidget(
    context: context,
    message: "vacation_dialog_2".tr(),
    actions: [
      Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            TextFormField(
                keyboardType: TextInputType.number,
                controller: enteredDateController,
                decoration: InputDecoration(
                  hintText: "vacation_setting_dialog_2".tr(),
                  hintStyle: getNotoSantRegular(
                    fontSize: 12.0,
                    color: hintTextColor,
                  ),
                ),
                style: getNotoSantRegular(fontSize: 12.0, color: textColor)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogConfirm".tr(),
                    buttonAction: () async {
                      employeeModel.reference!.update({
                        "enteredDate" : enteredDateController.text,
                      });
                      Navigator.pop(context, true);
                    },
                    customWidth: 70.0,
                    customHeight: 40.0),
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogCancel".tr(),
                    buttonAction: () => Navigator.pop(context, false),
                    customWidth: 70.0,
                    customHeight: 40.0),
              ],
            )
          ],
        ),
      )
    ],
  );
  return result;
}

/* 연차일 변경 */
Future<bool> addAnnualUpdateDialog(BuildContext context, EmployeeModel employeeModel) async {
  bool result = false;
  TextEditingController annualController = TextEditingController();
  annualController.text = "0";
  List<int> count = [-5, -3, -1, 1, 3, 5];

  await loginDialogWidget(
    context: context,
    message: "vacation_dialog_1".tr(),
    actions: [
      Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            TextFormField(
                keyboardType: TextInputType.number,
                controller: annualController,
                decoration: InputDecoration(
                  hintText: "vacation_setting_dialog_1".tr(),
                  hintStyle: getNotoSantRegular(
                    fontSize: 12.0,
                    color: hintTextColor,
                  ),
                ),
                style: getNotoSantRegular(fontSize: 12.0, color: textColor)
            ),
            SizedBox(
              height: 10.0.h,
            ),
            Row(
              children: count.map((e) =>
                  InkWell(
                    child: Card(
                      child: Container(
                        width: 27.0.w,
                        height: 25.0.h,
                        child: Center(
                          child: Text(e.toString(),
                            style: getRobotoMedium(fontSize: 11, color: textColor),
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      var annualCount = int.parse(annualController.text.toString()) + e;
                      annualController.text = annualCount.toString();
                    },
                  ),
              ).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogConfirm".tr(),
                    buttonAction: () async {
                      employeeModel.reference!.update({
                        "vacation" : FieldValue.increment(int.parse(annualController.text.toString())),
                      });
                      Navigator.pop(context, true);
                    },
                    customWidth: 70.0,
                    customHeight: 40.0),
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogCancel".tr(),
                    buttonAction: () => Navigator.pop(context, false),
                    customWidth: 70.0,
                    customHeight: 40.0),
              ],
            )
          ],
        ),
      )
    ],
  );
  return result;
}

Future<bool> addGradeUserDialog(BuildContext context, GradeModel model, List<EmployeeModel> employeeList, List<EmployeeModel> list) async {
  bool result = false;
  List<EmployeeModel> getUserList = List.from(employeeList);

  List<EmployeeModel> userChkList = [];

  list.map((data) => getUserList.remove(data)).toList();

  await loginDialogWidget(context: context, message: "grade_dialog_1".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          Container(
            height: 230.0.h,
            child: ListView.builder(
              itemCount: getUserList.length,
              itemBuilder: (context, index) {
                ValueNotifier<bool> isChks = ValueNotifier<bool>(false);

                return ValueListenableBuilder(
                  valueListenable: isChks,
                  builder: (context, bool value, child) {
                    return InkWell(
                      child: Container(
                        width: 100.0.w,
                        height: 50.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getProfileImage(
                                  size: 36,
                                  ImageUri: getUserList[index].profilePhoto.toString(),
                                ),
                                SizedBox(
                                  width: 6.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getUserList[index].name,
                                      style: getNotoSantBold(fontSize: 14.0, color: textColor),
                                    ),
                                    Text(
                                      getUserList[index].position! + " / " + getUserList[index].team!,
                                      style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 18.0.w,
                              height: 18.0.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                                shape: BoxShape.circle,
                                color: value ? workInsertColor : whiteColor,
                              ),
                              child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 16.0.w,
                                    color: whiteColor,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        isChks.value = !value;
                        if (isChks.value) {
                          userChkList.add(getUserList[index]);
                        } else {
                          userChkList.remove(getUserList[index]);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    await userChkList.map((e) => e.reference!.update({"level": FieldValue.arrayUnion([model.gradeLevel])})).toList();
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<bool> deleteGradeUserDialog(BuildContext context, List<EmployeeModel> list, GradeModel model) async {
  bool result = false;
  List<EmployeeModel> userChkList = [];

  await loginDialogWidget(context: context, message: "grade_dialog_2".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          Container(
            height: 220.0.h,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                ValueNotifier<bool> isChks = ValueNotifier<bool>(false);

                return ValueListenableBuilder(
                  valueListenable: isChks,
                  builder: (context, bool value, child) {
                    return InkWell(
                      child: Container(
                        width: 100.0.w,
                        height: 50.0.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                getProfileImage(
                                  size: 36,
                                  ImageUri: list[index].profilePhoto.toString(),
                                ),
                                SizedBox(
                                  width: 6.0.w,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index].name,
                                      style: getNotoSantBold(fontSize: 14.0, color: textColor),
                                    ),
                                    Text(
                                      list[index].position! + " / " + list[index].team!,
                                      style: getNotoSantRegular(fontSize: 10.0, color: hintTextColor),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              width: 18.0.w,
                              height: 18.0.h,
                              decoration: BoxDecoration(
                                border: Border.all(color: calendarLineColor.withOpacity(0.5)),
                                shape: BoxShape.circle,
                                color: value ? workInsertColor : whiteColor,
                              ),
                              child: Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 16.0.w,
                                    color: whiteColor,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        isChks.value = !value;
                        if (isChks.value) {
                          userChkList.add(list[index]);
                        } else {
                          userChkList.remove(list[index]);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(
            height: 5.0.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogConfirm".tr(),
                  buttonAction: () async {
                    if(model.gradeLevel == 9){
                      if(list.length == userChkList.length) {
                        alarmGradeDialog(context);
                        return;
                      }
                    }

                    await userChkList.map((e) => e.reference!.update({"level": FieldValue.arrayRemove([model.gradeLevel])})).toList();
                    result = true;
                    Navigator.pop(context, true);
                  },
                  customWidth: 70.0,
                  customHeight: 40.0),
              confirmElevatedButton(
                  topPadding: 50.0.h,
                  buttonName: "dialogCancel".tr(),
                  buttonAction: () => Navigator.pop(context, false),
                  customWidth: 70.0,
                  customHeight: 40.0),
            ],
          )
        ],
      ),
    )
  ]);
  return result;
}

Future<void> alarmGradeDialog(BuildContext context) async {
  await loginDialogWidget(context: context, message: "grade_dialog_3".tr(), actions: [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        confirmElevatedButton(
            topPadding: 50.0.h,
            buttonName: "dialogConfirm".tr(),
            buttonAction: () async {
              Navigator.pop(context, true);
            },
            customWidth: 70.0,
            customHeight: 40.0),
      ],
    )
  ]);
}


/* 사용자 변경 변경 */
Future<bool> colleagueUpdateDialog(BuildContext context, EmployeeModel employeeModel) async {
  bool result = false;
  TextEditingController enteredDateController = MaskedTextController(mask: '0000.00.00');
  enteredDateController.text = employeeModel.enteredDate ?? "";

  await loginDialogWidget(
    context: context,
    message: "colleague_dialog_menu".tr(),
    actions: [
      Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 5.0.h,
            ),
            Container(
              padding: EdgeInsets.only(
                top: 8.0.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "entered".tr(),
                    style: TextStyle(
                      fontSize: 13.0.sp,
                      color: Color(0xff2093F0),
                    ),
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 305.0.w,
                          height: 50.0.h,
                          child: TextFormField(
                            controller: enteredDateController,
                            maxLines: 1,
                            decoration: colleagueTextFormRoundBorderDecoration(
                              hintText: 'vacation_setting_dialog_2'.tr(),
                            ),
                            style: TextStyle(
                              fontSize: 12.0.sp,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogConfirm".tr(),
                    buttonAction: () async {
                      employeeModel.reference!.update({
                        "enteredDate" : enteredDateController.text,
                      });
                      Navigator.pop(context, true);
                    },
                    customWidth: 70.0,
                    customHeight: 40.0),
                confirmElevatedButton(
                    topPadding: 50.0.h,
                    buttonName: "dialogCancel".tr(),
                    buttonAction: () => Navigator.pop(context, false),
                    customWidth: 70.0,
                    customHeight: 40.0),
              ],
            )
          ],
        ),
      )
    ],
  );
  return result;
}

