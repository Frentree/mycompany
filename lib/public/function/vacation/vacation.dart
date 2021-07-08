import 'package:mycompany/public/function/public_firebase_repository.dart';

/// UsedVacation(
/// 1. String 회사코드,
/// 2. String 유저 이메일,
/// 3. String 입사일,
/// 4. Boolean 계산 방식(입사일 - False / 회계연도 - True,
/// )
/// return Future<double>(총 사용 연차 수)
/*
double UsedVacation(
    String? companyCode, String? mail, String? date, bool type) {
  print('================== S T A R T UsedVacation ==================');
  print('입사일 : $date');
  double result = 0.0;
  PublicFirebaseRepository _repository = PublicFirebaseRepository();
  String? _enteredDate = date;
  DateTime _present = DateTime.now();

  _enteredDate = _enteredDate?.replaceAll('.', '');

  if(_enteredDate == ""){
    return result;
  }

  DateTime _enterDate = DateTime.parse(_enteredDate!);

  /// 입사일 기준
  if (!type) {
    print('입사일 기준');
    var _sub = DateTime(0, _present.month - _enterDate.month + 1,
        _present.day - _enterDate.day + 1);
    String _yearChecker = DateTime(_sub.year).toString()[0];
    if (_yearChecker == '0') {
      var _double =  _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_present.year, _enterDate.month, _enterDate.day),
          DateTime(_present.year, _present.month, _present.day));
      _double.then((data) async {
        result = await data;
        print('inside function result is : $result');
      });
      print(
          '${_present.year}.${_enterDate.month}.${_enterDate.day} ~ ${_present.year}.${_present.month}.${_present.day}');
    } else {
      Future _double =  _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_present.year - 1, _enterDate.month, _enterDate.day),
          DateTime(_present.year, _present.month, _present.day));
      _double.then((data) async {
        result = await data;
        print('inside function result is : $result');
      });
      print(
          '${_present.year - 1}.${_enterDate.month}.${_enterDate.day} ~ ${_present.year}.${_present.month}.${_present.day}');
    }
  }

  /// 회계연도 기준
  if (type) {
    print('회계연도 기준');

    if (_present.year - _enterDate.year >= 2) {
      Future _double = _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_present.year, 1, 1),
          DateTime(_present.year, _present.month, _present.day));
      _double.then((data) {
        result = data;
        print('inside function result is : $result');
      });
      print(
          '${_present.year}.01.01 ~ ${_present.year}.${_present.month}.${_present.day}');
    } else {
      Future _double = _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_enterDate.year, _enterDate.month, _enterDate.day),
          DateTime(_present.year, _present.month, _present.day));
      _double.then((data) {
        result = data;
        print('inside function result is : $result');
      });
      print(
          '${_enterDate.year}.${_enterDate.month}.${_enterDate.day} ~ ${_present.year}.${_present.month}.${_present.day}');
    }
  }
  print('result is $result');
  return result;
}*/

