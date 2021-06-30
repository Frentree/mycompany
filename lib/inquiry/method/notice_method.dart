import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mycompany/inquiry/db/inquiry_firestore_repository.dart';
import 'package:mycompany/inquiry/model/notice_comment_model.dart';
import 'package:mycompany/inquiry/model/notice_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/main.dart';
import 'package:mycompany/public/model/public_comment_model.dart';

class NoticeMethod{
  InquiryFirebaseRepository _repository = InquiryFirebaseRepository();

  Future<int> insertNoticeMethod({required UserModel loginUser, required String title,required String content}) async {
    var result = -1;

    NoticeModel model = NoticeModel(noticeTitle: title, noticeContent: content, noticeUid: loginUser.mail.toString(), noticeUname: loginUser.name.toString());

    result = await _repository.insertNotice(companyCode: loginUser.companyCode, model: model);

    return result;
  }

  Future<int> updateNoticeMethod({required UserModel loginUser, required String title,required String content, required NoticeModel nowModel}) async {
    var result = -1;

    NoticeModel model = NoticeModel(noticeTitle: title, noticeContent: content, noticeUid: loginUser.mail.toString(), noticeUname: loginUser.name.toString(), noticeModifyDate: Timestamp.now(), noticeCreateDate: nowModel.noticeCreateDate);

    result = await _repository.updateNotice(companyCode: loginUser.companyCode, model: model, docId: nowModel.reference!.id);

    return result;
  }

  Future<int> insertNoticeCommentMethod({required UserModel loginUser, CommentModel? model, required TextEditingController noticeComment, required NoticeModel noticeMode}) async {
    late CommentModel insertModel;

    var result = -1;

    if (model == null) {
      insertModel = CommentModel(
          level: 0,
          comment: noticeComment.text,
          createDate: Timestamp.now(),
          uid: loginUser.mail,
          uname: loginUser.name,
          commentId: ""
      );
    } else {
      insertModel = CommentModel(
          level: 1,
          comment: noticeComment.text,
          upComment: model.comment,
          upUid: model.uid,
          upUname: model.uname,
          createDate: Timestamp.now(),
          uid: loginUser.mail,
          uname: loginUser.name,
          commentId: model.reference!.id
      );
    }

    result =  await _repository.insertNoticeComment(companyCode: loginUser.companyCode, noticeId: noticeMode.reference!.id, model: insertModel);

    noticeComment.text = "";


    return result;

  }
}


