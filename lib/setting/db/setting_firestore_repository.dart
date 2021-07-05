import 'package:mycompany/setting/db/setting_firestore_crud.dart';
import 'package:mycompany/setting/model/wifi_model.dart';

class SettingFirestoreRepository {
  SettingFirestoreCrud _settingFirestoreCrud = SettingFirestoreCrud.settings();

  //WIFI 관련
  Future<void> createWifiData({required String companyId, required WifiModel wifiModel}) => _settingFirestoreCrud.createWifiData(companyId: companyId, wifiModel: wifiModel);
  Future<List<WifiModel>> readWifiData({required String companyId}) => _settingFirestoreCrud.readWifiData(companyId: companyId);
  Future<List<String>> readWifiName({required String companyId}) => _settingFirestoreCrud.readWifiName(companyId: companyId);
  Future<void> deleteWifiData({required String companyId, required WifiModel wifiModel}) => _settingFirestoreCrud.deleteWifiData(companyId: companyId, wifiModel: wifiModel);
}