// firebase function

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/jh_test/jh_localDB/expenseModel.dart';

class FirebaseIORepository{
  final FirebaseIOMethods _firebaseIOMethods = FirebaseIOMethods();

  Future<DocumentReference> saveExpense(ExpenseModel expenseModel) =>
      _firebaseIOMethods.saveExpense(expenseModel);

  Stream<QuerySnapshot> getExpense(String companyCode, String uid) =>
      _firebaseIOMethods.getExpense(companyCode, uid);

  Future<void> deleteExpense(String companyCode, String documentID, String uid) =>
      _firebaseIOMethods.deleteExpense(companyCode, documentID, uid);


}

class FirebaseIOMethods{
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentReference> saveExpense(ExpenseModel expenseModel) async {
    var map = expenseModel.toMap();
    // Map<String, dynamic> map = expenseModel.toMap()
    var stringMap = map.map((key, value) => MapEntry(key as String, value));
    // var stringMap = {for (var e in map.entries) e.key as String: e.value};

    Future<DocumentReference> doc = _firestore
        .collection("company")
        .doc(expenseModel.companyCode)
        .collection("user")
        .doc(expenseModel.mail)
        .collection("expense")
        .add(stringMap);

    return doc;
  }

  Stream<QuerySnapshot> getExpense(String companyCode, String uid) {
    return _firestore
        .collection("company")
        .doc(companyCode)
        .collection("user")
        .doc(uid)
        .collection("expense")
        .orderBy("buyDate", descending: true)
        .snapshots();
  }

  Future<void> deleteExpense(
      String companyCode, String documentID, String uid) async {
    return await _firestore
        .collection("company")
        .doc(companyCode)
        .collection("user")
        .doc(uid)
        .collection("expense")
        .doc(documentID)
        .delete();
  }


}
