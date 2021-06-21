import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class AttendanceFirestoreCrud {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createAttendanceData({required String companyId, required AttendanceModel attendanceModel}) async {
    await _firebaseFirestore
        .collection(COMPANY)
        .doc(companyId)
        .collection(ATTENDANCE)
        .add(attendanceModel.toJson());
  }

  Future<List<AttendanceModel>> readMyAttendanceData({required EmployeeModel employeeData}) async {
    List<AttendanceModel> _attendanceData = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection(COMPANY)
        .doc(employeeData.companyCode)
        .collection(ATTENDANCE)
        .where("mail", isEqualTo: employeeData.mail)
        .get();

    querySnapshot.docs.forEach((doc) {
      _attendanceData.add(AttendanceModel.fromMap(mapData: doc.data()));
    });

    return _attendanceData;
  }

  Future<List<AttendanceModel>> readMyAttendanceDataWithPeriod({required EmployeeModel employeeData, required Timestamp minimumDate, required Timestamp maximumDate}) async {
    List<AttendanceModel> _attendanceData = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection(COMPANY)
        .doc(employeeData.companyCode)
        .collection(ATTENDANCE)
        .where("mail", isEqualTo: employeeData.mail)
        .where("createDate", isGreaterThanOrEqualTo: minimumDate)
        .where("createDate", isLessThanOrEqualTo: maximumDate)
        .get();

    print(querySnapshot.docs.length);

    querySnapshot.docs.forEach((doc) {
      print(doc.id);
      _attendanceData.add(AttendanceModel.fromMap(mapData: doc.data(), documentId: doc.id));
    });

    return _attendanceData;
  }

  Future<EmployeeModel> readAllEmployeeAttendanceData({required String companyId, required String email}) async {
    dynamic document = await _firebaseFirestore
        .collection(COMPANY)
        .doc(companyId)
        .collection(USER)
        .doc(email)
        .get();

    return EmployeeModel.fromMap(mapData: document.data());
  }

  Future<void> updateAttendanceData({required String companyId, required AttendanceModel attendanceModel}) async {
    await _firebaseFirestore
        .collection(COMPANY)
        .doc(companyId)
        .collection(ATTENDANCE)
        .doc(attendanceModel.documentId)
        .update(attendanceModel.toJson());
  }
}
