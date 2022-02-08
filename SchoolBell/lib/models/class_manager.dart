import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class CurrentState {
  static const int waiting = 0;
  static const int inClass = 1;
  static const int restTime = 2;
}

const String isolateName = 'SchoolBellIsolate';

class ClassManager extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _counting = false;
  int _currentState = CurrentState.waiting;
  int _totalClass = -1;
  int _currentClass = -1;

  int _firstLengthSeconds = 0;
  int _classLengthSeconds = 0;
  int _restLengthSeconds = 0;

  bool get isCounting => _counting;
  int get currentState => _currentState;
  int get totalClass => _totalClass;
  int get currentClass => _currentClass;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.reload();

    _counting = _prefs.getBool('counting') ?? false;
    _currentState = _prefs.getInt('currentState') ?? CurrentState.waiting;
    _totalClass = _prefs.getInt('totalClass') ?? -1;
    _currentClass = _prefs.getInt('currentClass') ?? -1;
  }

  Future<void> calculateTimeLength() async {
    await _prefs.reload();

    int _bellMode = _prefs.getInt('bellMode') ?? BellMode.onTime;

    if (_bellMode != BellMode.onTime) {
      _classLengthSeconds = (_prefs.getInt('classLength') ?? 50) * 60;
      _restLengthSeconds = (_prefs.getInt('restLength') ?? 10) * 60;
      _firstLengthSeconds = _classLengthSeconds;
    } else {
      _classLengthSeconds = 3000;
      _restLengthSeconds = 600;

      DateTime current = DateTime.now();
      if (current.minute < 50) {
        _firstLengthSeconds = (50 - current.minute) * 60 - current.second;
      } else {
        _firstLengthSeconds = (110 - current.minute) * 60 - current.second;
      }
    }
  }

  Future<void> startClass(int totalClass) async {
    await _prefs.setBool('counting', true);
    await _prefs.setInt('currentState', CurrentState.inClass);
    await _prefs.setInt('totalClass', totalClass);
    await _prefs.setInt('currentClass', 1);

    _counting = true;
    _currentState = CurrentState.inClass;
    _totalClass = totalClass;
    _currentClass = 1;

    await calculateTimeLength();

    int alarmId;
    int timeSum = _firstLengthSeconds;

    for (alarmId = 0; alarmId < (totalClass - 1) * 2; alarmId++) {
      if (alarmId % 2 == 0) {
        AndroidAlarmManager.oneShot(
          Duration(seconds: timeSum),
          alarmId,
          callbackClassEnd,
          exact: true,
          wakeup: true,
        );
        timeSum += _restLengthSeconds;
      } else {
        AndroidAlarmManager.oneShot(
          Duration(seconds: timeSum),
          alarmId,
          callbackRestEnd,
          exact: true,
          wakeup: true,
        );
        timeSum += _classLengthSeconds;
      }
    }
    AndroidAlarmManager.oneShot(
      Duration(seconds: timeSum),
      (totalClass - 1) * 2,
      callbackLastClassEnd,
      exact: true,
      wakeup: true,
    );

    await NotificationChannel.flutterLocalNotificationsPlugin.show(
      NotificationChannel.notificationId,
      null,
      '1교시 수업 중~! 오늘도 힘내봐요!',
      NotificationChannel.platformChannelSpecifics,
    );

    notifyListeners();
  }

  Future<void> stopClass() async {
    for (int i = 0; i < _totalClass * 2 - 1; i++) {
      AndroidAlarmManager.cancel(i);
    }

    await _prefs.setBool('counting', false);
    await _prefs.setInt('currentState', CurrentState.waiting);
    await _prefs.setInt('totalClass', -1);
    await _prefs.setInt('currentClass', -1);

    _counting = false;
    _currentState = CurrentState.waiting;
    _totalClass = -1;
    _currentClass = -1;

    await NotificationChannel.flutterLocalNotificationsPlugin.cancelAll();

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

  static Future<void> callbackClassEnd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final currentClass = prefs.getInt('currentClass')!;
    final totalClass = prefs.getInt('totalClass');

    await prefs.setInt('currentState', CurrentState.restTime);
    await prefs.setInt('currentClass', currentClass + 1);

    BellSoundPlayer.playRestBell();

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);

    await NotificationChannel.flutterLocalNotificationsPlugin.show(
      NotificationChannel.notificationId,
      null,
      '$currentClass교시 쉬는 시간! 이제 ${totalClass! - currentClass}교시 남았어요.',
      NotificationChannel.platformChannelSpecifics,
    );
  }

  static Future<void> callbackRestEnd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final currentClass = prefs.getInt('currentClass');
    final totalClass = prefs.getInt('totalClass');

    await prefs.setInt('currentState', CurrentState.inClass);

    BellSoundPlayer.playClassBell();

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);

    String noticeMessage = totalClass == currentClass
        ? '$currentClass교시 수업 중~ 오늘의 마지막 수업이에요. 화이팅!'
        : '지금은 $currentClass교시 수업 중!';

    await NotificationChannel.flutterLocalNotificationsPlugin.show(
      NotificationChannel.notificationId,
      null,
      noticeMessage,
      NotificationChannel.platformChannelSpecifics,
    );
  }

  static Future<void> callbackLastClassEnd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('counting', false);
    await prefs.setInt('currentState', CurrentState.waiting);
    await prefs.setInt('totalClass', -1);
    await prefs.setInt('currentClass', -1);

    BellSoundPlayer.playRestBell();

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);

    await NotificationChannel.flutterLocalNotificationsPlugin.cancelAll();
  }
}
