import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/memo_model.dart';

class MemoService extends ChangeNotifier {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );

  List<MemoModel> _memos = [];
  bool _isLoading = false;
  String? _error;

  List<MemoModel> get memos => _memos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MemoService() {
    _initDio();
  }

  // Dio 초기화 (인증 토큰 설정)
  Future<void> _initDio() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // 모든 메모 가져오기
  Future<void> fetchMemos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.get(ApiEndpoints.memos);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _memos = data.map((memo) => MemoModel.fromJson(memo)).toList();
        _isLoading = false;
        notifyListeners();
      } else {
        _error = '메모를 불러오는데 실패했습니다.';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = '오류가 발생했습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  // 메모 생성
  Future<bool> createMemo(
    String content,
    List<String> tags,
    bool isPublic,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.post(
        ApiEndpoints.memos,
        data: {'content': content, 'tags': tags, 'is_public': isPublic},
      );

      if (response.statusCode == 201) {
        final newMemo = MemoModel.fromJson(response.data);
        _memos.add(newMemo);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = '메모 생성에 실패했습니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '오류가 발생했습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 메모 수정
  Future<bool> updateMemo(
    String id,
    String content,
    List<String> tags,
    bool isPublic,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.put(
        '${ApiEndpoints.memos}/$id',
        data: {'content': content, 'tags': tags, 'is_public': isPublic},
      );

      if (response.statusCode == 200) {
        final updatedMemo = MemoModel.fromJson(response.data);
        final index = _memos.indexWhere((memo) => memo.id == id);
        if (index != -1) {
          _memos[index] = updatedMemo;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = '메모 수정에 실패했습니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '오류가 발생했습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 메모 삭제
  Future<bool> deleteMemo(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.delete('${ApiEndpoints.memos}/$id');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _memos.removeWhere((memo) => memo.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = '메모 삭제에 실패했습니다.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = '오류가 발생했습니다: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
