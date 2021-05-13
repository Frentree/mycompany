import 'package:syncfusion_flutter_core/core.dart';
import 'enums.dart';

/// Holds the static helper methods used for date calculation in calendar.
class DateTimeHelper {
  /// Calculate the visible dates count based on calendar view
  static int getViewDatesCount(CalendarView calendarView, int numberOfWeeks) {
    switch (calendarView) {
      case CalendarView.month:
        return DateTime.daysPerWeek * numberOfWeeks;
      case CalendarView.week:
      case CalendarView.workWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.timelineWeek:
        return DateTime.daysPerWeek;
      case CalendarView.timelineDay:
      case CalendarView.day:
      case CalendarView.schedule:
        return 1;
      case CalendarView.timelineMonth:

      /// 6 represents the number of weeks in view, we have used this static,
      /// since timeline month doesn't support the number of weeks in view.
        return DateTime.daysPerWeek * 6;
    }
  }

  /// Returns the list of current month dates alone from the dates passed.
  static List<DateTime> getCurrentMonthDates(List<DateTime> visibleDates) {
    final int visibleDatesCount = visibleDates.length;
    final int currentMonth = visibleDates[visibleDatesCount ~/ 2].month;
    final List<DateTime> currentMonthDates = <DateTime>[];
    for (int i = 0; i < visibleDatesCount; i++) {
      final DateTime currentVisibleDate = visibleDates[i];
      if (currentVisibleDate.month != currentMonth) {
        continue;
      }

      currentMonthDates.add(currentVisibleDate);
    }

    return currentMonthDates;
  }

  /// Calculate the next view visible start date based on calendar view.
  static DateTime getNextViewStartDate(
      CalendarView calendarView, int numberOfWeeksInView, DateTime date) {
    late final DateTime nextMonthStartDate;
    dynamic nextMonthDate;
    switch (calendarView) {
      case CalendarView.month:
      case CalendarView.timelineMonth:
        {
          /// The timeline month view renders the current month dates alone,
          /// hence it doesn't support the numberOfWeekInView.
          nextMonthDate = numberOfWeeksInView == 6 ||
              calendarView == CalendarView.timelineMonth
              ? getNextMonthDate(date)
              : addDays(date, numberOfWeeksInView * DateTime.daysPerWeek);
        }
        break;
      case CalendarView.week:
      case CalendarView.workWeek:
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
        nextMonthDate = addDays(date, DateTime.daysPerWeek);
        break;
      case CalendarView.day:
      case CalendarView.timelineDay:
      case CalendarView.schedule:
        nextMonthDate = addDays(date, 1);
    }

    if (nextMonthDate is DateTime) {
      nextMonthStartDate = nextMonthDate;
    }

    return nextMonthStartDate;
  }

  /// Calculate the previous view visible start date based on calendar view.
  static DateTime getPreviousViewStartDate(
      CalendarView calendarView, int numberOfWeeksInView, DateTime date) {
    late final DateTime previousMonthStartDate;
    dynamic previousMonthDate;
    switch (calendarView) {
      case CalendarView.month:
      case CalendarView.timelineMonth:
        {
          previousMonthDate = numberOfWeeksInView == 6 ||
              calendarView == CalendarView.timelineMonth
              ? getPreviousMonthDate(date)
              : addDays(date, -numberOfWeeksInView * DateTime.daysPerWeek);
        }
        break;
      case CalendarView.timelineWeek:
      case CalendarView.timelineWorkWeek:
      case CalendarView.week:
      case CalendarView.workWeek:
        previousMonthDate = addDays(date, -DateTime.daysPerWeek);
        break;
      case CalendarView.day:
      case CalendarView.timelineDay:
      case CalendarView.schedule:
        previousMonthDate = addDays(date, -1);
    }

    if (previousMonthDate is DateTime) {
      previousMonthStartDate = previousMonthDate;
    }

    return previousMonthStartDate;
  }

  static DateTime _getPreviousValidDate(
      DateTime prevViewDate, List<int> nonWorkingDays) {
    dynamic addedDate = addDays(prevViewDate, -1);
    late DateTime previousDate;
    if (addedDate is DateTime) {
      previousDate = addedDate;
    }
    while (nonWorkingDays.contains(previousDate.weekday)) {
      addedDate = addDays(previousDate, -1);
      if (addedDate is DateTime) {
        previousDate = addedDate;
      }
    }
    return previousDate;
  }

  static DateTime _getNextValidDate(
      DateTime nextDate, List<int> nonWorkingDays) {
    dynamic addedDate = addDays(nextDate, 1);
    late DateTime nextViewDate;
    if (addedDate is DateTime) {
      nextViewDate = addedDate;
    }
    while (nonWorkingDays.contains(nextViewDate.weekday)) {
      addedDate = addDays(nextViewDate, 1);
      if (addedDate is DateTime) {
        nextViewDate = addedDate;
      }
    }
    return nextViewDate;
  }

  /// Return index value of the date in dates collection.
  /// if the date in between the dates collection but dates collection does not
  /// have a date value then it return next date index.
  /// Eg., If the dates collection have Jan 4, Jan 5, Jan 7, Jan 8 and Jan 9,
  /// and the date value as Jan 6 then it return index as 2(Jan 7).
  static int getIndex(List<DateTime> dates, DateTime date) {
    if (date.isBefore(dates[0])) {
      return 0;
    }

    final int datesCount = dates.length;
    if (date.isAfter(dates[datesCount - 1])) {
      return datesCount - 1;
    }

    for (int i = 0; i < datesCount; i++) {
      final DateTime visibleDate = dates[i];
      if (isSameOrBeforeDate(visibleDate, date)) {
        return i;
      }
    }

    return -1;
  }

