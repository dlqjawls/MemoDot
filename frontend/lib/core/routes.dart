import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:memodot/view/home/home_screen.dart';
import 'package:memodot/view/login/login_screen.dart';
import 'package:memodot/view/login/signup_screen.dart';
import 'package:memodot/view/login/welcome_screen.dart';
import 'package:memodot/view/settings/settings_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const WelcomeScreen(),
        redirect: (context, state) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            return '/home';
          }
          return null;
        },
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder:
        (context, state) => Scaffold(
          body: Center(child: Text('페이지를 찾을 수 없습니다: ${state.uri.path}')),
        ),
  );
}
