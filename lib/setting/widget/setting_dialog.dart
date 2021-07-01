import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                      result = await _publicFirebaseReository.createTeam(companyUser: companyCode, team: model);
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
Future<bool> addPositionDialog(BuildContext context, String companyCode, TextEditingController positionNameContoller) async {
  PublicFirebaseReository _publicFirebaseReository = PublicFirebaseReository();
  bool result = false;
  positionNameContoller.text = "";
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
                controller: positionNameContoller,
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
                      if (positionNameContoller.text.trim() == "") {
                        return;
                      }

                      PositionModel model = PositionModel(position: positionNameContoller.text);
                      result = await _publicFirebaseReository.createPosition(companyUser: companyCode, position: model);
                      positionNameContoller.text = "";
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
    BuildContext context, PositionModel model, TextEditingController positionNameContoller, List<EmployeeModel> list) async {
  bool result = false;
  positionNameContoller.text = model.position;
  await loginDialogWidget(context: context, message: "position_setting_dialog_5".tr(), actions: [
    Expanded(
      child: Column(
        children: [
          SizedBox(
            height: 5.0.h,
          ),
          TextFormField(
              controller: positionNameContoller,
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
                    if (positionNameContoller.text.trim() == "") {
                      return;
                    }
                    for (var data in list) {
                      data.reference!.update({"position": positionNameContoller.text});
                    }
                    model.reference!.update({"position": positionNameContoller.text});

                    positionNameContoller.text = "";
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
