import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarViewModel extends ChangeNotifier {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Getters
  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  // 일정 목록
  List<Map<String, dynamic>> _schedules = [
    {'title': 'Title', 'time': '8:00 AM', 'date': 'June 2024'},
    {'title': 'Title', 'time': '8:00 AM', 'date': 'June 2024'},
    {'title': 'Title', 'time': '9:41 AM', 'date': 'June 2024'},
  ];

  List<Map<String, dynamic>> get schedules => _schedules;

  // 날짜 선택 메서드
  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      notifyListeners();
    }
  }

  // 캘린더 포맷 변경 메서드
  void changeCalendarFormat(CalendarFormat format) {
    if (_calendarFormat != format) {
      _calendarFormat = format;
      notifyListeners();
    }
  }

  // 페이지 변경 메서드
  void changePageDay(DateTime focusedDay) {
    _focusedDay = focusedDay;
    notifyListeners();
  }

  // 일정 추가 메서드
  void addSchedule(String title, String time, String date) {
    _schedules.add({'title': title, 'time': time, 'date': date});
    notifyListeners();
  }

  // 일정 삭제 메서드
  void removeSchedule(int index) {
    _schedules.removeAt(index);
    notifyListeners();
  }
}
