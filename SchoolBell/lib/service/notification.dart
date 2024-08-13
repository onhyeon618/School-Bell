import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  NotificationService._internal();

  Future<void> initialize() async {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('sb_notice_icon'),
      ),
    );
  }

  final _notificationId = 2003;

  final NotificationDetails _notificationDetails = const NotificationDetails(
    android: AndroidNotificationDetails(
      'school-bell-channel',
      '상태 알림',
      channelDescription: '학교종 앱이 실행 중일 때, 수업 상태를 표시하는 알림입니다.',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
    ),
  );

  Future<void> showNotification(String content) {
    return flutterLocalNotificationsPlugin.show(
      _notificationId,
      null,
      content,
      _notificationDetails,
    );
  }

  Future<void> cancelNotifications() {
    return flutterLocalNotificationsPlugin.cancelAll();
  }
}
