import 'package:flutter/material.dart';
import 'package:school_bell/enum/bell_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingManager extends ChangeNotifier {
  late final SharedPreferences _prefs;

  /// 종소리 모드
  BellMode _bellMode = BellMode.onTime;

  /// 한 교시 길이
  int _classLength = 50;

  /// 쉬는 시간 길이
  int _restLength = 10;

  /// 수업 시작 종
  int _classBell = 1;

  /// 수업 시작 종(커스텀): null이 아니면 커스텀 설정된 것으로 간주
  String? _customClassBell;

  /// 수업 종료 종
  int _restBell = 1;

  /// 수업 종료 종(커스텀): null이 아니면 커스텀 설정된 것으로 간주
  String? _customRestBell;

  BellMode get bellMode => _bellMode;

  int get classLength => _classLength;

  int get restLength => _restLength;

  int get classBell => _classBell;

  int get restBell => _restBell;

  String get classBellName => _customClassBell ?? '#${_classBell + 1}';

  String get restBellName => _customRestBell ?? '#${_restBell + 1}';

  bool get isOnTime => _bellMode == BellMode.onTime ? true : false;

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.reload();

    _bellMode = BellMode.fromInt(_prefs.getInt('bellMode') ?? 0);
    _classLength = _prefs.getInt('classLength') ?? 50;
    _restLength = _prefs.getInt('restLength') ?? 10;
    _classBell = _prefs.getInt('classBell') ?? 0;
    _restBell = _prefs.getInt('restBell') ?? 0;
    _customClassBell = _prefs.getString('customClassBellName');
    _customRestBell = _prefs.getString('customRestBellName');
  }

  Future<void> setBellMode(int bellMode) async {
    await _prefs.setInt('bellMode', bellMode);
    _bellMode = BellMode.fromInt(bellMode);
    notifyListeners();
  }

  Future<void> setClassLength(int classLength) async {
    await _prefs.setInt('classLength', classLength);
    _classLength = classLength;
    notifyListeners();
  }

  Future<void> setRestLength(int restLength) async {
    await _prefs.setInt('restLength', restLength);
    _restLength = restLength;
    notifyListeners();
  }

  Future<void> setClassBell(Object classBell) async {
    if (classBell is int) {
      await _prefs.setInt('classBell', classBell);
      _classBell = classBell;

      await _prefs.remove('customClassBellPath');
      await _prefs.remove('customClassBellName');
      _customClassBell = null;
    } else {
      await _prefs.setInt('classBell', 8);
      _classBell = 8;

      String fileName = classBell.toString().split('/').last;
      await _prefs.setString('customClassBellPath', classBell.toString());
      await _prefs.setString('customClassBellName', fileName);
      _customClassBell = fileName;
    }

    notifyListeners();
  }

  Future<void> setRestBell(Object restBell) async {
    if (restBell is int) {
      await _prefs.setInt('restBell', restBell);
      _restBell = restBell;

      await _prefs.remove('customRestBellPath');
      await _prefs.remove('customRestBellName');
      _customRestBell = null;
    } else {
      await _prefs.setInt('restBell', 8);
      _classBell = 8;

      String fileName = restBell.toString().split('/').last;
      await _prefs.setString('customRestBellPath', restBell.toString());
      await _prefs.setString('customRestBellName', fileName);
      _customClassBell = fileName;
    }

    notifyListeners();
  }
}
