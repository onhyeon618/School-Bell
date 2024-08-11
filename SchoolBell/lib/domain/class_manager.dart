import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:school_bell/channel/notification.dart';
import 'package:school_bell/domain/bell_sound_player.dart';
import 'package:school_bell/enum/bell_mode.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String isolateName = 'SchoolBellIsolate';

class ClassManager extends ChangeNotifier {
  late final SharedPreferences _prefs;

  /// 현재 상태
  ClassState _currentState = ClassState.idle;

  /// 전체 수업 시수
  int _totalPeriod = 0;

  /// 현재 교시
  int _currentPeriod = 0;

  ClassState get currentState => _currentState;

  int get currentPeriod => _currentPeriod;

  int get remainingPeriod {
    switch (_currentState) {
      case ClassState.idle:
        return 0;
      case ClassState.inClass:
        return _totalPeriod - _currentPeriod + 1;
      case ClassState.restTime:
        return _totalPeriod - _currentPeriod;
    }
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    fetch();
  }

  Future<void> fetch() async {
    await _prefs.reload();

    _currentState = ClassState.fromInt(_prefs.getInt('currentState') ?? 0);
    _totalPeriod = _prefs.getInt('totalClass') ?? -1;
    _currentPeriod = _prefs.getInt('currentClass') ?? -1;
  }

  Future<void> setClassState({
    required ClassState state,
    required int period,
    int? total,
  }) async {
    await _prefs.setInt('currentState', state.index);
    await _prefs.setInt('currentPeriod', period);
    if (total != null) await _prefs.setInt('totalPeriod', total);

    _currentState = state;
    _currentPeriod = period;
    if (total != null) _totalPeriod = total;

    notifyListeners();
  }

  Future<void> startClass(int totalClass) async {
    await setClassState(state: ClassState.inClass, period: 1, total: totalClass);

    final bellMode = BellMode.fromInt(_prefs.getInt('bellMode') ?? 0);
    final classLength = _prefs.getInt('classLength') ?? 50 * 60;
    final restLength = _prefs.getInt('restLength') ?? 10 * 60;

    final int firstClassLength;
    if (bellMode == BellMode.onTime) {
      final now = DateTime.now();

      // onTime 모드인 경우 classLength, restLength는 각각 종이 울릴 분각을 의미함
      if (now.minute < classLength) {
        firstClassLength = classLength - now.minute * 60 - now.second;
      } else {
        firstClassLength = (60 - now.minute) * 60 + classLength - now.second;
      }
    } else {
      firstClassLength = classLength;
    }

    int timeSum = firstClassLength;

    // TODO: 알람 설정 로직 개편
    for (int alarmId = 0; alarmId < (totalClass - 1) * 2; alarmId++) {
      if (alarmId % 2 == 0) {
        // 수업 종료
        AndroidAlarmManager.oneShot(
          Duration(seconds: timeSum),
          alarmId,
          callbackClassEnd,
          alarmClock: true,
          exact: true,
          wakeup: true,
        );
        timeSum += restLength;
      } else {
        // 쉬는시간 종료
        AndroidAlarmManager.oneShot(
          Duration(seconds: timeSum),
          alarmId,
          callbackRestEnd,
          alarmClock: true,
          exact: true,
          wakeup: true,
        );
        timeSum += classLength;
      }
    }
    AndroidAlarmManager.oneShot(
      Duration(seconds: timeSum),
      (totalClass - 1) * 2,
      callbackLastClassEnd,
      alarmClock: true,
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
    // TODO: 알림 제거 로직 개편
    for (int i = 0; i < _totalPeriod * 2 - 1; i++) {
      AndroidAlarmManager.cancel(i);
    }

    await setClassState(state: ClassState.idle, period: -1, total: -1);

    await NotificationChannel.flutterLocalNotificationsPlugin.cancelAll();
  }

  static SendPort? uiSendPort;

  // TODO: static callback 위치 이동 및 로직 정리
  static Future<void> callbackClassEnd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final currentClass = prefs.getInt('currentClass')!;
    final totalClass = prefs.getInt('totalClass');

    await prefs.setInt('currentState', ClassState.restTime.index);
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

    await prefs.setInt('currentState', ClassState.inClass.index);

    BellSoundPlayer.playClassBell();

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);

    String noticeMessage =
        totalClass == currentClass ? '$currentClass교시 수업 중~ 오늘의 마지막 수업이에요. 화이팅!' : '지금은 $currentClass교시 수업 중!';

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
    await prefs.setInt('currentState', ClassState.idle.index);
    await prefs.setInt('totalClass', -1);
    await prefs.setInt('currentClass', -1);

    BellSoundPlayer.playRestBell();

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);

    await NotificationChannel.flutterLocalNotificationsPlugin.cancelAll();
  }
}
