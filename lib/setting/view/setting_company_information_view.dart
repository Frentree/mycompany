import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycompany/inquiry/function/profile_edit_function.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/style/decoration_style.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/provider/user_info_provider.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';
import 'package:mycompany/setting/widget/setting_dialog.dart';
import 'package:provider/provider.dart';

class SettingCompanyInformationView extends StatefulWidget {
  final List<dynamic> gradeLevel;

  SettingCompanyInformationView({required this.gradeLevel});

  @override
  SettingCompanyInformationViewState createState() => SettingCompanyInformationViewState();
}

class SettingCompanyInformationViewState extends State<SettingCompanyInformationView> {
  ImagePicker imagePicker = ImagePicker();
  ProfileEditFunction profileEditFunction = ProfileEditFunction();

  TextEditingController _companyAddrTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();
  TextEditingController _companyNoTextController = TextEditingController();
  TextEditingController _companyWebTextController = TextEditingController();
  ValueNotifier<bool> _isVacation = ValueNotifier<bool>(false);
  ValueNotifier<bool> _isUpload = ValueNotifier<bool>(false);

  ValueNotifier<bool> isEdit = ValueNotifier<bool>(false);
  ValueNotifier<List<bool>> isNoError = ValueNotifier<List<bool>>([
    true,
    true,
    true,
  ]);
  ValueNotifier<String?> changeImagePath = ValueNotifier<String?>(null);
  ValueNotifier<String> phoneFormErrorMessage = ValueNotifier<String>("");

  String? uploadImageUrl;

