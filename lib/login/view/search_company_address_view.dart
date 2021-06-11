import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mycompany/login/function/search_company_address_function.dart';
import 'package:mycompany/login/model/road_address_model.dart';
import 'package:mycompany/public/style/color.dart';
import 'package:mycompany/login/widget/login_button_widget.dart';
import 'package:mycompany/login/widget/login_text_form_widget.dart';
import 'package:mycompany/public/style/fontWeight.dart';

class SearchCompanyAddressView extends StatefulWidget {
  CompanyAddress companyAddress;

  SearchCompanyAddressView({Key? key, required this.companyAddress}) : super(key: key);

  @override
  SearchCompanyAddressViewState createState() => SearchCompanyAddressViewState();
}

class SearchCompanyAddressViewState extends State<SearchCompanyAddressView> {
  SearchCompanyAddressFunction _searchCompanyAddressFunction = SearchCompanyAddressFunction();
  TextEditingController _companyAddressTextController = TextEditingController();

  ValueNotifier<List<CompanyAddress>> companyAddressList = ValueNotifier<List<CompanyAddress>>([]);
  ValueNotifier<bool> isFind = ValueNotifier<bool>(false);

  String errorMessage = "";
  String keyWord = "";
  int pageNumber = 1;
  int selectedIndex = -1;

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
                      onPressed: () => Navigator.pop(context, widget.companyAddress),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff2093F0),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'searchAddress'.tr(),
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
              textEditingController: _companyAddressTextController,
              hintText: "도로명 주소 입력",
              suffixIcon: textFormSearchButton(),
              onTab: (){
                if(_companyAddressTextController.text == ""){
                  keyWord = "";
                  companyAddressList.value = [];
                }
              },
              onFieldSubmitted: (text) async {
                if(text == ""){
                  keyWord = text;
                  companyAddressList.value = [];
                }
                else{
                  if(keyWord != text){
                    keyWord = text;
                    isFind.value = true;
                    pageNumber = 1;
                    RoadAddressModel data = await _searchCompanyAddressFunction.searchCompanyAddressFunction(keyWord: text, pageNumber: pageNumber).whenComplete(() => isFind.value = false);
                    if(data.common.errorCode == "0"){
                      companyAddressList.value = data.companyAddressList!;
                    }
                    setState(() {
                      selectedIndex = -1;
                      errorMessage = data.common.errorMessage;
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
                ) : errorMessage == "정상" ? ValueListenableBuilder(
                  valueListenable: companyAddressList,
                  builder: (BuildContext context, List<CompanyAddress> value, Widget? child){
                    return companyAddressList.value.length != 0 ? Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: value.length,
                        itemBuilder: (BuildContext context, int index){
                          if(index == value.length - 100) {
                            pageNumber = pageNumber + 1;
                            _searchCompanyAddressFunction.getMoreCompanyAddressFunction(keyWord: _companyAddressTextController.text, pageNumber: pageNumber, valueNotifier: companyAddressList);
                          }
                          return addressListButton(index: index, companyAddressList: value);
                        },
                      ),
                    ) : showErrorMessage();
                  },
                ) : showErrorMessage();
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
                      widget.companyAddress = companyAddressList.value[selectedIndex];
                      Navigator.pop(context, widget.companyAddress);
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

  ElevatedButton addressListButton({required int index, required List<CompanyAddress> companyAddressList}){
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
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40.0.w,
                    alignment: Alignment.center,
                    child: Text(
                      companyAddressList[index].zipNo,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        color: Color(0xffDC0101),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.0.w,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      companyAddressList[index].bdNm!,
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0.h,
              ),
              Row(
                children: [
                  Container(
                    width: 40.0.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0.r),
                      border: Border.all(
                        color: Color(0xff2093F0),
                      ),
                    ),
                    child: Text(
                      "도로명",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Color(0xff2093F0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.0.w,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        companyAddressList[index].roadAddr,
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0.h,
              ),
              Row(
                children: [
                  Container(
                    width: 40.0.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0.r),
                      border: Border.all(
                        color: Color(0xff2093F0),
                      ),
                    ),
                    child: Text(
                      "지번",
                      style: TextStyle(
                        fontSize: 13.0.sp,
                        color: Color(0xff2093F0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 4.0.w,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        companyAddressList[index].jibunAddr,
                        style: TextStyle(
                          fontSize: 13.0.sp,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ],
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
        keyWord == "" ? "검색어를 입력해 주세요" : errorMessage == "정상"? "검색된 결과가 없습니다" : errorMessage,
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