Future<double> UsedVacation(
    String? companyCode, String? mail, String? date, bool type) async {
  double result = 0.0;
  PublicFirebaseRepository _repository = PublicFirebaseRepository();
  String? _enteredDate = date;
  DateTime _present = DateTime.now();

  _enteredDate = _enteredDate?.replaceAll('.', '');

  if(_enteredDate == ""){
    return result;
  }

  DateTime _enterDate = DateTime.parse(_enteredDate!);

  /// 입사일 기준
  if (!type) {
    print('입사일 기준');
    var _sub = DateTime(0, _present.month - _enterDate.month + 1,
        _present.day - _enterDate.day + 1);
    String _yearChecker = DateTime(_sub.year).toString()[0];
    if (_yearChecker == '0') {
      result = await  _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_present.year, _enterDate.month, _enterDate.day),
          DateTime(_present.year, _present.month, _present.day));
      print(
          '${_present.year}.${_enterDate.month}.${_enterDate.day} ~ ${_present.year}.${_present.month}.${_present.day}');
    } else {
      result = await  _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_present.year - 1, _enterDate.month, _enterDate.day),
          DateTime(_present.year, _present.month, _present.day));
      print(
          '${_present.year - 1}.${_enterDate.month}.${_enterDate.day} ~ ${_present.year}.${_present.month}.${_present.day}');
    }
  }

  /// 회계연도 기준
  if (type) {
    print('회계연도 기준');

    if (_present.year - _enterDate.year >= 2) {
      result = await _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_present.year, 1, 1),
          DateTime(_present.year, _present.month, _present.day));
      print(
          '${_present.year}.01.01 ~ ${_present.year}.${_present.month}.${_present.day}');
    } else {
      result = await _repository.usedVacationWithDuration(
          companyCode,
          mail,
          DateTime(_enterDate.year, _enterDate.month, _enterDate.day),
          DateTime(_present.year, _present.month, _present.day));
      print(
          '${_enterDate.year}.${_enterDate.month}.${_enterDate.day} ~ ${_present.year}.${_present.month}.${_present.day}');
    }
  }
  print('result is $result');
  return result;
}

/// TotalVacation(
/// 1. String 입사일,
/// 2. Boolean 계산 방식(입사일 - False / 회계연도 - True,
/// 3. double 추가 연차
/// )
/// return double(총 연차 수)

double TotalVacation(String date, bool type, double addition) {
  print('================== S T A R T TotalVacation ==================');
  print('입사일 : $date');
  double result = 0.0;

  String? _enteredDate = date;
  DateTime _present = DateTime.now();

  _enteredDate = _enteredDate.replaceAll('.', '');

  if(_enteredDate == ""){
    return 0;
  }

  DateTime _tmp = DateTime.parse(_enteredDate);

  /// 입사일 기준
  if (!type) {
    var _sub = DateTime(_present.year - _tmp.year, _present.month - _tmp.month,
        _present.day - _tmp.day);
    String _yearChecker = DateTime(_sub.year - 1).toString()[0];
    if (_yearChecker == '0') {
      return MoreThanOneWithEnteredDate(_tmp, addition);
    }
    return LessThanOneWithEnteredDate(_tmp, addition);
  }

  /// 회계연도 기준
  if (type) {
    if (_present.year >= _tmp.year + 2) {
      MoreThanThird(_tmp, addition);
    } else if (_present.year == _tmp.year + 1) {
      SecondYear(_tmp, addition);
    } else {
      FirstYear(_tmp, addition);
    }
  }
  return result;
}

double MoreThanOneWithEnteredDate(DateTime date, double addition) {
  print('MoreThanOneWithEnteredDate');
  double result = 0.0;
  DateTime _present = DateTime.now();
  DateTime _sub = DateTime(_present.year - date.year,
      _present.month - date.month, _present.day - date.day + 1);

  result = 15.0 + (_sub.year - 1) ~/ 2 + addition;

  print(result);

  if (result < 0) {
    result = 0;
  }

  return result;
}

double LessThanOneWithEnteredDate(DateTime date, double addition) {
  print('LessThanOneWithEnteredDate');
  double result = 0.0;
  DateTime _present = DateTime.now();
  DateTime _sub = DateTime(_present.year - date.year,
      _present.month - date.month, _present.day - date.day + 1);

  print(_sub);
  result = 0.0 + _sub.month + addition;

  if (result < 0) {
    result = 0;
  }

  print(result);
  return result;
}

double FirstYear(DateTime date, double addition) {
  print('FirstYear');
  double result = 0.0;
  DateTime _present = DateTime.now();
  DateTime _sub = DateTime(_present.year - date.year,
      _present.month - date.month, _present.day - date.day + 1);

  print(_sub);

  result = 0.0 + _sub.month;

  if (result < 0) {
    result = 0;
  }

  print(result);
  return result;
}

