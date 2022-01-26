import 'package:flutter/material.dart';

class BellMode {
  static const int onTime = 0;
  static const int byCustom = 1;
}

class SettingManager extends ChangeNotifier {
  int _bellMode = BellMode.onTime;
  int _classLength = 50;
  int _restLength = 10;
  int _classBell = 1;
  int _restBell = 1;
  String? _customClassBell;
  String? _customRestBell;

  final List<String> _bellModeName = <String>['정각 모드', '커스텀 모드'];

  int get bellMode => _bellMode;
  int get classLength => _classLength;
  int get restLength => _restLength;
  int get classBell => _classBell;
  int get restBell => _restBell;

  String get bellModeName => _bellModeName[_bellMode];
  String get classLengthString => '$_classLength분';
  String get restLengthString => '$_restLength분';
  String get classBellString => '#$_classBell';
  String get restBellString => '#$_restBell';
  String? get customClassBell => _customClassBell;
  String? get customRestBell => _customRestBell;

  bool get isOnTime => _bellMode == BellMode.onTime ? true : false;

  void setBellMode(int bellMode) {
    _bellMode = bellMode;
    notifyListeners();
  }

  void setClassLength(int classLength) {
    _classLength = classLength;
    notifyListeners();
  }

  void setRestLength(int restLength) {
    _restLength = restLength;
    notifyListeners();
  }

  void setClassBell(int classBell) {
    _classBell = classBell;
    notifyListeners();
  }

  void setRestBell(int restBell) {
    _restBell = restBell;
    notifyListeners();
  }

  void setCustomClassBell(String? customClassBell) {
    _customClassBell = customClassBell;
    notifyListeners();
  }

  void setCustomRestBell(String? customRestBell) {
    _customRestBell = customRestBell;
    notifyListeners();
  }
}
