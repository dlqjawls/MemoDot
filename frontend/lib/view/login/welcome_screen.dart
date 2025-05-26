import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:memodot/core/theme.dart';
import 'package:memodot/services/auth_service.dart';
import 'package:memodot/widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _leftSlideAnimation;
  late Animation<Offset> _rightSlideAnimation;

  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    // 왼쪽으로 슬라이드 애니메이션 ("메")
    _leftSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(-2.0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // 오른쪽으로 슬라이드 애니메이션 ("모")
    _rightSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(2.0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTextVisibility() {
    setState(() {
      _showText = !_showText;
      if (_showText) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  // 오프라인 모드로 전환
  Future<void> _goToOfflineMode() async {
    // 오프라인 모드 플래그 저장
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offline_mode', true);

    if (mounted) {
      // 오프라인 모드로 전환되었다는 알림
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('오프라인 모드로 전환되었습니다')));

      // 홈 화면으로 이동 (오프라인 상태로)
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 100.h),

              // 로고 영역
              Center(
                child: SizedBox(
                  width: 200.w, // 로고 영역 너비 확보
                  height: 120.h, // 로고 영역 높이 확보
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // "메" 텍스트 (왼쪽으로 이동)
                      if (_showText)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: SlideTransition(
                                position: _leftSlideAnimation,
                                child: Text(
                                  "메",
                                  style: TextStyle(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // 검은 점 (중앙 고정)
                      GestureDetector(
                        onTap: _toggleTextVisibility,
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: AnimatedOpacity(
                              opacity: _showText ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                "점",
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // "모" 텍스트 (오른쪽으로 이동)
                      if (_showText)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _fadeAnimation.value,
                              child: SlideTransition(
                                position: _rightSlideAnimation,
                                child: Text(
                                  "모",
                                  style: TextStyle(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // 중간 공간
              Expanded(child: Container()),

              // 버튼 영역
              Column(
                children: [
                  // 새 계정 만들기 버튼
                  CustomButton(
                    text: '새롭게 시작하기',
                    onPressed: () {
                      context.go('/signup');
                    },
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    height: 55.h,
                  ),

                  SizedBox(height: 16.h),

                  // 기존 계정으로 로그인 텍스트 버튼
                  TextButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    child: Text(
                      '기존 계정으로 로그인',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.sp,
                      ),
                    ),
                  ),

                  // 오프라인 모드 텍스트 버튼
                  SizedBox(height: 24.h),
                  TextButton(
                    onPressed: _goToOfflineMode,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '오프라인',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward,
                          size: 16.sp,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
