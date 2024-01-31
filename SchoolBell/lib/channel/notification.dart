import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannel {
  static const _notificationId = 2003;

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'school-bell-channel',
    'school-bell-channel',
    channelDescription: 'notification channel for school bell app',
    importance: Importance.low,
    priority: Priority.low,
    playSound: false,
    enableVibration: false,
    ongoing: true,
    autoCancel: false,
    showWhen: false,
  );

  static const NotificationDetails _platformChannelSpecifics =
      NotificationDetails(android: _androidPlatformChannelSpecifics);

  static int get notificationId => _notificationId;

  static FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;

  static AndroidNotificationDetails get androidPlatformChannelSpecifics =>
      _androidPlatformChannelSpecifics;

  static NotificationDetails get platformChannelSpecifics =>
      _platformChannelSpecifics;
}
