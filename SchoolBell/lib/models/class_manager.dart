import 'package:flutter/material.dart';

class CurrentState {
  static const int waiting = 0;
  static const int inClass = 1;
  static const int restTime = 2;
}

class ClassManager extends ChangeNotifier {
  bool _counting = false;
  int _currentState = CurrentState.waiting;
  int _totalClass = -1;
  int _currentClass = -1;

  bool get isCounting => _counting;
  int get currentState => _currentState;
  int get totalClass => _totalClass;
  int get currentClass => _currentClass;

  void startClass(int totalClass) {
    _counting = true;
    _currentState = CurrentState.inClass;
    _totalClass = totalClass;
    _currentClass = 1;

    // 수업시간 알람 카운트 시작

    notifyListeners();
  }

  void startRest() {
    _currentState = CurrentState.restTime;

    // 쉬는 시간 카운트 시작

    notifyListeners();
  }

  void nextClass() {
    _currentClass++;
    _currentState = CurrentState.inClass;

    // 수업시간 카운트 재시작작

   notifyListeners();
  }

  void stopClass() {
    _counting = false;
    _currentState = CurrentState.waiting;
    _totalClass = -1;
    _currentClass = -1;

    // 알람 카운트 모두 종료

    notifyListeners();
  }
}