double SecondYear(DateTime date, double addition) {
  print('SecondYear');
  double result = 0.0;
  DateTime _present = DateTime.now();
  DateTime _sub = DateTime(_present.year - date.year,
      _present.month - date.month, _present.day - date.day + 1);

  /// 전년도 근무 일수 계산
  DateTime _lastDay = DateTime(date.year, 12, 31);
  int _days = _lastDay.difference(date).inDays;

  result += (_days / 365) * 15;

  if (_present.isBefore(DateTime(date.year + 1, date.month, date.day))) {
    result += _present.month;
  }

  if (result < 0) {
    result = 0;
  }

  print(result);
  return result;
}

double MoreThanThird(DateTime date, double addition) {
  print('MoreThanThird');
  double result = 0.0;
  DateTime _present = DateTime.now();
  DateTime _sub = DateTime(_present.year - date.year,
      _present.month - date.month, _present.day - date.day + 1);

  result = 15.0 + (_sub.year - 2) ~/ 2 + addition;

  if (result < 0) {
    result = 0;
  }

  print(result);
  return result;
}

//   TotalVacation(date, type, addition);
//   TotalVacation('2019.10.10', false, 0);
//   TotalVacation('2020.10.10', false, 0);
//   TotalVacation('2010.01.01', true, 0);
//   TotalVacation('2010.10.10', true, 0);
//   TotalVacation('2011.10.10', true, 0);
//   TotalVacation('2012.10.10', true, 0);
//   TotalVacation('2013.10.10', true, 0);
//   TotalVacation('2014.10.10', true, 0);
//   TotalVacation('2015.10.10', true, 0);
//   TotalVacation('2016.10.10', true, 0);
//   TotalVacation('2017.10.10', true, 0);
//   TotalVacation('2018.10.10', true, 0);
//   TotalVacation('2019.10.10', true, 0);

//   print('');
//   print('=============== second year ===============');
//   print('');
//   TotalVacation('2020.01.10', true, 0);
//   TotalVacation('2020.04.10', true, 0);
//   TotalVacation('2020.06.10', true, 0);
//   TotalVacation('2020.07.10', true, 0);
//   TotalVacation('2020.10.10', true, 0);
//   TotalVacation('2020.11.10', true, 0);
//   print('');
//   print('=============== first year ===============');
//   print('');
//   TotalVacation('2021.01.01', true, 0);
//   TotalVacation('2021.03.01', true, 0);
//   TotalVacation('2021.09.01', true, 0);
//   TotalVacation('2021.11.01', true, 0);

//   print('');
//   print('=============== With Shiftee ===============');
//   print('');

//   TotalVacation('2010.01.01', false, 0);
//   TotalVacation('2010.01.01', true, 0);

//
// TotalVacation('2017.01.02', false, 0);
// TotalVacation('2017.01.02', true, 0);
// print('');
// TotalVacation('2018.01.02', false, 0);
// TotalVacation('2018.01.02', true, 0);
// print('');
// TotalVacation('2019.01.02', false, 0);
// TotalVacation('2019.01.02', true, 0);
// print('');
// TotalVacation('2020.01.02', false, 0);
// TotalVacation('2020.01.02', true, 0);
// print('');
// TotalVacation('2021.01.02', false, 0);
// TotalVacation('2021.01.03', true, 0);

void testForUsedVacation() {
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.01.01', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.01.03', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.02.01', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.02.02', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.10.23', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2019.10.23', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2020.01.01', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2020.10.23', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.01.01', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.01.02', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.05.01', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.06.01', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.06.02', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.06.03', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.07.01', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.07.02', false);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.07.03', false);

  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.01.01', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.01.03', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.02.01', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.02.02', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2018.10.23', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2019.10.23', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2020.01.01', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2020.10.23', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.01.01', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.01.02', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.05.01', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.06.01', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.06.02', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.06.03', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.07.01', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.07.02', true);
  UsedVacation('0S9YLBX', 'jun@frentree.com', '2021.07.03', true);
}
