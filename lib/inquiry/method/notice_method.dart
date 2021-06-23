import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycompany/inquiry/db/inquiry_firestore_repository.dart';
import 'package:mycompany/inquiry/model/notice_comment_model.dart';
import 'package:mycompany/inquiry/model/notice_model.dart';
import 'package:mycompany/main.dart';

class NoticeMethod{
  InquiryFirebaseRepository _repository = InquiryFirebaseRepository();

  Future<int> insertNoticeMethod({required String companyCode, required String title,required String content}) async {
    var result = -1;

    NoticeModel model = NoticeModel(noticeTitle: title, noticeContent: content, noticeUid: loginUser!.mail.toString(), noticeUname: loginUser!.name.toString());

    result = await _repository.insertNotice(companyCode: companyCode, model: model);

    return result;
  }

  Future<int> updateNoticeMethod({required String companyCode, required String title,required String content, required NoticeModel nowModel}) async {
    var result = -1;

    NoticeModel model = NoticeModel(noticeTitle: title, noticeContent: content, noticeUid: loginUser!.mail.toString(), noticeUname: loginUser!.name.toString(), noticeModifyDate: Timestamp.now(), noticeCreateDate: nowModel.noticeCreateDate);

    result = await _repository.updateNotice(companyCode: companyCode, model: model, docId: nowModel.reference!.id);

    return result;
  }

  Future<int> insertNoticeCommentMethod({required String companyCode, NoticeCommentModel? model, required TextEditingController noticeComment, required NoticeModel noticeMode}) async {
    late NoticeCommentModel insertModel;

    var result = -1;

    if (model == null) {
      insertModel = NoticeCommentModel(
          level: 0,
          noticeComment: noticeComment.text,
          noticeCreateDate: Timestamp.now(),
          noticeUid: loginUser!.mail,
          noticeUname: loginUser!.name,
          noticeCommentId: ""
      );
    } else {
      insertModel = NoticeCommentModel(
          level: 1,
          noticeComment: noticeComment.text,
          noticeUpComment: model.noticeComment,
          noticeUpUid: model.noticeUid,
          noticeUpUname: model.noticeUname,
          noticeCreateDate: Timestamp.now(),
          noticeUid: loginUser!.mail,
          noticeUname: loginUser!.name,
          noticeCommentId: model.reference!.id
      );
    }

    result =  await _repository.insertNoticeComment(companyCode: companyCode, noticeId: noticeMode.reference!.id, model: insertModel);

    noticeComment.text = "";


    return result;

  }
}


