import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:developer' as developer;

class CurrentState {
  static const int waiting = 0;
  static const int inClass = 1;
  static const int restTime = 2;
}

const String isolateName = 'SchoolBellIsolate';

class ClassManager extends ChangeNotifier {
  bool _counting = false;
  int _currentState = CurrentState.waiting;
  int _totalClass = -1;
  int _currentClass = -1;

  // 나중에 실제 값 가지고 올 것
  int _firstLength = 10;
  int _classLength = 10;
  int _restLength = 5;

  bool get isCounting => _counting;
  int get currentState => _currentState;
  int get totalClass => _totalClass;
  int get currentClass => _currentClass;

  Future<void> initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counting = prefs.getBool('counting') ?? false;
    _currentState = prefs.getInt('currentState') ?? CurrentState.waiting;
    _totalClass = prefs.getInt('totalClass') ?? -1;
    _currentClass = prefs.getInt('currentClass') ?? -1;
  }

  Future<void> startClass(int totalClass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('counting', true);
    await prefs.setInt('currentState', CurrentState.inClass);
    await prefs.setInt('totalClass', totalClass);
    await prefs.setInt('currentClass', 1);

    _counting = true;
    _currentState = CurrentState.inClass;
    _totalClass = totalClass;
    _currentClass = 1;

    int alarmId;
    int timeSum = _firstLength;

    for (alarmId = 0; alarmId < (totalClass - 1) * 2; alarmId++) {
      if (alarmId % 2 == 0) {
        AndroidAlarmManager.oneShot(
          Duration(seconds: timeSum),
          alarmId,
          callbackClass,
          exact: true,
          wakeup: true,
        );
        timeSum += _restLength;
      } else {
        AndroidAlarmManager.oneShot(
          Duration(seconds: timeSum),
          alarmId,
          callbackRest,
          exact: true,
          wakeup: true,
        );
        timeSum += _classLength;
      }
    }
    AndroidAlarmManager.oneShot(
      Duration(seconds: timeSum),
      (totalClass - 1) * 2,
      callbackLast,
      exact: true,
      wakeup: true,
    );

    notifyListeners();
  }

  Future<void> stopClass() async {
    for (int i = 0; i < _totalClass * 2 - 1; i++) {
      AndroidAlarmManager.cancel(i);
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('counting', false);
    await prefs.setInt('currentState', CurrentState.waiting);
    await prefs.setInt('totalClass', -1);
    await prefs.setInt('currentClass', -1);

    _counting = false;
    _currentState = CurrentState.waiting;
    _totalClass = -1;
    _currentClass = -1;

    notifyListeners();
  }

  // 아래 함수들은 class_screen의 화면을 바꾸기 위한 용도로만 구현되었음
  void restTimeImage() {
    _currentState = CurrentState.restTime;
    notifyListeners();
  }

  void classTimeImage() {
    _currentClass++;
    _currentState = CurrentState.inClass;
    notifyListeners();
  }

  void waitingTimeImage() {
    _counting = false;
    _currentState = CurrentState.waiting;
    _totalClass = -1;
    _currentClass = -1;
    notifyListeners();
  }

  static SendPort? uiSendPort;

  static Future<void> callbackClass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final currentClass = prefs.getInt('currentClass');

    await prefs.setInt('currentState', CurrentState.restTime);
    await prefs.setInt('currentClass', currentClass! + 1);

    // 추후 실제로 벨소리를 재생하는 코드로 대체할 예정
    final DateTime now = DateTime.now();
    developer.log('[$now] Rest bell ringing~');

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  static Future<void> callbackRest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentState', CurrentState.inClass);

    final DateTime now = DateTime.now();
    developer.log('[$now] Class bell ringing~');

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }

  static Future<void> callbackLast() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('counting', false);
    await prefs.setInt('currentState', CurrentState.waiting);
    await prefs.setInt('totalClass', -1);
    await prefs.setInt('currentClass', -1);

    final DateTime now = DateTime.now();
    developer.log('[$now] Last Rest bell ringing~');

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }
}
