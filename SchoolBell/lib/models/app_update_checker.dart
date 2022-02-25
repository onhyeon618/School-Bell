import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:store_redirect/store_redirect.dart';

class AppUpdateChecker extends ChangeNotifier {
  bool _isUpdateAvailable = false;

  bool get isUpdateAvailable => _isUpdateAvailable;

  Future<void> checkForUpdate() async {
    AppUpdateInfo info = await InAppUpdate.checkForUpdate();
    _isUpdateAvailable =
        info.updateAvailability == UpdateAvailability.updateAvailable;
    notifyListeners();
  }

  void redirectToStore() {
    StoreRedirect.redirect();
  }
}
