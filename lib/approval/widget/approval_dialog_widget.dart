import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/login/function/form_validation_function.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/model/position_model.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:easy_localization/easy_localization.dart';

Future<dynamic> enterEmployeeInformationDialog({required BuildContext context, required String buttonName, required EmployeeModel confirmUser, required List<TeamModel> teamList, required List<PositionModel> positionList}) {
  FormValidationFunction formValidationFunction = FormValidationFunction();

  GlobalKey<FormState> _companyEnterDateFormKey = GlobalKey<FormState>();
  TextEditingController _companyEnterDateTextController = MaskedTextController(mask: '0000.00.00');
  TextEditingController _teamTextController = TextEditingController();
  TextEditingController _positionTextController = TextEditingController();

  ValueNotifier<List<bool>> isFormValid = ValueNotifier<List<bool>>([true, true, true]);
  ValueNotifier<String> errorMessage = ValueNotifier<String>("");
  ValueNotifier<String> teamName = ValueNotifier<String>("");
  ValueNotifier<String> positionName = ValueNotifier<String>("");

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
                          "직원 정보 입력",
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
                          onPressed: () => Navigator.pop(context),
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
                      valueListenable: errorMessage,
                      builder: (BuildContext context, String value, Widget? child) {
                        return Form(
                          key: _companyEnterDateFormKey,
                          onChanged: (){
                            _companyEnterDateFormKey.currentState!.validate();
                            if(_companyEnterDateTextController.text == "" || errorMessage.value == ""){
                              isFormValid.value = List.from(isFormValid.value)..replaceRange(0, 1, [true]);
                              errorMessage.value = "";
                            }
                            else{
                              isFormValid.value = List.from(isFormValid.value)..replaceRange(0, 1, [false]);
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40.0.h,
                                child: TextFormField(
                                  controller: _companyEnterDateTextController,
                                  validator: ((text) {
                                    String? result = formValidationFunction.formValidationFunction(type: "companyEnterDate", value: text!);
                                    if(result != null){
                                      errorMessage.value = result;
                                    }
                                    else{
                                      errorMessage.value = "";
                                    }
                                  }),
                                  decoration: loginTextFormRoundBorderDecoration(
                                    hintText: 'entered'.tr() + " (ex: 1999.01.01)",
                                  ),
                                  style: TextStyle(
                                    fontSize: 14.0.sp,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: errorMessage.value != "",
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
                      valueListenable: teamName,
                      builder: (BuildContext context, String value, Widget? child) {
                        return TextFormField(
                          controller: _teamTextController,
                          readOnly: true,
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: textColor,
                          ),
                          decoration: loginTextFormRoundBorderDecoration(
                            hintText: "팀",
                            suffixIcon: PopupMenuButton<TeamModel>(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xff949494),
                              ),
                              onSelected: (TeamModel teamData){
                                teamName.value = teamData.teamName;
                                _teamTextController.text = teamData.teamName;
                                confirmUser.team = teamData.teamName;
                                confirmUser.teamNum = teamData.teamNum;
                              },
                              itemBuilder: (BuildContext context){
                                return teamList.map((teamData) => PopupMenuItem(
                                  child: Text(
                                    teamData.teamName,
                                    style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: textColor,
                                    ),
                                  ),
                                  value: teamData,
                                )).toList();
                              },
                            ),
                          ),
                        );
                      }
                    )
                  ),
                  Container(
                      padding: EdgeInsets.only(
                        top: 8.0.h,
                        left: 16.0.w,
                        right: 16.0.w,
                      ),
                      child: ValueListenableBuilder(
                          valueListenable: positionName,
                          builder: (BuildContext context, String value, Widget? child) {
                            return TextFormField(
                              controller: _positionTextController,
                              readOnly: true,
                              style: TextStyle(
                                fontSize: 14.0.sp,
                                color: textColor,
                              ),
                              decoration: loginTextFormRoundBorderDecoration(
                                hintText: "직급",
                                suffixIcon: PopupMenuButton<PositionModel>(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Color(0xff949494),
                                  ),
                                  onSelected: (PositionModel positionData){
                                    positionName.value = positionData.position;
                                    _positionTextController.text = positionData.position;
                                    confirmUser.position = positionData.position;
                                    confirmUser.positionNum = positionData.positionNum;
                                  },
                                  itemBuilder: (BuildContext context){
                                    return positionList.map((positionData) => PopupMenuItem(
                                      child: Text(
                                        positionData.position,
                                        style: TextStyle(
                                          fontSize: 14.0.sp,
                                          color: textColor,
                                        ),
                                      ),
                                      value: positionData,
                                    )).toList();
                                  },
                                ),
                              ),
                            );
                          }
                      )
                  ),
                  ValueListenableBuilder(
                    valueListenable: isFormValid,
                    builder: (BuildContext context, List<bool> value, Widget? child){
                      return attendanceDialogElevatedButton(
                        topPadding: 11.0.h,
                        buttonName: buttonName,
                        buttonAction: value.contains(false) ? null : () async {
                          confirmUser.enteredDate = _companyEnterDateTextController.text.replaceAll(".", "");
                          backPage(context: context, returnValue: confirmUser);
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
