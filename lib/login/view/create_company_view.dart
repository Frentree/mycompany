import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/function/create_company_function.dart';
import 'package:mycompany/login/model/road_address_model.dart';
import 'package:mycompany/login/view/create_company_success_view.dart';
import 'package:mycompany/login/view/search_company_address_view.dart';
import 'package:mycompany/login/widget/login_dialog_widget.dart';
import 'package:mycompany/public/function/page_route.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';

class CreateCompanyView extends StatefulWidget {
  @override
  CreateCompanyViewState createState() => CreateCompanyViewState();
}

class CreateCompanyViewState extends State<CreateCompanyView> {
  CreateCompanyFunction _createCompanyFunction = CreateCompanyFunction();

  TextEditingController _companyNameTextController = TextEditingController();
  TextEditingController _companyAddressTextController = TextEditingController();
  TextEditingController _companyAddressDetailTextController = TextEditingController();

  CompanyAddress companyAddress = CompanyAddress(
    roadAddr: "",
    jibunAddr: "",
    engAddr: "",
    zipNo: "",
    bdNm: "",
    detBdNmList: "",
  );

  ValueNotifier<List<bool>> isFormValid = ValueNotifier<List<bool>>([false, false]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 27.5.w,
                right: 27.5.w,
                top: 68.0.h,
              ),
              child: SizedBox(
                height: 26.0.h,
                child: Row(
                  children: [
                    IconButton(
                      constraints: BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_ios_outlined,
                      ),
                      iconSize: 24.0.h,
                      splashRadius: 24.0.r,
                      onPressed: () => backPage(context: context),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'createCompanyViewName'.tr(),
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: 126.0.h,
                      ),
                      child: SizedBox(
                        child: Text(
                          'createCompanyViewMainMessage'.tr(),
                          style: TextStyle(
                            fontSize: 22.0.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                        top: 8.0.h,
                      ),
                      child: SizedBox(
                        child: Text(
                          'createCompanyViewHintMessage'.tr(),
                          style: TextStyle(
                            fontSize: 13.0.sp,
                            fontWeight: fontWeight['Medium'],
                            color: hintTextColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    companyViewTextFormField(
                      topPadding: 44.0.h,
                      textEditingController: _companyNameTextController,
                      hintText: 'enterCompanyName'.tr(),
                      valueNotifier: isFormValid,
                      index: 0,
                    ),
                    companyViewTextFormField(
                      topPadding: 12.0.h,
                      textEditingController: _companyAddressTextController,
                      hintText: 'enterCompanyAddress'.tr(),
                      valueNotifier: isFormValid,
                      index: 1,
                      readOnly: true,
                      suffixIcon: textFormSearchButton(),
                      onTab: () async {
                        CompanyAddress _companyAddress = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchCompanyAddressView(companyAddress: companyAddress)
                          )
                        );
                        if (_companyAddress.roadAddr != "") {
                          isFormValid.value[1] = true;
                          setState(() {
                            companyAddress = _companyAddress;
                            _companyAddressTextController.text = companyAddress.roadAddr;
                            _companyAddressDetailTextController.text = companyAddress.bdNm == "" ? "" : "${companyAddress.bdNm} ";
                          });
                        }
                      }
                    ),
                    companyViewTextFormField(
                      topPadding: 12.0.h,
                      textEditingController: _companyAddressDetailTextController,
                      hintText: '상세 주소를 입력해 주세요.',
                      readOnly: _companyAddressTextController.text == "",
                    ),
                    ValueListenableBuilder(
                      valueListenable: isFormValid,
                      builder: (BuildContext context, List<bool> value, Widget? child) {
                        return loginElevatedButton(
                          topPadding: 45.0.h,
                          buttonName: 'createButton'.tr(),
                          buttonAction: value.contains(false)? null : () async {
                            bool result = false;
                            result = await loginDialogWidget(
                              context: context,
                              message: "회사를 생성하시겠습니까?",
                              actions: [
                                loginDialogCancelButton(
                                  buttonName: 'dialogCancel'.tr(),
                                  buttonAction: () {
                                    backPage(context: context, returnValue: false);
                                  }
                                ),
                                loginDialogConfirmButton(
                                  buttonName: 'dialogConfirm'.tr(),
                                  buttonAction: () async {
                                    await _createCompanyFunction.createCompanyFunction(
                                      context: context,
                                      companyName: _companyNameTextController.text,
                                      companyAddress: _companyAddressTextController.text + " " + _companyAddressDetailTextController.text,
                                    );
                                    backPage(context: context,returnValue: true,);
                                  }
                                ),
                              ]
                            );
                            if (result) {
                              pageMoveAndRemoveBackPage(context: context, pageName: CreateCompanySuccessView());
                            }
                          }
                        );
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}