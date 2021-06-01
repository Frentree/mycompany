import 'dart:convert';
import 'package:http/http.dart';
import 'package:mycompany/login/model/road_address_model.dart';
import 'package:flutter/material.dart';

class SearchCompanyAddressFunction{
  String apiKey = "U01TX0FVVEgyMDIxMDUyNDExNDgwODExMTE5NjA=";

  Future<RoadAddressModel> searchCompanyAddressFunction({required String keyWord, required int pageNumber}) async {
    String url = "https://www.juso.go.kr/addrlink/addrLinkApi.do?confmKey=$apiKey&currentPage=$pageNumber&countPerPage=100&keyword=$keyWord&resultType=json";

    Response response = await get(Uri.parse(url));
    String bodyString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> body = jsonDecode(bodyString);

    return RoadAddressModel.fromMap(body);
  }

  Future<void> getMoreCompanyAddressFunction({required String keyWord, required int pageNumber, required ValueNotifier<List<CompanyAddress>> valueNotifier,}) async {
    List<CompanyAddress> _companyAddressList = valueNotifier.value;
    RoadAddressModel roadAddressModel = await searchCompanyAddressFunction(keyWord: keyWord, pageNumber: pageNumber);

    _companyAddressList.addAll(roadAddressModel.companyAddressList!);

    valueNotifier.value = _companyAddressList.toList();
  }
}
