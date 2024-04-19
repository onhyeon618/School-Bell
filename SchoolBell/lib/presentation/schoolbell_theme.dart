import 'package:flutter/material.dart';
import 'schoolbell_colors.dart';

class SchoolBellTheme {
  static TextTheme mainTextTheme = const TextTheme(
    /// 메인화면 텍스트
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      letterSpacing: -0.5,
    ),

    /// 설정 카테고리
    labelSmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: SchoolBellColor.colorAccent,
      letterSpacing: -0.5,
    ),

    /// 설정 이름
    titleLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      letterSpacing: -0.5,
    ),

    /// 설정 내용
    bodyLarge: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
      letterSpacing: -0.5,
    ),

    /// 제목 일반 (다이얼로그 포함)
    titleMedium: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      letterSpacing: -0.5,
    ),

    /// 본문 일반 (다이얼로그 포함)
    bodyMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
      letterSpacing: -0.5,
    ),

    /// 본문 작은 텍스트
    bodySmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
      letterSpacing: -0.5,
    ),

    /// 버튼
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
      letterSpacing: -0.5,
    ),
  );

  static ThemeData mainTheme() {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.transparent,
      highlightColor: Colors.white12,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: SchoolBellColor.colorMain,
        splashColor: Colors.white24,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        shape: CircularNotchedRectangle(),
        color: Colors.white,
      ),
      textTheme: mainTextTheme,
      fontFamily: 'Pretendard',
      iconTheme: const IconThemeData(color: SchoolBellColor.colorMain),
    );
  }
}
