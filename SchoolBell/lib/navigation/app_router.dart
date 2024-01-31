import 'package:flutter/material.dart';
import 'package:school_bell/navigation/app_state_manager.dart';
import 'package:school_bell/navigation/schoolbell_pages.dart';
import '../presentation/screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;

  AppRouter({required this.appStateManager})
      : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        Home.page(),
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