  @override
  Widget build(BuildContext context) {
    UserInfoProvider userInfoProvider = Provider.of<UserInfoProvider>(context, listen: false);

    UserModel loginUserData = userInfoProvider.getUserData()!;

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
                      "setting_menu_10".tr(),
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
                        child: StreamBuilder<DocumentSnapshot>(
                            stream: PublicFirebaseRepository().getCompany(companyCode: loginUserData.companyCode!),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              CompanyModel model = CompanyModel.fromMap(mapData: (snapshot.data!.data() as dynamic), reference: snapshot.data!.reference);
                              _phoneTextController.text = model.companyPhone ?? "";

                              _companyAddrTextController.text = model.companyAddr;
                              _companyWebTextController.text = model.companyWeb ?? "";
                              _companyNoTextController.text = model.companyNo ?? "";
                              _isVacation.value = model.vacation ?? false;

                              return ValueListenableBuilder(
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
                                                                    onTap: value == false
                                                                        ? null
                                                                        : () async {
                                                                            int? result = await changeProfileDialog(
                                                                              context: context,
                                                                            );
                                                                            switch (result) {
                                                                              case 1:
                                                                                changeImagePath.value = "";
                                                                                uploadImageUrl = "";
                                                                                break;
                                                                              case 2:
                                                                                await profileEditFunction
                                                                                    .selectImage(imageSource: ImageSource.gallery)
                                                                                    .then((selectImage) async {
                                                                                  if (selectImage != null) {
                                                                                    changeImagePath.value = selectImage.path;
                                                                                  }
                                                                                });
                                                                                break;
                                                                              case 3:
                                                                                await profileEditFunction
                                                                                    .selectImage(imageSource: ImageSource.camera)
                                                                                    .then((selectImage) async {
                                                                                  if (selectImage != null) {
                                                                                    changeImagePath.value = selectImage.path;
                                                                                  }
                                                                                });
                                                                                break;
                                                                              default:
                                                                            }
                                                                          },
                                                                    borderRadius: BorderRadius.circular(20),
                                                                    child: value == false || pickImagePath == null
                                                                        ? getProfileImage(
                                                                            ImageUri: model.companyPhoto,
                                                                            size: 50.0,
                                                                          )
                                                                        : showTempProfileImage(imageUri: pickImagePath, size: 50.0));
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
                                                      child: Text(
                                                    model.companyName,
                                                    style: TextStyle(
                                                      fontSize: 13.0.sp,
                                                      fontWeight: fontWeight['Medium'],
                                                      color: textColor,
                                                    ),
                                                  )),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Visibility(
                                                    visible: widget.gradeLevel.contains(8) || widget.gradeLevel.contains(9),
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
                                                                onPressed: isNoErrorValue.contains(false) == false
                                                                    ? () async {
                                                                        if (value == true) {
                                                                          _isUpload.value = true;
                                                                          if(changeImagePath.value != null){
                                                                            await profileEditFunction
                                                                                .uploadCompanyImageToStorage(context: context, pickImagePath: changeImagePath.value!)
                                                                                .then((uploadUrl) {
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

                                                                          CompanyModel updateModel = CompanyModel(
                                                                            companyCode: model.companyCode,
                                                                            companyName: model.companyName,
                                                                            companyAddr: _companyAddrTextController.text,
                                                                            companyNo: _companyNoTextController.text,
                                                                            companyPhone: _phoneTextController.text,
                                                                            companyPhoto: uploadImageUrl != null ? uploadImageUrl : model.companyPhoto,
                                                                            vacation: _isVacation.value,
                                                                            companyWeb: _companyWebTextController.text.trim(),
                                                                          );

                                                                          model.reference!.update(updateModel.toJson());

                                                                          changeImagePath.value = null;
                                                                          uploadImageUrl = null;
                                                                          _isUpload.value = false;

                                                                        }
                                                                        isEdit.value = !isEdit.value;
                                                                      }
                                                                    : null,
                                                              );
                                                            })),
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
                                                    top: 8.0.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "회사주소",
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          color: value == false ? hintTextColor : Color(0xff2093F0),
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
                                                                controller: _companyAddrTextController,
                                                                maxLines: 2,
                                                                decoration: loginTextFormRoundBorderDecoration(
                                                                  hintText: '회사주소를 입력해주세요'.tr(),
                                                                ),
                                                                readOnly: value == false ? true : false,
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
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: 8.0.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "회사전화",
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          color: value == false ? hintTextColor : Color(0xff2093F0),
                                                        ),
                                                      ),
                                                      Form(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 305.0.w,
                                                              height: 40.0.h,
                                                              child: TextFormField(
                                                                controller: _phoneTextController,
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
                                                          ],
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
                                                        "사업자 번호",
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          color: value == false ? hintTextColor : Color(0xff2093F0),
                                                        ),
                                                      ),
                                                      Form(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 305.0.w,
                                                              height: 40.0.h,
                                                              child: TextFormField(
                                                                controller: _companyNoTextController,
                                                                decoration: loginTextFormRoundBorderDecoration(
                                                                  hintText: value == false ? "" : '사업자 번호'.tr(),
                                                                ),
                                                                readOnly: value == false ? true : false,
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

                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: 8.0.h,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "웹 사이트",
                                                        style: TextStyle(
                                                          fontSize: 13.0.sp,
                                                          color: value == false ? hintTextColor : Color(0xff2093F0),
                                                        ),
                                                      ),
                                                      Form(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 305.0.w,
                                                              height: 40.0.h,
                                                              child: TextFormField(
                                                                controller: _companyWebTextController,
                                                                decoration: loginTextFormRoundBorderDecoration(
                                                                  hintText: value == false ? "" : '웹 사이트'.tr(),
                                                                ),
                                                                readOnly: value == false ? true : false,
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

                                                ValueListenableBuilder(
                                                  valueListenable: _isVacation,
                                                  builder: (context, bool vacation, child) {
                                                    return Container(
                                                      padding: EdgeInsets.only(
                                                        top: 8.0.h,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "연차 계산 기준",
                                                            style: TextStyle(
                                                              fontSize: 13.0.sp,
                                                              color: value == false ? hintTextColor : Color(0xff2093F0),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12.0.r),
                                                              color: Color(0xffF7F7F7),
                                                            ),
                                                            width: 305.0.w,
                                                            height: 40.0.h,
                                                            alignment: Alignment.centerLeft,
                                                            child: !value ?
                                                            Text(!_isVacation.value ? "입사년도 기준" : "회계년도 기준",
                                                              style: TextStyle(
                                                                fontSize: 14.0.sp,
                                                                color: textColor,
                                                              ),
                                                            ) :
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "입사년도 기준",
                                                                  style: TextStyle(
                                                                    fontSize: 14.0.sp,
                                                                    color: _isVacation.value ? hintTextColor : Color(0xff2093F0),
                                                                  ),
                                                                ),
                                                                Switch(
                                                                  value: _isVacation.value,
                                                                  onChanged: (bool val) {
                                                                    if(!value){
                                                                      return;
                                                                    }
                                                                      _isVacation.value = val;
                                                                  },
                                                                ),
                                                                Text(
                                                                  "회계년도 기준",
                                                                  style: TextStyle(
                                                                    fontSize: 14.0.sp,
                                                                    color: !_isVacation.value ? hintTextColor : Color(0xff2093F0),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }
                                                ),

                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            }),
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
