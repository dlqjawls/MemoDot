import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../models/memo_model.dart';
import '../../services/auth_service.dart';
import '../../services/memo_service.dart';
import '../../widgets/custom_button.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _memoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 메모 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final memoService = Provider.of<MemoService>(context, listen: false);
      memoService.fetchMemos();
    });
  }

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
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

    final memoService = Provider.of<MemoService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MemoDot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 메모 입력 영역
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _memoController,
                    decoration: const InputDecoration(
                      hintText: '메모를 입력하세요',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                ),
                SizedBox(width: 8.w),
                CustomButton(
                  text: '저장',
                  onPressed: () {
                    if (_memoController.text.isNotEmpty) {
                      memoService.createMemo(
                        _memoController.text,
                        [], // 태그
                        false, // 비공개
                      );
                      _memoController.clear();
                    }
                  },
                  width: 80.w,
                ),
              ],
            ),
          ),

          // 메모 목록
          Expanded(
            child:
                memoService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : memoService.memos.isEmpty
                    ? Center(
                      child: Text(
                        '메모가 없습니다.\n새로운 메모를 추가해보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.subtleTextColor,
                          fontSize: 16.sp,
                        ),
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.all(16.r),
                      itemCount: memoService.memos.length,
                      itemBuilder: (context, index) {
                        final memo = memoService.memos[index];
                        return _buildMemoItem(memo, memoService);
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemoItem(MemoModel memo, MemoService memoService) {
    return Card(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(memo.content, style: TextStyle(fontSize: 16.sp)),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${memo.createdAt.year}/${memo.createdAt.month}/${memo.createdAt.day}',
                  style: TextStyle(
                    color: AppTheme.subtleTextColor,
                    fontSize: 12.sp,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        // 메모 수정 기능
                        _showEditDialog(context, memo, memoService);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        // 메모 삭제 기능
                        _showDeleteDialog(context, memo, memoService);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(
    BuildContext context,
    MemoModel memo,
    MemoService memoService,
  ) async {
    final TextEditingController controller = TextEditingController(
      text: memo.content,
    );

    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('메모 수정'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: '메모 내용을 수정하세요'),
              maxLines: 5,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    memoService.updateMemo(
                      memo.id,
                      controller.text,
                      memo.tags,
                      memo.isPublic,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('저장'),
              ),
            ],
          ),
    );
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    MemoModel memo,
    MemoService memoService,
  ) async {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('메모 삭제'),
            content: const Text('이 메모를 삭제하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () {
                  memoService.deleteMemo(memo.id);
                  Navigator.pop(context);
                },
                child: const Text('삭제'),
              ),
            ],
          ),
    );
  }
}
