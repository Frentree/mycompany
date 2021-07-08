import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/attendance/db/attendance_firestore_crud.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/model/employee_model.dart';

class AttendanceFirestoreRepository {
  AttendanceFirestoreCrud _attendanceFirestoreCrud = AttendanceFirestoreCrud.settings();

  Future<void> createAttendanceData({required String companyId, required AttendanceModel attendanceModel}) => _attendanceFirestoreCrud.createAttendanceData(companyId: companyId, attendanceModel: attendanceModel);
  Future<List<AttendanceModel>> readMyAttendanceData({required EmployeeModel employeeData, required Timestamp today}) => _attendanceFirestoreCrud.readMyAttendanceData(employeeData: employeeData, today: today);
  Future<List<AttendanceModel>> readTodayMyAttendanceData({required EmployeeModel employeeData, required Timestamp today}) => _attendanceFirestoreCrud.readTodayMyAttendanceData(employeeData: employeeData, today: today,);
  Future<List<AttendanceModel>> readEmployeeAttendanceData({required EmployeeModel employeeData, required Timestamp today}) => _attendanceFirestoreCrud.readEmployeeAttendanceData(employeeData: employeeData, today: today);
  Future<void> updateAttendanceData({required String companyId, required AttendanceModel attendanceModel}) => _attendanceFirestoreCrud.updateAttendanceData(companyId: companyId, attendanceModel: attendanceModel);
  Future<void> updateOvertime({required String companyId, required String attendanceUserMail, required Timestamp attendanceDate, required int overtime, required bool approvalResult}) => _attendanceFirestoreCrud.updateOvertime(companyId: companyId, attendanceUserMail: attendanceUserMail, attendanceDate: attendanceDate, overtime: overtime, approvalResult: approvalResult);
}
