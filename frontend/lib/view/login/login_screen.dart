import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:memodot/core/theme.dart';
import 'package:memodot/services/auth_service.dart';
import 'package:memodot/utils/validator.dart';
import 'package:memodot/widgets/custom_button.dart';
import 'package:memodot/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      final success = await authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
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
                  SizedBox(height: 20.h),
                  Text(
                    'MemoDot에 오신 것을 환영합니다',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.subtleTextColor,
                    ),
                  ),
                  SizedBox(height: 40.h),

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
                  SizedBox(height: 40.h),

                  // 로그인 버튼
                  CustomButton(
                    text: '로그인',
                    onPressed: _submitForm,
                    isLoading: authService.isLoading,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 16.h),

                  // 회원가입으로 이동 버튼
                  Center(
                    child: TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(
                        '계정이 없으신가요? 회원가입',
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
