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

  final List<String> _bellModeName = <String>['정각 모드', '커스텀 모드'];

  String get bellMode => _bellModeName[_bellMode];
  String get classLength => '$_classLength분';
  String get restLength => '$_restLength분';
  String get classBell => '#$_classBell';
  String get restBell => '#$_restBell';

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
}
