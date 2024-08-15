import 'package:flutter/services.dart';

class MoveTaskBack {
  static const _channel = MethodChannel('schoolbell/move_task_back');

  static Future<void> moveTaskToBack() async {
    await _channel.invokeMethod('moveTaskToBack');
  }
}
