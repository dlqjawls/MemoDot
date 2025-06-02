import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:memodot/services/auth_service.dart';
import 'package:memodot/services/memo_service.dart';
import 'package:memodot/widgets/bottom_navigation_bar.dart';
import 'widgets/memo_grid.dart';
import 'widgets/memo_write_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // 메모 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final memoService = Provider.of<MemoService>(context, listen: false);
      memoService.fetchMemos();
    });
  }

  void _navigateToMemoWrite() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const MemoWriteScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // MemoService 제공자가 없으면 추가
    if (Provider.of<MemoService?>(context, listen: false) == null) {
      return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => MemoService())],
        child: const HomeScreen(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '메·모',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _navigateToMemoWrite,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 48.r,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.r),
                      child: Text(
                        '메모기록',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(flex: 2, child: MemoGrid()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _selectedIndex,
      ),
    );
  }
}
