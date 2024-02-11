import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateChecker extends ChangeNotifier {
  bool _isUpdateAvailable = false;

  bool get isUpdateAvailable => _isUpdateAvailable;

  Future<void> checkForUpdate() async {
    AppUpdateInfo info = await InAppUpdate.checkForUpdate();
    _isUpdateAvailable = info.updateAvailability == UpdateAvailability.updateAvailable;
    notifyListeners();
  }

  // TODO: 버전 이슈로 디펜던시 제거 - 대체 방안 구현 필요
  // void redirectToStore() {
  //   StoreRedirect.redirect();
  // }
}