  /// Get the exact visible date index for date, if the date collection
  /// does not contains the date value then it return -1 value.
  static int getVisibleDateIndex(List<DateTime> dates, DateTime date) {
    final int count = dates.length;
    if (!isDateWithInDateRange(dates[0], dates[count - 1], date)) {
      return -1;
    }

    for (int i = 0; i < count; i++) {
      if (isSameDate(dates[i], date)) {
        return i;
      }
    }

    return -1;
  }

  /// Check the current calendar view is valid for move to previous view or not.
  static bool canMoveToPreviousView(
      CalendarView calendarView,
      int numberOfWeeksInView,
      DateTime minDate,
      DateTime maxDate,
      List<DateTime> visibleDates,
      List<int> nonWorkingDays,
      [bool isRTL = false]) {
    if (isRTL) {
      return canMoveToNextView(calendarView, numberOfWeeksInView, minDate,
          maxDate, visibleDates, nonWorkingDays);
    }

    dynamic previousViewDate;
    switch (calendarView) {
      case CalendarView.month:
      case CalendarView.timelineMonth:
        {
          if (numberOfWeeksInView != 6 ||
              calendarView == CalendarView.timelineMonth) {
            previousViewDate = addDays(visibleDates[0], -1);
            late final DateTime prevViewDate;
            if (previousViewDate is DateTime) {
              prevViewDate = previousViewDate;
            }
            if (!isSameOrAfterDate(minDate, prevViewDate)) {
              return false;
            }
          } else {
            final DateTime currentDate = visibleDates[visibleDates.length ~/ 2];
            previousViewDate = getPreviousMonthDate(currentDate);
            late final DateTime previousDate;
            if (previousViewDate is DateTime) {
              previousDate = previousViewDate;
            }
            if ((previousDate.month < minDate.month &&
                previousDate.year == minDate.year) ||
                previousDate.year < minDate.year) {
              return false;
            }
          }
        }
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
        {
          DateTime prevViewDate = visibleDates[0];
          previousViewDate = addDays(prevViewDate, -1);
          if (previousViewDate is DateTime) {
            prevViewDate = previousViewDate;
          }

          if (!isSameOrAfterDate(minDate, prevViewDate)) {
            return false;
          }
        }
        break;
      case CalendarView.timelineWorkWeek:
      case CalendarView.workWeek:
        {
          final DateTime previousDate =
          _getPreviousValidDate(visibleDates[0], nonWorkingDays);
          if (!isSameOrAfterDate(minDate, previousDate)) {
            return false;
          }
        }
        break;
      case CalendarView.schedule:
        return true;
    }

    return true;
  }

  /// Check the current calendar view is valid for move to next view or not.
  static bool canMoveToNextView(
      CalendarView calendarView,
      int numberOfWeeksInView,
      DateTime minDate,
      DateTime maxDate,
      List<DateTime> visibleDates,
      List<int> nonWorkingDays,
      [bool isRTL = false]) {
    if (isRTL) {
      return canMoveToPreviousView(calendarView, numberOfWeeksInView, minDate,
          maxDate, visibleDates, nonWorkingDays);
    }

    dynamic nextViewVisibleDate;
    switch (calendarView) {
      case CalendarView.month:
      case CalendarView.timelineMonth:
        {
          if (numberOfWeeksInView != 6 ||
              calendarView == CalendarView.timelineMonth) {
            nextViewVisibleDate =
                addDays(visibleDates[visibleDates.length - 1], 1);
            late final DateTime nextViewDate;
            if (nextViewVisibleDate is DateTime) {
              nextViewDate = nextViewVisibleDate;
            }
            if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
              return false;
            }
          } else {
            final DateTime currentDate = visibleDates[visibleDates.length ~/ 2];
            nextViewVisibleDate = getNextMonthDate(currentDate);
            late final DateTime nextDate;
            if (nextViewVisibleDate is DateTime) {
              nextDate = nextViewVisibleDate;
            }
            if ((nextDate.month > maxDate.month &&
                nextDate.year == maxDate.year) ||
                nextDate.year > maxDate.year) {
              return false;
            }
          }
        }
        break;
      case CalendarView.day:
      case CalendarView.week:
      case CalendarView.timelineDay:
      case CalendarView.timelineWeek:
        {
          nextViewVisibleDate =
              addDays(visibleDates[visibleDates.length - 1], 1);
          late final DateTime nextViewDate;
          if (nextViewVisibleDate is DateTime) {
            nextViewDate = nextViewVisibleDate;
          }
          if (!isSameOrBeforeDate(maxDate, nextViewDate)) {
            return false;
          }
        }
        break;
      case CalendarView.workWeek:
      case CalendarView.timelineWorkWeek:
        {
          final DateTime nextDate = _getNextValidDate(
              visibleDates[visibleDates.length - 1], nonWorkingDays);
          if (!isSameOrBeforeDate(maxDate, nextDate)) {
            return false;
          }
        }
        break;
      case CalendarView.schedule:
        return true;
    }

    return true;
  }
}
