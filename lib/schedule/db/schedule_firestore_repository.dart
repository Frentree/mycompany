
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/schedule/db/schedule_firestore_crud.dart';

class ScheduleFirebaseReository {
  ScheduleFirebaseCurd _curd = ScheduleFirebaseCurd();

  Future<QuerySnapshot> getSchedules({String? companyCode}) =>
      _curd.getSchedules(companyCode);

  Future<QuerySnapshot> getCompanyUser({String? companyCode}) =>
      _curd.getCompanyUser(companyCode);

  Future<QuerySnapshot> getTeamDocument({String? companyCode}) =>
      _curd.getTeamDocument(companyCode);
}