import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommonBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CommonBottomNavigationBar({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/calendar');
            break;
          default:
            onTap?.call(index);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.note), label: '메모'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: '캘린더'),
      ],
    );
  }
}
