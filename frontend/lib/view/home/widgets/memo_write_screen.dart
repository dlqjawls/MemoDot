import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:memodot/services/memo_service.dart';

class MemoWriteScreen extends StatefulWidget {
  const MemoWriteScreen({super.key});

  @override
  State<MemoWriteScreen> createState() => _MemoWriteScreenState();
}

class _MemoWriteScreenState extends State<MemoWriteScreen> {
  final TextEditingController _memoController = TextEditingController();

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _saveMemo(BuildContext context) {
    if (_memoController.text.isNotEmpty) {
      final memoService = Provider.of<MemoService>(context, listen: false);
      memoService.createMemo(
        _memoController.text,
        [], // 태그
        false, // 비공개
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '메모 작성',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () => _saveMemo(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: TextField(
                  controller: _memoController,
                  autofocus: true,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: '늘어서 적어보세요',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 24.sp,
                    ),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
