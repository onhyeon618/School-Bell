import 'package:flutter/material.dart';
import 'schoolbell_colors.dart';

class SchoolBellTheme {
  static TextTheme mainTextTheme = const TextTheme(
    displayLarge: TextStyle( // 메인화면 텍스트
      fontSize: 32.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    displayMedium: TextStyle( // 다이얼로그 제목
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headlineMedium: TextStyle( // 설정 카테고리
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: SchoolBellColor.colorAccent,
    ),
    headlineSmall: TextStyle( // 설정 이름
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    titleLarge: TextStyle( // 비활성화 된 설정 이름
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: SchoolBellColor.colorGray,
    ),
    titleMedium: TextStyle( // 다이얼로그 일반
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    titleSmall: TextStyle( // 다이얼로그 미니
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
    bodyLarge: TextStyle( // 설정 내용
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
    bodyMedium: TextStyle( // 비활성화 된 설정 내용
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: SchoolBellColor.colorGray,
    ),
    labelLarge: TextStyle( // 버튼 텍스트
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
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
