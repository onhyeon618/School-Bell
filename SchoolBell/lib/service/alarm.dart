import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:school_bell/bell_sound_player.dart';
import 'package:school_bell/enum/alarm_type.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:school_bell/service/foreground.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String isolateName = 'SchoolBellIsolate';

final ReceivePort port = ReceivePort();

class AlarmService {
  static final AlarmService instance = AlarmService._internal();

  AlarmService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, isolateName);
  }
}

@pragma('vm:entry-point')
Future<void> callbackForAlarm(int id, Map<String, dynamic> params) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.reload();

  final int currentPeriod = prefs.getInt('currentPeriod') ?? -1;
  final int totalPeriod = prefs.getInt('totalPeriod') ?? -1;

  if (currentPeriod < 0 || totalPeriod < 0) return;
  if (params['alarmType'] == null) return;

  final AlarmType type = AlarmType.fromInt(params['alarmType'] ?? 0);

  switch (type) {
    case AlarmType.classEnd:
      await prefs.setInt('currentState', ClassState.restTime.index);

      unawaited(BellSoundPlayer.instance.playRestBell());

      await ForegroundService.instance.updateService(
        notificationText: '$currentPeriod교시 쉬는 시간! 이제 ${totalPeriod - currentPeriod}교시 남았어요.',
      );
    case AlarmType.restEnd:
      await prefs.setInt('currentState', ClassState.inClass.index);
      await prefs.setInt('currentPeriod', currentPeriod + 1);

      unawaited(BellSoundPlayer.instance.playClassBell());

      await ForegroundService.instance.updateService(
        notificationText:
            totalPeriod == currentPeriod + 1
                ? '${currentPeriod + 1}교시 수업 중~ 오늘의 마지막 수업이에요. 화이팅!'
                : '지금은 ${currentPeriod + 1}교시 수업 중!',
      );
    case AlarmType.lastClassEnd:
      await prefs.setInt('currentState', ClassState.idle.index);
      await prefs.setInt('totalPeriod', -1);
      await prefs.setInt('currentPeriod', -1);

      unawaited(BellSoundPlayer.instance.playRestBell());

      await ForegroundService.instance.stopService();
  }

  final SendPort? uiSendPort = IsolateNameServer.lookupPortByName(isolateName);
  uiSendPort?.send(null);
}
