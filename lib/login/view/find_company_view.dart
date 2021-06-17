import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/function/find_company_function.dart';
import 'package:mycompany/login/model/company_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';

class FindCompanyView extends StatefulWidget {
  CompanyModel companyModel;

  FindCompanyView({Key? key, required this.companyModel}) : super(key: key);

  @override
  FindCompanyViewState createState() => FindCompanyViewState();
}

class FindCompanyViewState extends State<FindCompanyView> {
  FindCompanyFunction _findCompanyFunction = FindCompanyFunction();
  TextEditingController _companyNameTextController = TextEditingController();

  ValueNotifier<List<CompanyModel>> companyModelList = ValueNotifier<List<CompanyModel>>([]);
  ValueNotifier<bool> isFind = ValueNotifier<bool>(false);

  String keyWord = "";
  int selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(_companyNameTextController.text == "" && widget.companyModel.companyName != ""){
      _findCompanyFunction.findCompanyFunction(companyName: widget.companyModel.companyName, valueNotifier: companyModelList);
      _companyNameTextController.text =widget.companyModel.companyName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      onPressed: () => Navigator.pop(context, widget.companyModel),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'findCompany'.tr(),
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
            companyViewTextFormField(
              topPadding: 44.0.h,
              textEditingController: _companyNameTextController,
              hintText: 'searchByCompanyName'.tr(),
              suffixIcon: textFormSearchButton(),
              onTab: (){
                if(_companyNameTextController.text == ""){
                  keyWord = "";
                  companyModelList.value = [];
                }
              },
              onFieldSubmitted: (text) async {
                if(text == ""){
                  keyWord = text;
                  companyModelList.value = [];
                }
                else{
                  if(keyWord != text){
                    keyWord = text;
                    isFind.value = true;
                    _findCompanyFunction.findCompanyFunction(companyName: text, valueNotifier: companyModelList).whenComplete(() => isFind.value = false);
                    setState(() {
                      selectedIndex = -1;
                    });
                  }
                }
              }
            ),
            ValueListenableBuilder(
              valueListenable: isFind,
              builder: (BuildContext context, bool isFindValue, Widget? child){
                return isFindValue ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ) : ValueListenableBuilder(
                  valueListenable: companyModelList,
                  builder: (BuildContext context, List<CompanyModel> companyModelValue, Widget? child){
                    return companyModelList.value.length == 0 ? showErrorMessage() : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: companyModelValue.length,
                        itemBuilder: (BuildContext context, int index){
                          return companyListButton(index: index, companyModelList: companyModelValue);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        bottomSheet: selectedIndex == -1 ? null : BottomSheet(
          elevation: 0.0,
          onClosing: (){},
          builder: (BuildContext context){
            return Container(
              child: Row(
                children: [
                  bottomSheetButton(
                      buttonName: 'dialogCancel'.tr(),
                      buttonNameColor: textColor,
                      buttonColor: Color(0xffF7F7F7),
                      buttonAction: (){
                        setState(() {
                          selectedIndex = -1;
                        });
                      }
                  ),
                  bottomSheetButton(
                    buttonName: 'dialogSelection'.tr(),
                    buttonNameColor: whiteColor,
                    buttonColor: Color(0xff2093F0),
                    buttonAction: (){
                      widget.companyModel = companyModelList.value[selectedIndex];
                      Navigator.pop(context, widget.companyModel);
                    }
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ElevatedButton companyListButton({required int index, required List<CompanyModel> companyModelList}){
    return ElevatedButton(
      child: Container(
        padding: EdgeInsets.only(
          top: 7.6.h,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 9.0.h,
            horizontal: 27.5.w
          ),
          color: selectedIndex == index ? Color(0xff2093F0).withOpacity(0.1) : null,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 26.0.w,
                height: 26.0.h,
                child: Icon(
                  Icons.location_on,
                  color: Color(0xffBEBEBE),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyModelList[index].companyName,
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: textColor,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        companyModelList[index].companyAddr,
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: Color(0xffA4A4A4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        primary: whiteColor,
        padding: EdgeInsets.zero,
      ),
      onPressed: (){
        FocusScope.of(context).unfocus();
        if(selectedIndex == index){
          setState(() {
            selectedIndex = -1;
          });
        }
        else{
          setState(() {
            selectedIndex = index;
          });
        }
      },
    );
  }

  Container showErrorMessage(){
    return Container(
      padding: EdgeInsets.only(
        top: 205.6.h,
      ),
      alignment: Alignment.center,
      child: Text(
        keyWord == "" ? "검색어를 입력해 주세요" :"검색된 결과가 없습니다",
        style: TextStyle(
          fontSize: 14.0.sp,
          color: textColor,
        ),
      ),
    );
  }

  SizedBox bottomSheetButton({required String buttonName, required Color buttonNameColor, required Color buttonColor, VoidCallback? buttonAction,}){
    return SizedBox(
      width: 180.0.w,
      height: 57.0.h,
      child: ElevatedButton(
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 15.0.sp,
            fontWeight: fontWeight["Medium"],
            color: buttonNameColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          primary: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0.r)
          ),
        ),
        onPressed: buttonAction,
      ),
    );
  }
}