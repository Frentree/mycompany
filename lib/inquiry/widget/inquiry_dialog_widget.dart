import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mycompany/attendance/widget/attendance_button_widget.dart';
import 'package:mycompany/login/function/form_validation_function.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/model/team_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:easy_localization/easy_localization.dart';

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
    "NH농협", "KB국민", "신한", "우리", "하나",
    "IBK기업", "SC제일", "씨티", "KDB산업", "SBI처축은행"
    "새마을", "대구", "광주", "우체국", "신협",
    "전북", "경남", "부산", "수협", "제주",
    "저축은행", "산림조합", "케이뱅크", "카카오뱅크", "HSBC",
    "중국공상", "JP모간", "도이치", "BNP파리바", "BOA",
    "중국건설", "토스증권", "키움", "KB증권", "미래에셋대우",
    "삼성", "NH투자", "유안타", "대신", "한국투자",
    "신한금융투자", "유진투자", "한화투자", "DB금융투자", "하나금융",
    "하이투자", "현대차증권", "신영", "이베스트", "교보",
    "메리츠증권", "KTB투자", "SK", "부국", "케이프투자",
    "한국포스증권", "카카오페이증권"
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
                      onPressed: () => backPage(context: context, /*returnValue: selectOption*/),
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
                              bankList[index]
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

Future<dynamic> changePasswordDialog({required BuildContext context/*, required UserModel userModel*/}) {
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

Future<dynamic> enterEmployeeInformationDialog({required BuildContext context, required String buttonName, required EmployeeModel confirmUser, required List<TeamModel> teamList,/* required List<String> positionList*/}) {
  FormValidationFunction formValidationFunction = FormValidationFunction();

  GlobalKey<FormState> _companyEnterDateFormKey = GlobalKey<FormState>();
  TextEditingController _companyEnterDateTextController = MaskedTextController(mask: '0000.00.00');
  TextEditingController _teamTextController = TextEditingController();

  ValueNotifier<List<bool>> isFormValid = ValueNotifier<List<bool>>([true, true, true]);
  ValueNotifier<String> errorMessage = ValueNotifier<String>("");
  ValueNotifier<String> teamName = ValueNotifier<String>("");

  return showDialog(
    barrierDismissible: false,
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
                          onPressed: () => backPage(context: context, returnValue: confirmUser),
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
                                      hintText: "입사일",
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
                                    print(confirmUser.team);
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
                  ValueListenableBuilder(
                    valueListenable: isFormValid,
                    builder: (BuildContext context, List<bool> value, Widget? child){
                      return attendanceDialogElevatedButton(
                        topPadding: 11.0.h,
                        buttonName: buttonName,
                        buttonAction: value.contains(false) ? null : () async {
                          confirmUser.enteredDate = _companyEnterDateTextController.text;
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
