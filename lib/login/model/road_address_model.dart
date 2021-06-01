class RoadAddressModel {
  Common common;
  List<CompanyAddress>? companyAddressList;

  RoadAddressModel({
    required this.common,
    this.companyAddressList,
  });

  factory RoadAddressModel.fromMap(Map<String,dynamic> mapData){
    final results = mapData['results'];
    final common = Common.fromMap(mapData: results['common']);
    List<CompanyAddress> companyAddressList = [];
    if(results['juso'] != null){
      final jusoJsonList = results['juso'] as List;
      companyAddressList = jusoJsonList.map((item) => CompanyAddress.fromMap(mapData: item)).toList();
    }

    return RoadAddressModel(
      common: common,
      companyAddressList: companyAddressList,
    );
  }
}

class Common {
  String errorMessage;
  String countPerPage;
  String totalCount;
  String errorCode;
  String currentPage;

  Common({
    required this.errorMessage,
    required this.countPerPage,
    required this.totalCount,
    required this.errorCode,
    required this.currentPage,
  });

  Common.fromMap({required Map mapData})
      : errorMessage = mapData["errorMessage"] ?? "",
        countPerPage = mapData["countPerPage"] ?? "",
        totalCount = mapData["totalCount"] ?? "",
        errorCode = mapData["errorCode"] ?? "",
        currentPage = mapData["currentPage"] ?? "";
}

class CompanyAddress {
  String roadAddr;
  String jibunAddr;
  String engAddr;
  String zipNo;
  String? detBdNmList;
  String? bdNm;

  CompanyAddress({
    required this.roadAddr,
    required this.jibunAddr,
    required this.engAddr,
    required this.zipNo,
    this.detBdNmList,
    this.bdNm,
  });

  CompanyAddress.fromMap({required Map mapData})
      : roadAddr = mapData["roadAddr"] ?? "",
        jibunAddr = mapData["jibunAddr"] ?? "",
        engAddr = mapData["engAddr"] ?? "",
        zipNo = mapData["zipNo"] ?? "",
        detBdNmList = mapData["detBdNmList"] ?? "",
        bdNm = mapData["bdNm"] ?? "";
}
