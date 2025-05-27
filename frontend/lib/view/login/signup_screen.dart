import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:memodot/core/theme.dart';
import 'package:memodot/services/auth_service.dart';
import 'package:memodot/utils/validator.dart';
import 'package:memodot/widgets/custom_button.dart';
import 'package:memodot/widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      final success = await authService.register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 완료되었습니다. 로그인해주세요.')),
        );
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
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
                    '새로운 계정을 만들어보세요',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppTheme.subtleTextColor,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // 사용자 이름
                  CustomTextField(
                    controller: _usernameController,
                    hintText: '사용자 이름',
                    labelText: '사용자 이름',
                    prefixIcon: const Icon(Icons.person),
                    validator: Validator.validateUsername,
                  ),
                  SizedBox(height: 16.h),

                  // 이메일
                  CustomTextField(
                    controller: _emailController,
                    hintText: '이메일',
                    labelText: '이메일',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email),
                    validator: Validator.validateEmail,
                  ),
                  SizedBox(height: 16.h),

                  // 비밀번호
                  CustomTextField(
                    controller: _passwordController,
                    hintText: '비밀번호',
                    labelText: '비밀번호',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock),
                    validator: Validator.validatePassword,
                  ),
                  SizedBox(height: 16.h),

                  // 비밀번호 확인
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
                  SizedBox(height: 40.h),

                  // 회원가입 버튼
                  CustomButton(
                    text: '회원가입',
                    onPressed: _submitForm,
                    isLoading: authService.isLoading,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
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
