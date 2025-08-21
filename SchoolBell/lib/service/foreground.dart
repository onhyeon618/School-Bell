import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForegroundService {
  static final ForegroundService instance = ForegroundService._internal();

  ForegroundService._internal();

  final _serviceId = 2003;

  void initialize() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'schoolbell-channel',
        channelName: '상태 알림',
        channelDescription: '학교종 앱이 실행 중일 때, 수업 상태를 표시하는 알림입니다.',
        onlyAlertOnce: true,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(eventAction: ForegroundTaskEventAction.nothing()),
    );
  }

  Future<ServiceRequestResult> startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        serviceId: _serviceId,
        notificationTitle: '',
        notificationText: '1교시 수업 중~! 오늘도 힘내봐요!',
        notificationIcon: const NotificationIcon(metaDataName: 'school_bell.service.NOTICE_ICON'),
      );
    }
  }

  Future<ServiceRequestResult> updateService({required String notificationText}) async {
    return FlutterForegroundTask.updateService(notificationText: notificationText);
  }

  Future<ServiceRequestResult> stopService() {
    return FlutterForegroundTask.stopService();
  }
}
