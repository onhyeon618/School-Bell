import 'package:audioplayers/audioplayers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BellSoundPlayer {
  static final BellSoundPlayer instance = BellSoundPlayer._internal();

  BellSoundPlayer._internal();

  final _player = AudioPlayer(
    playerId: 'school_bell_player',
  );

  final List<String> _assetAudios = [
    'audio/bellsound1.mp3',
    'audio/bellsound2.mp3',
    'audio/bellsound3.mp3',
    'audio/bellsound4.mp3',
    'audio/bellsound5.mp3',
    'audio/bellsound6.mp3',
    'audio/bellsound7.mp3',
    'audio/bellsound8.mp3',
  ];

  Future<void> playAssetSource(int index) async {
    await _player.play(AssetSource(_assetAudios[index]));
  }

  Future<void> playDeviceFile(String file) async {
    try {
      await _player.play(DeviceFileSource(file));
    } catch (e) {
      await _player.play(AssetSource(_assetAudios[0]));

      Fluttertoast.showToast(
        msg: '파일에 오류가 있어 기본 종소리를 재생했어요.',
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  Future<void> playClassBell() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final classBell = prefs.getInt('classBell') ?? 0;
    final customClassBell = prefs.getString('customClassBellPath');

    if (customClassBell == null) {
      playAssetSource(classBell);
    } else {
      playDeviceFile(customClassBell);
    }
  }

  Future<void> playRestBell() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();

    final restBell = prefs.getInt('restBell') ?? 0;
    final customRestBell = prefs.getString('customRestBellPath');

    if (customRestBell == null) {
      playAssetSource(restBell);
    } else {
      playDeviceFile(customRestBell);
    }
  }

  void stopPlaying() async {
    await _player.release();
  }
}
