class RoadAddressModel {
  Common common;
  List<Juso>? jusoList;

  RoadAddressModel({
    required this.common,
    this.jusoList,
  });

  factory RoadAddressModel.fromMap(Map<String,dynamic> mapData){
    final results = mapData['results'];
    final common = Common.fromMap(mapData: results['common']);
    List<Juso> jusoList = [];
    if(results['juso'] != null){
      final jusoJsonList = results['juso'] as List;
      jusoList = jusoJsonList.map((item) => Juso.fromMap(mapData: item)).toList();
    }

    return RoadAddressModel(
      common: common,
      jusoList: jusoList,
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

class Juso {
  String roadAddr;
  String roadAddrPart1;
  String? roadAddrPart2;
  String jibunAddr;
  String engAddr;
  String zipNo;
  String admCd;
  String rnMgtSn;
  String bdMgtSn;
  String? detBdNmList;
  String? bdNm;
  String bdKdcd;
  String siNm;
  String? sggNm;
  String emdNm;
  String? liNm;
  String Rn;
  String udrtYn;
  String buldMnnm;
  String buldSlno;
  String mtYn;
  String lnbrMnnm;
  String lnbrSlno;
  String emdNo;
  String hstryYn;
  String relJibun;
  String hemdNm;

  Juso({
    required this.roadAddr,
    required this.roadAddrPart1,
    this.roadAddrPart2,
    required this.jibunAddr,
    required this.engAddr,
    required this.zipNo,
    required this.admCd,
    required this.rnMgtSn,
    required this.bdMgtSn,
    this.detBdNmList,
    this.bdNm,
    required this.bdKdcd,
    required this.siNm,
    this.sggNm,
    required this.emdNm,
    this.liNm,
    required this.Rn,
    required this.udrtYn,
    required this.buldMnnm,
    required this.buldSlno,
    required this.mtYn,
    required this.lnbrMnnm,
    required this.lnbrSlno,
    required this.emdNo,
    required this.hstryYn,
    required this.relJibun,
    required this.hemdNm,
  });

  Juso.fromMap({required Map mapData})
      : roadAddr = mapData["roadAddr"] ?? "",
        roadAddrPart1 = mapData["roadAddrPart1"] ?? "",
        roadAddrPart2 = mapData["roadAddrPart2"] ?? "",
        jibunAddr = mapData["jibunAddr"] ?? "",
        engAddr = mapData["engAddr"] ?? "",
        zipNo = mapData["zipNo"] ?? "",
        admCd = mapData["admCd"] ?? "",
        rnMgtSn = mapData["rnMgtSn"] ?? "",
        bdMgtSn = mapData["bdMgtSn"] ?? "",
        detBdNmList = mapData["detBdNmList"] ?? "",
        bdNm = mapData["dbNm"] ?? "",
        bdKdcd = mapData["bdKdcd"] ?? "",
        siNm = mapData["siNm"] ?? "",
        sggNm = mapData["sggNm"] ?? "",
        emdNm = mapData["emdNm"] ?? "",
        liNm = mapData["liNm"] ?? "",
        Rn = mapData["Rn"] ?? "",
        udrtYn = mapData["udrtYn"] ?? "",
        buldMnnm = mapData["buldMnnm"] ?? "",
        buldSlno = mapData["buldSlno"] ?? "",
        mtYn = mapData["mtYn"] ?? "",
        lnbrMnnm = mapData["lnbrMnnm"] ?? "",
        lnbrSlno = mapData["lnbrSlno"] ?? "",
        emdNo = mapData["emdNo"] ?? "",
        hstryYn = mapData["hstryYn"] ?? "",
        relJibun = mapData["relJibun"] ?? "",
        hemdNm = mapData["hemdNm"] ?? "";
}
