import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BellSoundPlayer {
  static final AudioPlayer _audioPlayer = AudioPlayer(
    playerId: 'school_bell_player',
  );
  static final AudioCache _audioCachePlayer = AudioCache(
    prefix: 'assets/audio/',
    fixedPlayer: _audioPlayer,
  );

  static final List<String> _assetAudios = [
    'bellsound1.mp3',
    'bellsound2.mp3',
    'bellsound3.mp3',
    'bellsound4.mp3',
    'bellsound5.mp3',
    'bellsound6.mp3',
    'bellsound7.mp3',
    'bellsound8.mp3',
  ];

  Future<void> initialize() async {
    _audioCachePlayer.loadAll(_assetAudios);
  }

  static Future<void> playClassBell() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int assetClassBell = prefs.getInt('classBell') ?? 1;
    String? customClassBell = prefs.getString('customClassBellPath');

    if (customClassBell == null) {
      _audioCachePlayer.play(_assetAudios[assetClassBell - 1]);
    } else {
      int result = await _audioPlayer.play(customClassBell, isLocal: true);
      if (result != 1) {
        _audioCachePlayer.play(_assetAudios[0]);
        Fluttertoast.showToast(
          msg: "파일에 오류가 있어 기본 종소리를 재생했어요.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }

  static Future<void> playRestBell() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int assetRestBell = prefs.getInt('restBell') ?? 1;
    String? customRestBell = prefs.getString('customRestBellPath');

    if (customRestBell == null) {
      _audioCachePlayer.play(_assetAudios[assetRestBell - 1]);
    } else {
      int result = await _audioPlayer.play(customRestBell, isLocal: true);
      if (result != 1) {
        _audioCachePlayer.play(_assetAudios[0]);
        Fluttertoast.showToast(
          msg: "파일에 오류가 있어 기본 종소리를 재생했어요.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }
}
