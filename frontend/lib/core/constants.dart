class AppConstants {
  // API 관련 상수
  static const String baseUrl = 'https://api.memodot.com';

  // 로컬 저장소 키
  static const String tokenKey = 'auth_token';
  static const String userIdKey = 'user_id';

  // 애니메이션 지속 시간
  static const int animationDuration = 300; // 밀리초

  // 기타 상수
  static const int maxMemoLength = 500;
}

class ApiEndpoints {
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String memos = '/memos';
  static const String profile = '/user/profile';
}
