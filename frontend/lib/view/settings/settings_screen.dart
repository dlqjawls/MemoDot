import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 섹션
            if (authService.currentUser != null) ...[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '사용자 정보',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: AppTheme.primaryColor,
                            child: Text(
                              authService.currentUser!.username
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authService.currentUser!.username,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                authService.currentUser!.email,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppTheme.subtleTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],

            // 앱 설정 섹션
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '앱 설정',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildSettingItem(
                      icon: Icons.notifications_outlined,
                      title: '알림 설정',
                      onTap: () {
                        // 알림 설정 화면으로 이동
                      },
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.language_outlined,
                      title: '언어 설정',
                      onTap: () {
                        // 언어 설정 화면으로 이동
                      },
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.dark_mode_outlined,
                      title: '테마 설정',
                      onTap: () {
                        // 테마 설정 화면으로 이동
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // 계정 관련 섹션
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '계정',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildSettingItem(
                      icon: Icons.lock_outline,
                      title: '비밀번호 변경',
                      onTap: () {
                        // 비밀번호 변경 화면으로 이동
                      },
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.help_outline,
                      title: '도움말',
                      onTap: () {
                        // 도움말 화면으로 이동
                      },
                    ),
                    _buildDivider(),
                    _buildSettingItem(
                      icon: Icons.info_outline,
                      title: '앱 정보',
                      onTap: () {
                        // 앱 정보 화면으로 이동
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // 로그아웃 버튼
            CustomButton(
              text: '로그아웃',
              onPressed: () async {
                await authService.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 24.r),
            SizedBox(width: 16.w),
            Text(title, style: TextStyle(fontSize: 16.sp)),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1.h, thickness: 1, color: Colors.grey[200]);
  }
}
