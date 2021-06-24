import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/login/model/user_model.dart';
import 'package:mycompany/public/word/database_name.dart';

class AttendanceFirestoreCrud {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  AttendanceFirestoreCrud.settings({persistenceEnabled: true});

  Future<void> createAttendanceData({required String companyId, required AttendanceModel attendanceModel}) async {
    await _firebaseFirestore
        .collection(COMPANY)
        .doc(companyId)
        .collection(ATTENDANCE)
        .add(attendanceModel.toJson());
  }

  Future<List<AttendanceModel>> readMyAttendanceData({required EmployeeModel employeeData, required Timestamp today}) async {
    List<AttendanceModel> _attendanceData = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection(COMPANY)
        .doc(employeeData.companyCode)
        .collection(ATTENDANCE)
        .where("mail", isEqualTo: employeeData.mail)
        .where("createDate", isLessThanOrEqualTo: today)
        .get();

    querySnapshot.docs.forEach((doc) {
      _attendanceData.add(AttendanceModel.fromMap(mapData: doc.data(), documentId: doc.id));
    });

    return _attendanceData;
  }

  Future<List<AttendanceModel>> readTodayMyAttendanceData({required EmployeeModel employeeData, required Timestamp today}) async {
    List<AttendanceModel> _attendanceData = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection(COMPANY)
        .doc(employeeData.companyCode)
        .collection(ATTENDANCE)
        .where("mail", isEqualTo: employeeData.mail)
        .where("createDate", isEqualTo: today)
        .get();

    querySnapshot.docs.forEach((doc) {
      _attendanceData.add(AttendanceModel.fromMap(mapData: doc.data(), documentId: doc.id));
    });

    return _attendanceData;
  }

  Future<List<AttendanceModel>> readEmployeeAttendanceData({required EmployeeModel employeeData, required Timestamp today}) async {
    List<AttendanceModel> _attendanceData = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection(COMPANY)
        .doc(employeeData.companyCode)
        .collection(ATTENDANCE)
        .where("mail", isNotEqualTo: employeeData.mail)
        .where("createDate", isLessThanOrEqualTo: today)
        .get();

    querySnapshot.docs.forEach((doc) {
      _attendanceData.add(AttendanceModel.fromMap(mapData: doc.data(), documentId: doc.id));
    });

    return _attendanceData;
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
