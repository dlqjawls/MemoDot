import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:memodot/providers/calendar/calendar_provider.dart';

class ScheduleList extends StatelessWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);

    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: calendarProvider.schedules.length,
      itemBuilder: (context, index) {
        final schedule = calendarProvider.schedules[index];
        return _buildScheduleItem(
          schedule,
          () => calendarProvider.removeSchedule(schedule.id),
        );
      },
    );
  }

  Widget _buildScheduleItem(ScheduleModel schedule, VoidCallback onDelete) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.h),
              Text(
                schedule.time,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                schedule.date,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade600),
              ),
              IconButton(
                icon: Icon(Icons.delete, size: 20.r),
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
