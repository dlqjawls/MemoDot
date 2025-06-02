import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:memodot/providers/calendar/calendar_provider.dart';
import 'package:memodot/widgets/bottom_navigation_bar.dart';
import 'widgets/calendar_widget.dart';
import 'widgets/schedule_list.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '캘린더',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddScheduleDialog(context);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.go('/settings'),
            ),
          ],
        ),
        body: Column(
          children: const [CalendarWidget(), Expanded(child: ScheduleList())],
        ),
        bottomNavigationBar: const CommonBottomNavigationBar(currentIndex: 1),
      ),
    );
  }

  void _showAddScheduleDialog(BuildContext context) {
    final titleController = TextEditingController();
    final timeController = TextEditingController();
    final dateController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('새 일정 추가'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: '제목'),
                ),
                TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    hintText: '시간 (예: 9:00 AM)',
                  ),
                ),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    hintText: '날짜 (예: June 2024)',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      timeController.text.isNotEmpty &&
                      dateController.text.isNotEmpty) {
                    final calendarProvider = Provider.of<CalendarProvider>(
                      context,
                      listen: false,
                    );
                    calendarProvider.addSchedule(
                      ScheduleModel(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('추가'),
              ),
            ],
          ),
    );
  }
}
