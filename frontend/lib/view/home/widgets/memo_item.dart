import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:memodot/models/memo_model.dart';
import 'package:memodot/services/memo_service.dart';

class MemoItem extends StatelessWidget {
  final MemoModel memo;
  final Color color;

  const MemoItem({super.key, required this.memo, required this.color});

  @override
  Widget build(BuildContext context) {
    final memoService = Provider.of<MemoService>(context);

    return GestureDetector(
      onTap: () {
        _showEditDialog(context, memo, memoService);
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Text(
            memo.content,
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
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
}
