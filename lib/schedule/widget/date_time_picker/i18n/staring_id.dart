import 'package:mycompany/schedule/widget/date_time_picker/date_time_picker_i18n.dart';

/// Indonesia (ID)
class StringsId extends StringsI18n {
  const StringsId();

  @override
  String getCancelText() {
    return 'Batalkan';
  }

  @override
  String getDoneText() {
    return 'Simpan';
  }

  @override
  List<String> getMonths() {
    return [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
  }

  @override
  List<String>? getMonthsShort() {
    return null;
  }

  @override
  List<String> getWeeksFull() {
    return ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  }

  @override
  List<String> getWeeksShort() {
    return ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  }
}
