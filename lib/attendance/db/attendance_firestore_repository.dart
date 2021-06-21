import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycompany/attendance/db/attendance_firestore_crud.dart';
import 'package:mycompany/attendance/model/attendance_model.dart';
import 'package:mycompany/login/model/employee_model.dart';

class AttendanceFirestoreRepository {
  AttendanceFirestoreCrud _attendanceFirestoreCrud = AttendanceFirestoreCrud();

  Future<void> createAttendanceData({required String companyId, required AttendanceModel attendanceModel}) => _attendanceFirestoreCrud.createAttendanceData(companyId: companyId, attendanceModel: attendanceModel);
  Future<List<AttendanceModel>> readMyAttendanceData({required EmployeeModel employeeData}) => _attendanceFirestoreCrud.readMyAttendanceData(employeeData: employeeData);
  Future<List<AttendanceModel>> readMyAttendanceDataWithPeriod({required EmployeeModel employeeData, required Timestamp minimumDate, required Timestamp maximumDate}) => _attendanceFirestoreCrud.readMyAttendanceDataWithPeriod(employeeData: employeeData, minimumDate: minimumDate, maximumDate: maximumDate);
  Future<void> updateAttendanceData({required String companyId, required AttendanceModel attendanceModel}) => _attendanceFirestoreCrud.updateAttendanceData(companyId: companyId, attendanceModel: attendanceModel);
}
