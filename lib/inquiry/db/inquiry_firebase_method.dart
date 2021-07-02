

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/inquiry/model/notice_comment_model.dart';
import 'package:mycompany/inquiry/model/notice_model.dart';
import 'package:mycompany/public/model/public_comment_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class InquiryFirebaseMethod{
  final FirebaseFirestore _store = FirebaseFirestore.instance;
  InquiryFirebaseMethod.setting({persistenceEnabled: true});

  Future<List<NoticeModel>> getNoticeData(String companyCode) async {
    List<NoticeModel> noticeList = [];
    var doc = await _store.collection(COMPANY).doc(companyCode).collection(NOTICE).get();

    doc.docs.map((e) => noticeList.add(NoticeModel.fromMap(mapData: e.data(), reference: e.reference))).toList();

    noticeList.sort((a, b) => b.noticeCreateDate!.compareTo(a.noticeCreateDate!));

    return noticeList;

  }

  Stream<QuerySnapshot> getNoticeComment(String companyCode, String docId) {
    return _store.collection(COMPANY).doc(companyCode).collection(NOTICE).doc(docId).collection(COMMENT).snapshots();
  }
/*
  getNoticeComments(String companyCode, String docId) async {
    return _store.collection(COMPANY).doc(companyCode).collection(NOTICE).doc(docId).collection(NOTICECOMMENT).snapshots();
  }*/

  Future<int> insertNotice(String companyCode, NoticeModel model) async {
    var result = -1;
    await _store.collection(COMPANY).doc(companyCode).collection(NOTICE).add(model.toJson())
        .whenComplete(() => {result = 0});

    return result;
  }

  Future<int> updateNotice(String companyCode, NoticeModel model, String docId) async {
    var result = -1;
    await _store.collection(COMPANY).doc(companyCode).collection(NOTICE).doc(docId).update(model.toJson())
        .whenComplete(() => {result = 0});

    return result;
  }

  Future<int> insertNoticeComment(String companyCode, String noticeId, CommentModel model) async {
    var result = -1;
    await _store.collection(COMPANY).doc(companyCode).collection(NOTICE).doc(noticeId).collection(COMMENT).add(model.toJson())
        .whenComplete(() => {result = 0});

    return result;
  }


}