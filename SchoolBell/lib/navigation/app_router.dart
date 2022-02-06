import 'package:flutter/material.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final ClassManager classManager;

  AppRouter({
    required this.appStateManager,
    required this.classManager
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    classManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    classManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!appStateManager.isInitialized) SplashScreen.page(),
        if (appStateManager.isInitialized) Home.page(),
        if (appStateManager.showOssLicenses) LicensesScreen.page(),
        if (appStateManager.showLicenseDetail)
          LicenseDetail.page(
            name: appStateManager.licenseKey,
            json: appStateManager.licenseJson,
          ),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }
    if (route.settings.name == SchoolbellPages.licensesPath) {
      appStateManager.closeLicensesPage();
    }
    if (route.settings.name == SchoolbellPages.licenseDetailPath) {
      appStateManager.closeLicenseDetail();
    }
    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
