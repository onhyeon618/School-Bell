import 'dart:async';
import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  bool _initialized = false; // 스플래시 노출 여부: 최초 실행 시에만 노출
  bool _showOssLicenses = false;
  bool _showLicenseDetail = false;
  String _licenseKey = '';
  Map<String, dynamic> _licenseJson = {};

  bool get isInitialized => _initialized;
  bool get showOssLicenses => _showOssLicenses;
  bool get showLicenseDetail => _showLicenseDetail;
  String get licenseKey => _licenseKey;
  Map<String, dynamic> get licenseJson => _licenseJson;

  void initializeApp() {
    Timer(
      const Duration(milliseconds: 2000),
      () {
        _initialized = true;
        notifyListeners();
      },
    );
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
