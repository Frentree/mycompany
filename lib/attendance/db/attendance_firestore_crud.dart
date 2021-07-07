import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/model/employee_model.dart';
import 'package:mycompany/public/format/date_format.dart';
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

  Future<void> updateOvertime({required String companyId, required String attendanceUserMail, required Timestamp attendanceDate, required int overtime}) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firebaseFirestore
        .collection(COMPANY)
        .doc(companyId)
        .collection(ATTENDANCE)
        .where("mail", isEqualTo: attendanceUserMail)
        .where("createDate", isEqualTo: attendanceDate)
        .get();

    AttendanceModel attendanceData = AttendanceModel.fromMap(mapData: querySnapshot.docs.first.data(), documentId: querySnapshot.docs.first.id);

    attendanceData.overTime = attendanceData.overTime! + overtime;

    await updateAttendanceData(
      companyId: companyId,
      attendanceModel: attendanceData
    );
  }
}
