import 'dart:isolate';
import 'dart:ui';
import 'package:school_bell/channel/notification.dart';
import 'package:school_bell/domain/bell_sound_player.dart';
import 'package:school_bell/enum/alarm_type.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String isolateName = 'SchoolBellIsolate';

final ReceivePort port = ReceivePort();

class AlarmService {
  static final AlarmService instance = AlarmService._internal();

  AlarmService._internal();

  static SendPort? uiSendPort;

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );
  }

  @pragma('vm:entry-point')
  static Future<void> callback(int id, Map<String,dynamic> params) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final int currentClass = prefs.getInt('currentClass') ?? -1;
    final int totalClass = prefs.getInt('totalClass') ?? -1;

    if (currentClass < 0 || totalClass < 0) return;
    if (params['alarmType'] == null) return;

    final AlarmType type = AlarmType.fromInt(params['alarmType'] ?? 0);

    switch (type) {
      case AlarmType.classEnd:
        await prefs.setInt('currentState', ClassState.restTime.index);
        await prefs.setInt('currentClass', currentClass + 1);

        BellSoundPlayer.playRestBell();

        // TODO: Notification 동작 테스트
        await NotificationChannel.flutterLocalNotificationsPlugin.show(
          NotificationChannel.notificationId,
          null,
          '$currentClass교시 쉬는 시간! 이제 ${totalClass - currentClass}교시 남았어요.',
          NotificationChannel.platformChannelSpecifics,
        );
      case AlarmType.restEnd:
        await prefs.setInt('currentState', ClassState.inClass.index);

        BellSoundPlayer.playClassBell();

        String noticeMessage = totalClass == currentClass
            ? '$currentClass교시 수업 중~ 오늘의 마지막 수업이에요. 화이팅!'
            : '지금은 $currentClass교시 수업 중!';

        await NotificationChannel.flutterLocalNotificationsPlugin.show(
          NotificationChannel.notificationId,
          null,
          noticeMessage,
          NotificationChannel.platformChannelSpecifics,
        );
      case AlarmType.lastClassEnd:
        await prefs.setInt('currentState', ClassState.idle.index);
        await prefs.setInt('totalClass', -1);
        await prefs.setInt('currentClass', -1);

        BellSoundPlayer.playRestBell();

        await NotificationChannel.flutterLocalNotificationsPlugin.cancelAll();
    }

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }
}
