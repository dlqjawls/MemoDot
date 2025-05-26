import 'package:flutter/material.dart';
import '../../services/memo_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MemoService _memoService;

  HomeViewModel(this._memoService);

  bool get isLoading => _memoService.isLoading;
  String? get error => _memoService.error;

  Future<void> fetchMemos() {
    return _memoService.fetchMemos();
  }

  Future<bool> createMemo(String content, List<String> tags, bool isPublic) {
    return _memoService.createMemo(content, tags, isPublic);
  }

  Future<bool> updateMemo(
    String id,
    String content,
    List<String> tags,
    bool isPublic,
  ) {
    return _memoService.updateMemo(id, content, tags, isPublic);
  }

  Future<bool> deleteMemo(String id) {
    return _memoService.deleteMemo(id);
  }
}
