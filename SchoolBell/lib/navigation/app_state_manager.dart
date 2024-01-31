import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  int _selectedTab = 0;
  bool _showOssLicenses = false;
  bool _showLicenseDetail = false;
  String _licenseKey = '';
  Map<String, dynamic> _licenseJson = {};

  int get selectedTab => _selectedTab;
  bool get showOssLicenses => _showOssLicenses;
  bool get showLicenseDetail => _showLicenseDetail;
  String get licenseKey => _licenseKey;
  Map<String, dynamic> get licenseJson => _licenseJson;

  void goToClassTab() {
    _selectedTab = 0;
    notifyListeners();
  }

  void goToSettingTab() {
    _selectedTab = 1;
    notifyListeners();
  }

  void openLicensesPage() {
    _showOssLicenses = true;
    notifyListeners();
  }

  void closeLicensesPage() {
    _showOssLicenses = false;
    notifyListeners();
  }

  void openLicenseDetail(String key, Map<String, dynamic> json) {
    _showLicenseDetail = true;
    _licenseKey = key;
    _licenseJson = json;
    notifyListeners();
  }

  void closeLicenseDetail() {
    _showLicenseDetail = false;
    _licenseKey = '';
    _licenseJson = {};
    notifyListeners();
  }
}
