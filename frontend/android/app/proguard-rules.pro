# Flutter 앱을 위한 기본 ProGuard 규칙
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class com.MemoDot.memodot.** { *; }

# 앱의 특정 클래스 유지
-keep public class * extends io.flutter.embedding.engine.FlutterEngine
-keep public class * extends io.flutter.plugins.GeneratedPluginRegistrant

# Play Core 라이브러리 규칙
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; } 