import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/format/date_format.dart';
import 'package:mycompany/public/word/database_name.dart';

class ExpenseFirebaseCurd {
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  ExpenseFirebaseCurd.setting({persistenceEnabled: true});
  DateFormatCustom _formatCustom = DateFormatCustom();

  // 결재 상태 변화
  Future<void> updatgeExpenseStatusData(UserModel loginUser, String mail, List<dynamic> docsId, String status) async {
    if(docsId.length < 10){
      await _store.collection(COMPANY)
          .doc(loginUser.companyCode)
          .collection(USER)
          .doc(mail)
          .collection(EXPENSE)
          .where("docId", whereIn: docsId)
          .get().then((value) => value.docs.map((e) => e.reference.update({"status" : status})).toList());
    } else {
      int count = (docsId.length / 10).toInt();
      int start = 0;
      int end = 0;
      print("count => " + count.toString());
      for(int i = 0; i < count; i++){
        start = (i*10);
        end = (i*10+9);
        if(end > docsId.length){
          end = (docsId.length);
        }

        await _store.collection(COMPANY)
            .doc(loginUser.companyCode)
            .collection(USER)
            .doc(mail)
            .collection(EXPENSE)
            .where("docId", whereIn: docsId.sublist(start, end))
            .get().then((value) => value.docs.map((e) => e.reference.update({"status" : status})).toList());
      }
    }
  }

  // 결재 경비 목록
  Future<List<ExpenseModel>> getExpenseData(UserModel loginUser, String mail, List<dynamic> docsId) async {
    List<ExpenseModel> expenseList = [];

    if(docsId.length < 10){
      return await _store.collection(COMPANY)
          .doc(loginUser.companyCode)
          .collection(USER)
          .doc(mail)
          .collection(EXPENSE)
          .where("docId", whereIn: docsId)
          .get().then((value) => value.docs.map((e) => ExpenseModel.fromMap(mapData: e.data(), reference: e.reference)).toList());
    } else {
      int count = (docsId.length / 10).toInt();
      int start = 0;
      int end = 0;

      print("count => " + count.toString());
      for(int i = 0; i <= count; i++){
        start = (i*10);
        end = (i*10+9);
        if(end > docsId.length){
          end = (docsId.length);
        }
        await _store.collection(COMPANY)
            .doc(loginUser.companyCode)
            .collection(USER)
            .doc(mail)
            .collection(EXPENSE)
            .where("docId", whereIn: docsId.sublist(start, end))
            .get().then((value) => value.docs.map((e) => expenseList.add(ExpenseModel.fromMap(mapData: e.data(), reference: e.reference))).toList());
      }
    }
/*
    await _store.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(USER)
        .doc(mail)
        .collection(EXPENSE)
        .where("docId", whereIn: docsId)
        .get().then((value) => value.docs.map((e) => ExpenseModel.fromMap(mapData: e.data(), reference: e.reference)).toList());*/

    return expenseList;
  }

  // 경비 추가
  Future<void> addExpense(UserModel loginUser, ExpenseModel model) async {
    await _store.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(USER)
        .doc(loginUser.mail)
        .collection(EXPENSE)
        .add(model.toJson()).then((value) => value.update({"docId" : value.id}));
  }

  // 경비 리스트
  Stream<List<ExpenseModel>> getExpense(UserModel loginUser) {
    return _store.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(USER)
        .doc(loginUser.mail)
        .collection(EXPENSE)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => ExpenseModel.fromMap(mapData: document.data() as dynamic, reference: document.reference))
        .toList());
  }

  Stream<List<ApprovalModel>> getApprovalExpensed(UserModel loginUser) {
    return _store.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(WORKAPPROVAL)
        .where("approvalType", isEqualTo: "경비")
        .where("status", isEqualTo: "승인")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => ApprovalModel.fromMap(mapData: document.data() as dynamic, reference: document.reference))
        .toList());
  }

  Stream<List<ApprovalModel>> getMyApprovalExpensed(UserModel loginUser) {
    return _store.collection(COMPANY)
        .doc(loginUser.companyCode)
        .collection(WORKAPPROVAL)
        .where("userMail", isEqualTo: loginUser.mail)
        .where("approvalType", isEqualTo: "경비")
        .where("status", isEqualTo: "승인")
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((document) => ApprovalModel.fromMap(mapData: document.data() as dynamic, reference: document.reference))
        .toList());
  }

}