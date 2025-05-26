class Validator {
  // 이메일 유효성 검사
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '이메일을 입력해주세요.';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '유효한 이메일 주소를 입력해주세요.';
    }

    return null;
  }

  // 비밀번호 유효성 검사
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }

    if (value.length < 6) {
      return '비밀번호는 최소 6자 이상이어야 합니다.';
    }

    return null;
  }

  // 비밀번호 확인 유효성 검사
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '비밀번호 확인을 입력해주세요.';
    }

    if (value != password) {
      return '비밀번호가 일치하지 않습니다.';
    }

    return null;
  }

  // 사용자 이름 유효성 검사
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '사용자 이름을 입력해주세요.';
    }

    if (value.length < 3) {
      return '사용자 이름은 최소 3자 이상이어야 합니다.';
    }

    return null;
  }

  // 메모 내용 유효성 검사
  static String? validateMemoContent(String? value) {
    if (value == null || value.isEmpty) {
      return '메모 내용을 입력해주세요.';
    }

    return null;
  }
}
