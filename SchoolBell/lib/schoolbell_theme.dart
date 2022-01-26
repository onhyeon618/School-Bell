import 'package:flutter/material.dart';
import 'schoolbell_colors.dart';

class SchoolBellTheme {
  static TextTheme mainTextTheme = const TextTheme(
    headline1: TextStyle( // 메인화면 텍스트
      fontSize: 32.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headline2: TextStyle( // 다이얼로그 제목
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headline4: TextStyle( // 설정 카테고리
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: SchoolBellColor.colorAccent,
    ),
    headline5: TextStyle( // 설정 이름
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    headline6: TextStyle( // 비활성화 된 설정 이름
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: SchoolBellColor.colorGray,
    ),
    subtitle1: TextStyle( // 다이얼로그 일반
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    subtitle2: TextStyle( // 다이얼로그 미니
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
    bodyText1: TextStyle( // 설정 내용
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
    bodyText2: TextStyle( // 비활성화 된 설정 내용
      fontSize: 14.0,
      fontWeight: FontWeight.w300,
      color: SchoolBellColor.colorGray,
    ),
    button: TextStyle( // 버튼 텍스트
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
      fontFamily: 'LevelTwo',
      iconTheme: const IconThemeData(color: SchoolBellColor.colorMain),
    );
  }
}
