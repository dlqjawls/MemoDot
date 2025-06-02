import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:memodot/providers/calendar/calendar_provider.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: calendarProvider.focusedDay,
      calendarFormat: calendarProvider.calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(calendarProvider.selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        calendarProvider.selectDay(selectedDay, focusedDay);
      },
      onFormatChanged: (format) {
        calendarProvider.changeCalendarFormat(format);
      },
      onPageChanged: (focusedDay) {
        calendarProvider.changePageDay(focusedDay);
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue.shade200,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
