import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:memodot/services/memo_service.dart';
import 'package:memodot/models/memo_model.dart';
import 'memo_add_button.dart';
import 'memo_item.dart';

class MemoGrid extends StatelessWidget {
  const MemoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final memoService = Provider.of<MemoService>(context);

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1,
        ),
        itemCount: memoService.memos.length + 1,
        itemBuilder: (context, index) {
          if (index == memoService.memos.length) {
            return const MemoAddButton();
          }

          final memo = memoService.memos[index];
          final colors = [
            Colors.yellow,
            Colors.blue,
            Colors.pink,
            Colors.grey,
          ];
          final color = colors[index % colors.length];

          return MemoItem(
            memo: memo,
            color: color,
          );
        },
      ),
    );
  }
} 