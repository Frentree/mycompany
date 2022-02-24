import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycompany/inquiry/function/profile_edit_function.dart';
import 'package:mycompany/login/db/login_firestore_repository.dart';
import 'package:mycompany/login/function/form_validation_function.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/service/login_service_repository.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/provider/employee_Info_provider.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/run_app/view/auth_view.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';
import 'package:mycompany/setting/widget/setting_dialog.dart';
import 'package:provider/provider.dart';


class SettingMyInformationView extends StatefulWidget {
  @override
  SettingMyInformationViewState createState() => SettingMyInformationViewState();
}

class SettingMyInformationViewState extends State<SettingMyInformationView> {
  ImagePicker imagePicker = ImagePicker();
  LoginFirestoreRepository loginFirestoreRepository = LoginFirestoreRepository();
  LoginServiceRepository loginServiceRepository = LoginServiceRepository();
  ProfileEditFunction profileEditFunction = ProfileEditFunction();
  FormValidationFunction formValidationFunction = FormValidationFunction();

  GlobalKey<FormState> _birthdayFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();

  TextEditingController _birthdayTextController = MaskedTextController(mask: '0000.00.00');
  TextEditingController _phoneTextController = MaskedTextController(mask: '000-0000-0000');
  TextEditingController _bankNameTextController = TextEditingController();
  TextEditingController _accountTextController = TextEditingController();
  TextEditingController _enterDateTextController = TextEditingController();

  ValueNotifier<bool> isEdit = ValueNotifier<bool>(false);
  ValueNotifier<List<bool>> isNoError = ValueNotifier<List<bool>>([true, true, true,]);
  ValueNotifier<String?> changeImagePath = ValueNotifier<String?>(null);
  ValueNotifier<String?> bankName = ValueNotifier<String?>(null);
  ValueNotifier<String> birthdayFormErrorMessage = ValueNotifier<String>("");
  ValueNotifier<String> phoneFormErrorMessage = ValueNotifier<String>("");
  ValueNotifier<bool> _isUpload = ValueNotifier<bool>(false);

  String? uploadImageUrl;

  @override
  void dispose() {
    // TODO: implement dispose
    _birthdayTextController.dispose();
    _phoneTextController.dispose();
    _accountTextController.dispose();
    _bankNameTextController.dispose();
    _enterDateTextController.dispose();

    isEdit.dispose();
    isNoError.dispose();
    changeImagePath.dispose();
    bankName.dispose();
    birthdayFormErrorMessage.dispose();
    phoneFormErrorMessage.dispose();
    _isUpload.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);
    EmployeeInfoProvider employeeInfoProvider = Provider.of<EmployeeInfoProvider>(context, listen: false);

    UserModel loginUserData = userInfoProvider.getUserData()!;
    EmployeeModel loginEmployeeData = Provider.of<EmployeeModel>(context);
    _enterDateTextController.text = loginEmployeeData.enteredDate!;

