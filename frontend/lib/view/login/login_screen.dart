import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../utils/validator.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoginMode = true;
  final _usernameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (_isLoginMode) {
        final success = await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (success && mounted) {
          context.go('/home');
        }
      } else {
        final success = await authService.register(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (success && mounted) {
          setState(() {
            _isLoginMode = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인해주세요.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Text(
                    _isLoginMode ? '로그인' : '회원가입',
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _isLoginMode ? 'MemoDot에 오신 것을 환영합니다' : '새로운 계정을 만들어보세요',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.subtleTextColor,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // 회원가입 모드일 때만 사용자 이름 필드 표시
                  if (!_isLoginMode) ...[
                    CustomTextField(
                      controller: _usernameController,
                      hintText: '사용자 이름',
                      labelText: '사용자 이름',
                      prefixIcon: const Icon(Icons.person),
                      validator: Validator.validateUsername,
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // 이메일 필드
                  CustomTextField(
                    controller: _emailController,
                    hintText: '이메일',
                    labelText: '이메일',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: Validator.validateEmail,
                  ),
                  SizedBox(height: 16.h),

                  // 비밀번호 필드
                  CustomTextField(
                    controller: _passwordController,
                    hintText: '비밀번호',
                    labelText: '비밀번호',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                    validator: Validator.validatePassword,
                  ),
                  SizedBox(height: 16.h),

                  // 회원가입 모드일 때만 비밀번호 확인 필드 표시
                  if (!_isLoginMode) ...[
                    CustomTextField(
                      controller: _confirmPasswordController,
                      hintText: '비밀번호 확인',
                      labelText: '비밀번호 확인',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator:
                          (value) => Validator.validateConfirmPassword(
                            value,
                            _passwordController.text,
                          ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  SizedBox(height: 24.h),

                  // 로그인/회원가입 버튼
                  CustomButton(
                    text: _isLoginMode ? '로그인' : '회원가입',
                    onPressed: _submitForm,
                    isLoading: authService.isLoading,
                  ),
                  SizedBox(height: 16.h),

                  // 모드 전환 버튼
                  Center(
                    child: TextButton(
                      onPressed: _toggleMode,
                      child: Text(
                        _isLoginMode ? '계정이 없으신가요? 회원가입' : '이미 계정이 있으신가요? 로그인',
                        style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),

                  // 에러 메시지 표시
                  if (authService.error != null) ...[
                    SizedBox(height: 16.h),
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        authService.error!,
                        style: TextStyle(
                          color: AppTheme.errorColor,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],

                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
