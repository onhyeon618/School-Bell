import 'dart:async';
import 'package:flutter/material.dart';

class SchoolBellTab {
  static const int current = 0;
  static const int settings = 1;
}

class AppStateManager extends ChangeNotifier {
  bool _initialized = false; // 스플래시 노출 여부: 최초 실행 시에만 노출

  bool _counting = false;

  bool get isInitialized => _initialized;
  bool get isCounting => _counting;

  void initializeApp() {
    Timer(
      const Duration(milliseconds: 2000),
      () {
        _initialized = true;
        notifyListeners();
      },
    );
  }

  void startCounting(int totalClass) {
    _counting = true;

    // SharedPreference에 현재 상태, 교시 상태, 총 교시 수 업데이트
    // 알람 카운트 시작해야 하는데 이건 어떻게 하지?

    notifyListeners();
  }

  void stopCounting() {
    _counting = false;
    _initialized = true; // 스플래시 화면이 뜨는 것을 방지하기 위함

    // SharedPrefeerence 업데이트
    // 알람 카운트 모두 종료

    notifyListeners();
  }
}
