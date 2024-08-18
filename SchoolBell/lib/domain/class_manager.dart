import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:school_bell/enum/alarm_type.dart';
import 'package:school_bell/enum/bell_mode.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:school_bell/service/alarm.dart';
import 'package:school_bell/service/notification.dart';
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
    await fetch();
  }

  Future<void> fetch() async {
    await _prefs.reload();

    _currentState = ClassState.fromInt(_prefs.getInt('currentState') ?? 0);
    _totalPeriod = _prefs.getInt('totalPeriod') ?? -1;
    _currentPeriod = _prefs.getInt('currentPeriod') ?? -1;

    notifyListeners();
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

  Future<void> startClass(int totalPeriod) async {
    await setClassState(state: ClassState.inClass, period: 1, total: totalPeriod);

    final bellMode = BellMode.fromInt(_prefs.getInt('bellMode') ?? 0);
    final classLength = (_prefs.getInt('classLength') ?? 50) * 60;
    final restLength = (_prefs.getInt('restLength') ?? 10) * 60;

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

    for (int alarmId = 0; alarmId < (totalPeriod - 1) * 2; alarmId++) {
      final alarmType = alarmId.isEven ? AlarmType.classEnd : AlarmType.restEnd;

      await AndroidAlarmManager.oneShot(
        Duration(seconds: timeSum),
        alarmId,
        AlarmService.callback,
        alarmClock: true,
        wakeup: true,
        params: {'alarmType': alarmType.index},
      );

      if (alarmId.isEven) {
        timeSum += restLength;
      } else {
        timeSum += classLength;
      }
    }
    await AndroidAlarmManager.oneShot(
      Duration(seconds: timeSum),
      (totalPeriod - 1) * 2,
      AlarmService.callback,
      alarmClock: true,
      wakeup: true,
      params: {'alarmType': AlarmType.lastClassEnd.index},
    );

    await NotificationService.instance.showNotification(
      '1교시 수업 중~! 오늘도 힘내봐요!',
    );

    notifyListeners();
  }

  Future<void> stopClass() async {
    for (int id = 0; id < _totalPeriod * 2 - 1; id++) {
      await AndroidAlarmManager.cancel(id);
    }

    await setClassState(state: ClassState.idle, period: -1, total: -1);

    await NotificationService.instance.cancelNotifications();
  }
}
