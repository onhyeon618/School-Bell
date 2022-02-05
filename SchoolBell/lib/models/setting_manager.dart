import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BellMode {
  static const int onTime = 0;
  static const int byCustom = 1;
}

class SettingManager extends ChangeNotifier {
  late SharedPreferences prefs;

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

  Future<void> initialize() async {
    prefs = await SharedPreferences.getInstance();
    _bellMode = prefs.getInt('bellMode') ?? BellMode.onTime;
    _classLength = prefs.getInt('classLength') ?? 50;
    _restLength = prefs.getInt('restLength') ?? 10;
    _classBell = prefs.getInt('classBell') ?? 1;
    _restBell = prefs.getInt('restBell') ?? 1;
    _customClassBell = prefs.getString('customClassBell');
    _customRestBell = prefs.getString('customRestBell');
  }

  Future<void> setBellMode(int bellMode) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bellMode', bellMode);
    _bellMode = bellMode;
    notifyListeners();
  }

  Future<void> setClassLength(int classLength) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('classLength', classLength);
    _classLength = classLength;
    notifyListeners();
  }

  Future<void> setRestLength(int restLength) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('restLength', restLength);
    _restLength = restLength;
    notifyListeners();
  }

  Future<void> setClassBell(int classBell) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('classBell', classBell);
    _classBell = classBell;
    notifyListeners();
  }

  Future<void> setRestBell(int restBell) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('restBell', restBell);
    _restBell = restBell;
    notifyListeners();
  }

  Future<void> setCustomClassBell(String? customClassBell) async {
    prefs = await SharedPreferences.getInstance();
    if (customClassBell != null) {
      await prefs.setString('customClassBell', customClassBell);
    } else {
      await prefs.remove('customClassBell');
    }
    _customClassBell = customClassBell;
    notifyListeners();
  }

  Future<void> setCustomRestBell(String? customRestBell) async {
    prefs = await SharedPreferences.getInstance();
    if (customRestBell != null) {
      await prefs.setString('customRestBell', customRestBell);
    } else {
      await prefs.remove('customRestBell');
    }
    _customRestBell = customRestBell;
    notifyListeners();
  }
}
