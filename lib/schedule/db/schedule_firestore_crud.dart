

import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleFirebaseCurd {
  final FirebaseFirestore _store = FirebaseFirestore.instance;

  Future<QuerySnapshot> getSchedules(String? companyCode) async {
    return await _store.collection("company").doc(companyCode).collection("work").get();
  }

}