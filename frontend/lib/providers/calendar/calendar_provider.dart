import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

// 일정 모델 (별도의 파일로 분리 가능)
class ScheduleModel {
  final String id;
  final String title;
  final String time;
  final String date;
  final DateTime? scheduledDateTime;

  ScheduleModel({
    String? id,
    required this.title,
    required this.time,
    required this.date,
    this.scheduledDateTime,
  }) : id = id ?? const Uuid().v4();

  // JSON 직렬화/역직렬화 메서드
  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['id'],
    title: json['title'] ?? '',
    time: json['time'] ?? '',
    date: json['date'] ?? '',
    scheduledDateTime:
        json['scheduledDateTime'] is DateTime
            ? json['scheduledDateTime']
            : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'time': time,
    'date': date,
    'scheduledDateTime': scheduledDateTime,
  };
}

class CalendarProvider with ChangeNotifier {
  // 캘린더 상태
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Getters
  CalendarFormat get calendarFormat => _calendarFormat;
  DateTime get focusedDay => _focusedDay;
  DateTime? get selectedDay => _selectedDay;

  // 일정 목록
  final List<ScheduleModel> _schedules = [
    ScheduleModel(title: 'Title', time: '8:00 AM', date: 'June 2024'),
    ScheduleModel(title: 'Title', time: '8:00 AM', date: 'June 2024'),
    ScheduleModel(title: 'Title', time: '9:41 AM', date: 'June 2024'),
  ];

  List<ScheduleModel> get schedules => _schedules;

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
  void addSchedule(ScheduleModel schedule) {
    _schedules.add(schedule);
    notifyListeners();
  }

  // 일정 삭제 메서드
  void removeSchedule(String id) {
    _schedules.removeWhere((schedule) => schedule.id == id);
    notifyListeners();
  }

  // 일정 수정 메서드
  void updateSchedule(String id, ScheduleModel updatedSchedule) {
    final index = _schedules.indexWhere((schedule) => schedule.id == id);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
      notifyListeners();
    }
  }
}
