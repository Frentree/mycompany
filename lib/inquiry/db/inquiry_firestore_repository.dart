
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/inquiry/db/inquiry_firebase_method.dart';
import 'package:mycompany/inquiry/model/notice_model.dart';

class InquiryFirebaseRepository {
  InquiryFirebaseMethod _curd = InquiryFirebaseMethod.setting();

  Future<List<NoticeModel>> getNoticeData({required companyCode}) =>
      _curd.getNoticeData(companyCode);

  Stream<QuerySnapshot> getNoticeComment({required String companyCode, required String docId}) =>
      _curd.getNoticeComment(companyCode, docId);

  Future<int> insertNotice({required companyCode, required model}) =>
      _curd.insertNotice(companyCode, model);

  Future<int> updateNotice({required companyCode, required model, required docId}) =>
      _curd.updateNotice(companyCode, model, docId);

  Future<int> insertNoticeComment({required companyCode, required noticeId, required model}) =>
      _curd.insertNoticeComment(companyCode, noticeId, model);

}