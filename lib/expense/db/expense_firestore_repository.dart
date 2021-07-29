
import 'package:mycompany/approval/model/approval_model.dart';
import 'package:mycompany/expense/db/expense_firebase_crud.dart';
import 'package:mycompany/expense/model/expense_model.dart';
import 'package:mycompany/login/model/user_model.dart';

class ExpenseFirebaseRepository {
  ExpenseFirebaseCurd _methods = ExpenseFirebaseCurd.setting();

  Future<void> updatgeExpenseStatusData({required UserModel loginUser, required List<dynamic> docsId, required String status}) =>
      _methods.updatgeExpenseStatusData(loginUser, docsId, status);

  Future<List<ExpenseModel>> getExpenseData({required UserModel loginUser,required List<dynamic> docsId}) =>
      _methods.getExpenseData(loginUser, docsId);


  Stream<List<ExpenseModel>> getExpense({required UserModel loginUser}) =>
      _methods.getExpense(loginUser);

  Future<void> addExpense({required UserModel loginUser,required ExpenseModel model}) =>
      _methods.addExpense(loginUser, model);

  Stream<List<ApprovalModel>> getApprovalExpensed({required UserModel loginUser}) =>
      _methods.getApprovalExpensed(loginUser);
}