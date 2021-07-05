import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/public/word/database_name.dart';
import 'package:mycompany/setting/model/wifi_model.dart';

class SettingFirestoreCrud {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  SettingFirestoreCrud.settings({persistenceEnabled: true});

  //WIFI 관련
  Future<void> createWifiData({required String companyId, required WifiModel wifiModel}) async {
    wifiModel.registrationDate = Timestamp.now();

    await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(WIFI).add(wifiModel.toJson());
  }

  Future<List<WifiModel>> readWifiData({required String companyId}) async {
    List<WifiModel> wifiData = [];

    QuerySnapshot<Map<String, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(WIFI).get();

    wifiData = getData.docs.map((doc) => WifiModel.fromMap(mapData: doc.data(), documentId: doc.id)).toList();

    return wifiData;
  }

  Future<List<String>> readWifiName({required String companyId}) async {
    List<String> wifiName = [];

    QuerySnapshot<Map<String, dynamic>> getData = await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(WIFI).get();

    getData.docs.map((doc) => WifiModel.fromMap(mapData: doc.data(), documentId: doc.id)).toList().forEach((element) {
      wifiName.add(element.wifiName);
    });

    return wifiName;
  }

  Future<void> deleteWifiData({required String companyId, required WifiModel wifiModel}) async {
    await _firebaseFirestore.collection(COMPANY).doc(companyId).collection(WIFI).doc(wifiModel.documentId).delete();
  }
}


