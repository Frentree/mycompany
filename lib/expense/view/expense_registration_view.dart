import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/expense/widget/expense_dialog_widget.dart';
import 'package:mycompany/inquiry/function/profile_edit_function.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/db/public_firebase_repository.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/function/public_funtion.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/public/style/text_style.dart';
import 'package:mycompany/schedule/widget/userProfileImage.dart';

class ExpenseRegistrationView extends StatefulWidget {
  @override
  _ExpenseRegistrationViewState createState() => _ExpenseRegistrationViewState();
}

class _ExpenseRegistrationViewState extends State<ExpenseRegistrationView> {
  DateFormatCustom _format = DateFormatCustom();
  ImagePicker imagePicker = ImagePicker();
  ProfileEditFunction profileEditFunction = ProfileEditFunction();

  TextEditingController priceController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late UserModel loginUser;
  DateTime _time = DateTime.now();
  late ValueNotifier<DateTime> seleteTime;
  ValueNotifier<String?> changeImagePath = ValueNotifier<String?>(null);
  ValueNotifier<bool> _isUpload = ValueNotifier<bool>(false);
  String? uploadImageUrl;

  String seleteItem = "중식비";

  List<String> seleteItemList = <String>[
    '중식비',
    '석식비',
    '교통비',
    '기타',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginUser = PublicFunction().getUserProviderSetting(context);
    seleteTime = ValueNotifier(_time);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    priceController.dispose();
    contentController.dispose();
    changeImagePath.dispose();
    seleteTime.dispose();
    _isUpload.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Scaffold(
        //floatingActionButton: getMainCircularMenu(context: context, navigator: 'schedule'),
        body: ValueListenableBuilder(
            valueListenable: _isUpload,
            builder: (context, bool uploadChk, child) {
              return Stack(
                children: [
                  GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: whiteColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 98.0.h,
                            padding: EdgeInsets.only(
                              left: 27.5.w,
                              top: 33.0.h,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Color(0xff000000).withOpacity(0.16), blurRadius: 3.0.h, offset: Offset(0.0, 1.0))]),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              SizedBox(
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
                                      onPressed: () => Navigator.pop(context, false),
                                      padding: EdgeInsets.zero,
                                      alignment: Alignment.centerLeft,
                                      color: Color(0xff2093F0),
                                    ),
                                    SizedBox(
                                      width: 14.7.w,
                                    ),
                                    Text(
                                      "경비 입력".tr(),
                                      style: TextStyle(
                                        fontSize: 18.0.sp,
                                        fontWeight: fontWeight['Medium'],
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                  child: Container(
                                    width: 50.0.w,
                                    height: 20.0.h,
                                    alignment: Alignment.centerRight,
                                    color: whiteColor.withOpacity(0),
                                    padding: EdgeInsets.only(right: 27.0.w),
                                    child: SvgPicture.asset(
                                      'assets/icons/check.svg',
                                      width: 23.51.w,
                                      height: 13.37.h,
                                      color: Color(0xff2093F0),
                                    ),
                                  ),
                                  onTap: () async {
                                    FocusScope.of(context).unfocus();
                                    _isUpload.value = true;
                                    if (changeImagePath.value != null && changeImagePath.value != "") {
                                      await profileEditFunction
                                          .uploadCompanyImageToStorage(context: context, pickImagePath: changeImagePath.value!)
                                          .then((uploadUrl) {
                                        uploadImageUrl = uploadUrl;
                                      }).catchError((onError) async {
                                        _isUpload.value = false;
                                        await loginDialogWidget(context: context, message: "photo_fail".tr(), actions: [
                                          confirmElevatedButton(
                                              topPadding: 81.0.h,
                                              buttonName: "dialogConfirm".tr(),
                                              buttonAction: () => Navigator.pop(context),
                                              customWidth: 200.0,
                                              customHeight: 40.0.h),
                                        ]);
                                      });
                                    }
                                    if (priceController.text.trim() == "") {
                                      await loginDialogWidget(context: context, message: "expense_price_fail".tr(), actions: [
                                        confirmElevatedButton(
                                            topPadding: 81.0.h,
                                            buttonName: "dialogConfirm".tr(),
                                            buttonAction: () => Navigator.pop(context),
                                            customWidth: 200.0,
                                            customHeight: 40.0.h),
                                      ]);
                                      _isUpload.value = false;
                                    }

                                    ExpenseModel addExpenseModel = ExpenseModel(
                                        mail: loginUser.mail,
                                        name: loginUser.name,
                                        companyCode: loginUser.companyCode!,
                                        contentType: seleteItem,
                                        imageUrl: uploadImageUrl,
                                        detailNote: contentController.text,
                                        status: "미",
                                        cost: int.parse(priceController.text.trim()),
                                        buyDate: _format.changeDateTimeToTimestamp(dateTime: seleteTime.value));

                                    await PublicFirebaseRepository().addExpense(loginUser: loginUser, model: addExpenseModel);

                                    changeImagePath.value = null;
                                    uploadImageUrl = "";
                                    _isUpload.value = false;

                                    Navigator.pop(context);
                                  }),
                            ]),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.only(top: 21.0.h, left: 26.0.w, right: 21.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: ClipOval(
                                          child: Container(
                                            width: 55.0.h,
                                            height: 55.0.h,
                                            color: Color(0xff2093F0),
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
                                                          onTap: () async {
                                                            int? result = await insertExpensePhotoDialog(
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
                                                          child: pickImagePath == null
                                                              ? getCameraImage(
                                                                  size: 50.0,
                                                                )
                                                              : showTempProfileImage(imageUri: pickImagePath, size: 50.0));
                                                    }),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0.w,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43.0.h,
                                          padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(12.0.r),
                                            ),
                                            color: hintTextColor,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 9.0.w),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.0.r),
                                              ),
                                              color: whiteColor,
                                            ),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                    child: ValueListenableBuilder(
                                                      valueListenable: seleteTime,
                                                      builder: (context, DateTime value, child) {
                                                        return Text(
                                                          _format.getDate(date: value),
                                                          style: getRobotoBold(
                                                            fontSize: 23.0,
                                                            color: textColor,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    onTap: () async {
                                                      seleteTime.value = await showExpenseDatePicker(context: context, date: seleteTime.value);
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.0.h,
                                  ),
                                  Container(
                                    height: 43.0.h,
                                    padding: EdgeInsets.symmetric(horizontal: 0.5.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0.r),
                                      ),
                                      color: hintTextColor,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 9.0.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0.r),
                                        ),
                                        color: whiteColor,
                                      ),
                                      child: DropdownButton<String>(
                                        value: seleteItem,
                                        isExpanded: true,
                                        focusColor: Colors.white,
                                        style: getNotoSantMedium(fontSize: 12, color: textColor),
                                        items: seleteItemList
                                            .map((value) => DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Center(
                                                      child: Text(
                                                    value,
                                                    style: TextStyle(color: Colors.black),
                                                  )),
                                                ))
                                            .toList(),
                                        onChanged: (val) {
                                          setState(() {
                                            seleteItem = val!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0.h,
                                  ),
                                  TextFormField(
                                      controller: priceController,
                                      autofocus: false,
                                      minLines: 1,
                                      maxLines: 1,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10.0.w),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0.r),
                                          borderSide: BorderSide(width: 2.0, style: BorderStyle.none),
                                        ),
                                        hintText: "금액".tr(),
                                        hintStyle: getNotoSantRegular(
                                          fontSize: 14.0,
                                          color: hintTextColor,
                                        ),
                                      ),
                                      style: getNotoSantRegular(fontSize: 14.0, color: textColor)),
                                  SizedBox(
                                    height: 10.0.h,
                                  ),
                                  TextFormField(
                                      controller: contentController,
                                      autofocus: false,
                                      minLines: 5,
                                      maxLines: 10,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 10.0.w),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12.0.r),
                                          borderSide: BorderSide(width: 2.0, style: BorderStyle.none),
                                        ),
                                        hintText: "details".tr(),
                                        hintStyle: getNotoSantRegular(
                                          fontSize: 14.0,
                                          color: hintTextColor,
                                        ),
                                      ),
                                      style: getNotoSantRegular(fontSize: 14.0, color: textColor)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                              SizedBox(
                                height: 10.0.h,
                              ),
                              Text(
                                "작성 중",
                                style: getRobotoMedium(fontSize: 13, color: whiteColor),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              );
            }),
      ),
    );
  }
}