    _birthdayTextController.text = loginEmployeeData.birthday == "" ? "" : loginEmployeeData.birthday!;
    _phoneTextController.text = loginEmployeeData.phone == "" ? "" : loginEmployeeData.phone!;
    _accountTextController.text = loginEmployeeData.account == "" ? "" : loginEmployeeData.account!.split("/")[1];
    _bankNameTextController.text = loginEmployeeData.account == "" ? "" : loginEmployeeData.account!.split("/")[0];

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
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
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xff000000).withOpacity(0.16),
                        blurRadius: 3.0.h,
                        offset: Offset(0.0, 1.0)
                    )
                  ]
              ),
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
                      "내 정보",
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
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: _isUpload,
                  builder: (context, bool uploadChk, child) {
                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 27.5.w,
                        ),
                        child: ValueListenableBuilder(
                            valueListenable: isEdit,
                            builder: (BuildContext context, bool value, Widget? child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 75.0.h,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        top: 20.0.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: ClipOval(
                                                child: Container(
                                                  width: 55.0.h,
                                                  height: 55.0.h,
                                                  color: value == false ? hintTextColor : Color(0xff2093F0),
                                                  alignment: Alignment.center,
                                                  child: ClipOval(
                                                    child: Container(
                                                      width: 52.5.h,
                                                      height: 52.5.h,
                                                      color: Colors.white,
                                                      alignment: Alignment.center,
                                                      child: ValueListenableBuilder(
                                                          valueListenable: changeImagePath,
                                                          builder: (BuildContext context, String? pickImagePath, Widget? child) {
                                                            return InkWell(
                                                                onTap: value == false ? null : () async {
                                                                  int? result = await changeProfileDialog(context: context,);
                                                                  switch (result) {
                                                                    case 1:
                                                                      changeImagePath.value = "";
                                                                      uploadImageUrl = "";
                                                                      break;
                                                                    case 2:
                                                                      await profileEditFunction.selectImage(imageSource: ImageSource.gallery).then((selectImage) async {
                                                                        if(selectImage != null){
                                                                          changeImagePath.value = selectImage.path;
                                                                        }
                                                                      });
                                                                      break;
                                                                    case 3:
                                                                      await profileEditFunction.selectImage(imageSource: ImageSource.camera).then((selectImage) async {
                                                                        if(selectImage != null){
                                                                          changeImagePath.value = selectImage.path;
                                                                        }
                                                                      });
                                                                      break;
                                                                    default:
                                                                  }
                                                                },
                                                                borderRadius: BorderRadius.circular(20),
                                                                child: value == false || pickImagePath == null ? getProfileImage(
                                                                  ImageUri: loginEmployeeData.profilePhoto,
                                                                  size: 50.0,
                                                                ) : showTempProfileImage(
                                                                    imageUri: pickImagePath,
                                                                    size: 50.0
                                                                )
                                                            );
                                                          }
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      loginEmployeeData.name,
                                                      style: TextStyle(
                                                        fontSize: 13.0.sp,
                                                        fontWeight: fontWeight['Medium'],
                                                        color: textColor,
                                                      ),
                                                    ),
                                                    (loginEmployeeData.position == "" && loginEmployeeData.team == "") ? Text(
                                                      ""
                                                    ) : Text(
                                                      (loginEmployeeData.position != "" && loginEmployeeData.team != "") ?  "${loginEmployeeData.position}/${loginEmployeeData.team}" : "${loginEmployeeData.position}${loginEmployeeData.team}",
                                                      style: TextStyle(
                                                        fontSize: 13.0.sp,
                                                        fontWeight: fontWeight['Medium'],
                                                        color: hintTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                                alignment: Alignment.centerRight,
                                                child: ValueListenableBuilder(
                                                    valueListenable: isNoError,
                                                    builder: (BuildContext context, List<bool> isNoErrorValue, Widget? child) {
                                                      return IconButton(
                                                        icon: Icon(
                                                          value == false ? Icons.mode_edit : Icons.check,
                                                          color: isNoErrorValue.contains(false) == true ? hintTextColor : Color(0xff2093F0),
                                                        ),
                                                        onPressed: isNoErrorValue.contains(false) == false ? () async {
                                                          if(bankName.value != null){
                                                            if(_accountTextController.value.text.trim() == ""){
                                                              _bankNameTextController.text = "";
                                                              bankName.value = null;
                                                            }
                                                          }

                                                          if(value == true) {
                                                            _isUpload.value = true;
                                                            if(changeImagePath.value != null){
                                                              await profileEditFunction.uploadImageToStorage(context: context, pickImagePath: changeImagePath.value!).then((uploadUrl){
                                                                uploadImageUrl = uploadUrl;
                                                              }).catchError((onError) async{
                                                                _isUpload.value = false;
                                                                await loginDialogWidget(
                                                                    context: context,
                                                                    message: "photo_fail".tr(),
                                                                    actions: [
                                                                      confirmElevatedButton(
                                                                          topPadding: 81.0.h,
                                                                          buttonName: "dialogConfirm".tr(),
                                                                          buttonAction: () => Navigator.pop(context),
                                                                          customWidth: 200.0,
                                                                          customHeight: 40.0.h
                                                                      ),
                                                                    ]
                                                                );
                                                              });
                                                            }

                                                            if(uploadImageUrl != null){
                                                              loginEmployeeData.profilePhoto = uploadImageUrl;
                                                              loginUserData.profilePhoto = uploadImageUrl;
                                                            }

                                                            loginEmployeeData.birthday = _birthdayTextController.text.replaceAll(".", "");
                                                            loginEmployeeData.phone = _phoneTextController.text;
                                                            loginEmployeeData.account = _bankNameTextController.text+"/"+_accountTextController.text.replaceAll(" ", "");

                                                            loginUserData.birthday = _birthdayTextController.text;
                                                            loginUserData.phone = _phoneTextController.text;

                                                            loginFirestoreRepository.updateUserData(userModel: loginUserData);
                                                            loginFirestoreRepository.updateEmployeeData(employeeModel: loginEmployeeData);

                                                            userInfoProvider.saveUserDataToPhone(userModel: loginUserData);
                                                            employeeInfoProvider.saveEmployeeDataToPhone(employeeModel: loginEmployeeData);

                                                            _isUpload.value = false;
                                                            changeImagePath.value = null;
                                                            uploadImageUrl = null;
                                                          }
                                                          isEdit.value = !isEdit.value;

                                                        } : null,
                                                      );
                                                    }
                                                )
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                              top: 20.0.h,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "이메일",
                                                      style: TextStyle(
                                                        fontSize: 13.0.sp,
                                                        color: hintTextColor,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () async {
                                                        bool? result = await oldPasswordConfirmDialog(
                                                          context: context,
                                                          userModel: loginUserData,
                                                        );

                                                        if(result == true){
                                                          bool? result = await changePasswordDialog(context: context);
                                                          if(result == true){
                                                            await loginDialogWidget(
                                                              context: context,
                                                              message: "비밀번호 변경이 완료되었습니다\n다시 로그인해주세요.",
                                                              actions: [
                                                                loginDialogConfirmButton(
                                                                    buttonName: 'dialogConfirm'.tr(),
                                                                    buttonAction: () async {
                                                                      await loginServiceRepository.signOut();

                                                                      loginUserData.deviceId = "";
                                                                      loginUserData.token = "";
                                                                      loginEmployeeData.token = "";

                                                                      await loginFirestoreRepository.updateUserData(userModel: loginUserData);
                                                                      await loginFirestoreRepository.updateEmployeeData(employeeModel: loginEmployeeData);

                                                                      userInfoProvider.deleteUserDataToPhone();
                                                                      employeeInfoProvider.deleteEmployeeDataToPhone();
                                                                      pageMoveAndRemoveBackPage(context: context, pageName: AuthView());
                                                                    }
                                                                ),
                                                              ],
                                                              barrierDismissibleValue: false,
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                        value == false ? "" : "비밀번호 변경",
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          color: Color(0xff2093F0),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 305.0.w,
                                                  height: 40.0.h,
                                                  child: TextFormField(
                                                    decoration: loginTextFormRoundBorderDecoration(),
                                                    readOnly: true,
                                                    initialValue: loginEmployeeData.mail,
                                                    style: TextStyle(
                                                      fontSize: 14.0.sp,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              top: 8.0.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "생일",
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    color: value == false ? hintTextColor : Color(0xff2093F0),
                                                  ),
                                                ),
                                                ValueListenableBuilder(
                                                    valueListenable: birthdayFormErrorMessage,
                                                    builder: (BuildContext context, String birthdayErrorMessage, Widget? child) {
                                                      return Form(
                                                        key: _birthdayFormKey,
                                                        onChanged: (){
                                                          _birthdayFormKey.currentState!.validate();
                                                          if(_birthdayTextController.text == "" || birthdayFormErrorMessage.value == ""){
                                                            isNoError.value = List.from(isNoError.value)..replaceRange(1, 2, [true]);
                                                            birthdayFormErrorMessage.value = "";
                                                          }
                                                          else{
                                                            isNoError.value = List.from(isNoError.value)..replaceRange(1, 2, [false]);
                                                          }
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 305.0.w,
                                                              height: 40.0.h,
                                                              child: TextFormField(
                                                                controller: _birthdayTextController,
                                                                validator: ((text){
                                                                  String? result = formValidationFunction.formValidationFunction(type: "birthday", value: text!);
                                                                  if(result != null){
                                                                    birthdayFormErrorMessage.value = result;
                                                                  }
                                                                  else{
                                                                    birthdayFormErrorMessage.value = "";
                                                                  }
                                                                }),
                                                                decoration: loginTextFormRoundBorderDecoration(
                                                                  hintText: value == false ? "" : 'birthdayHint'.tr(),
                                                                ),
                                                                readOnly: value == false ? true : false,
                                                                style: TextStyle(
                                                                  fontSize: 14.0.sp,
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: birthdayFormErrorMessage.value != "",
                                                              child: Padding(
                                                                padding: EdgeInsets.only(left: 12.0.w),
                                                                child: Text(
                                                                  birthdayErrorMessage,
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
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              top: 8.0.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "전화번호",
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    color: value == false ? hintTextColor : Color(0xff2093F0),
                                                  ),
                                                ),
                                                ValueListenableBuilder(
                                                    valueListenable: phoneFormErrorMessage,
                                                    builder: (BuildContext context, String phoneErrorMessage, Widget? child) {
                                                      return Form(
                                                        key: _phoneFormKey,
                                                        onChanged: (){
                                                          _phoneFormKey.currentState!.validate();
                                                          if(_phoneTextController.text == "" || phoneFormErrorMessage.value == ""){
                                                            isNoError.value = List.from(isNoError.value)..replaceRange(2, 3, [true]);
                                                            phoneFormErrorMessage.value = "";
                                                          }
                                                          else{
                                                            isNoError.value = List.from(isNoError.value)..replaceRange(2, 3, [false]);
                                                          }
                                                        },
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 305.0.w,
                                                              height: 40.0.h,
                                                              child: TextFormField(
                                                                controller: _phoneTextController,
                                                                validator: ((text){
                                                                  String? result = formValidationFunction.formValidationFunction(type: "phone", value: text!);
                                                                  if(result != null){
                                                                    phoneFormErrorMessage.value = result;
                                                                  }
                                                                  else{
                                                                    phoneFormErrorMessage.value = "";
                                                                  }
                                                                }),
                                                                decoration: loginTextFormRoundBorderDecoration(
                                                                  hintText: value == false ? "" : 'phone'.tr(),
                                                                ),
                                                                readOnly: value == false ? true : false,
                                                                style: TextStyle(
                                                                  fontSize: 14.0.sp,
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: phoneFormErrorMessage.value != "",
                                                              child: Padding(
                                                                padding: EdgeInsets.only(left: 12.0.w),
                                                                child: Text(
                                                                  phoneErrorMessage,
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
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              top: 8.0.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "계좌번호",
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    color: value == false ? hintTextColor : Color(0xff2093F0),
                                                  ),
                                                ),
                                                ValueListenableBuilder(
                                                    valueListenable: bankName,
                                                    builder: (BuildContext context, String? bankNameValue, Widget? child) {
                                                      return Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 9,
                                                            child: TextFormField(
                                                              controller: _bankNameTextController,
                                                              readOnly: true,
                                                              style: TextStyle(
                                                                fontSize: 14.0.sp,
                                                                color: textColor,
                                                              ),
                                                              decoration: loginTextFormRoundBorderDecoration(
                                                                hintText: value == false ? "" : "은행 선택",
                                                                suffixIcon: IconButton(
                                                                  icon: Icon(
                                                                    Icons.arrow_drop_down,
                                                                    color: Color(0xff949494),
                                                                  ),
                                                                  onPressed: null,
                                                                ),
                                                              ),
                                                              onTap: value == false ? null : () async {
                                                                bankName.value = await selectBankDialog(context: context);
                                                                if(bankName.value != null){
                                                                  if(bankName.value == "선택안함"){
                                                                    bankName.value = null;
                                                                    _bankNameTextController.clear();
                                                                    _accountTextController.clear();
                                                                  } else {
                                                                    _bankNameTextController.text = bankName.value!;
                                                                  }
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: Container(),
                                                          ),
                                                          Expanded(
                                                            flex: 9,
                                                            child: TextFormField(
                                                              controller: _accountTextController,
                                                              readOnly: (value == false || bankName.value == null) ? true : false,
                                                              keyboardType: TextInputType.number,
                                                              style: TextStyle(
                                                                fontSize: 14.0.sp,
                                                                color: textColor,
                                                              ),
                                                              decoration: loginTextFormRoundBorderDecoration(
                                                                hintText: value == false ? "" : "계좌번호",
                                                              ),
                                                              onTap: bankNameValue == null ? () async {
                                                                await loginDialogWidget(
                                                                    context: context,
                                                                    message: "은행을 먼저 선택해주세요.",
                                                                    actions: [
                                                                      loginDialogConfirmButton(
                                                                          buttonName: 'dialogConfirm'.tr(),
                                                                          buttonAction: () {
                                                                            backPage(context: context);
                                                                          }
                                                                      ),
                                                                    ]
                                                                );
                                                              } : null,
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              top: 8.0.h,
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "입사일",
                                                  style: TextStyle(
                                                    fontSize: 13.0.sp,
                                                    color: hintTextColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 305.0.w,
                                                  height: 40.0.h,
                                                  child: TextFormField(
                                                    controller: _enterDateTextController,
                                                    decoration: loginTextFormRoundBorderDecoration(),
                                                    readOnly: true,
                                                    style: TextStyle(
                                                      fontSize: 14.0.sp,
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
                                  )

                                ],
                              );
                            }
                        ),
                      ),
                      Visibility(
                          visible: uploadChk,
                          child: Container(
                            width: double.infinity,
                            color: blackColor.withOpacity(0.7),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 10.0.h,),
                                  Text("변경 중",
                                    style: getRobotoMedium(fontSize: 13, color: whiteColor),
                                  )
                                ],
                              ),
                            ),
                          )
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
