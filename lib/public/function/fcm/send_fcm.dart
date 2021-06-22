
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/function/public_firebase_repository.dart';


/// USAGE EXAMPLES
/// currentUser : 로그인 유저의 UserModel
/// users : 푸시 메시지를 받을 대상들의 List, 이메일 주소 전달
/// title : 푸시 메시지의 제목
/// message : 푸시 메시지 내용
///           ex) 홍길동 남이 외근 결재 요청 했습니다.
///           이순신 님이 외근 결재를 승인 했습니다.
///           이순신 님이 외근 결재를 반려 했습니다.
///           홍길동 님이 새로운 일정을 등록 했습니다.
///           홍길동 님이 회의 일정을 등록 했습니다.
///           홍길동 님이 공지사항을 등록 했습니다.
///           이순신 님이 공지사항에 댓글을 남겼습니다.
///           강감찬 님이 내 댓글에 댓글을 남겼습니다.
///           출근 시간이 지났습니다. 출근 처리를 해주세요.
///           퇴근 시간이 지났습니다. 퇴근 처리를 해주세요.
/// route : /* 메시지 클릭 시 이동할 페이지 정의 / 현재 기능 구현 안됨 */


Future<void> sendFcmWithTokens(
    UserModel? currentUser, List users, String title, String message, String route) async {

  PublicFirebaseRepository _repository = PublicFirebaseRepository();

  String? _companyCode = currentUser!.companyCode;

  var payload = <String, dynamic>{
    "title": title,
    "message": message,
    "route": route,
  };

  /// Method to write alarm data to firebase
  _repository.saveAlarmDataFromUsersThenSend(currentUser, _companyCode, users, payload);

}
