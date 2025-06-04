import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:memodot/services/memo_service.dart';

class MemoAddButton extends StatelessWidget {
  const MemoAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    final memoService = Provider.of<MemoService>(context);
    final TextEditingController memoController = TextEditingController();

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('새 메모'),
                content: TextField(
                  controller: memoController,
                  decoration: const InputDecoration(hintText: '메모를 입력하세요'),
                  maxLines: 3,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (memoController.text.isNotEmpty) {
                        memoService.createMemo(
                          memoController.text,
                          [], // 태그
                          false, // 비공개
                        );
                        memoController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('저장'),
                  ),
                ],
              ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(Icons.add, size: 50.r, color: Colors.white),
      ),
    );
  }
}
