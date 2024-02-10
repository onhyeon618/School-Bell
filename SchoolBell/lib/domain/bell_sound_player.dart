import 'package:audioplayers/audioplayers.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BellSoundPlayer {
  static final AudioPlayer _audioPlayer = AudioPlayer(
    playerId: 'school_bell_player',
  );

  static final List<String> _assetAudios = [
    'audio/bellsound1.mp3',
    'audio/bellsound2.mp3',
    'audio/bellsound3.mp3',
    'audio/bellsound4.mp3',
    'audio/bellsound5.mp3',
    'audio/bellsound6.mp3',
    'audio/bellsound7.mp3',
    'audio/bellsound8.mp3',
  ];

  void playSampleSound(int index) async {
    await _audioPlayer.play(AssetSource(_assetAudios[index - 1]));
  }

  void stopSampleSound() async {
    await _audioPlayer.stop();
  }

  static Future<void> playClassBell() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int assetClassBell = prefs.getInt('classBell') ?? 1;
    String? customClassBell = prefs.getString('customClassBellPath');

    if (customClassBell == null) {
      await _audioPlayer.play(AssetSource(_assetAudios[assetClassBell - 1]));
    } else {
      // TODO: 재생 오류 핸들링
      await _audioPlayer.play(DeviceFileSource(customClassBell));
      // int result = await _audioPlayer.play(customClassBell, isLocal: true);
      // if (result != 1) {
      //   await _audioPlayer.play(AssetSource(_assetAudios[0]));
      //   Fluttertoast.showToast(
      //     msg: "파일에 오류가 있어 기본 종소리를 재생했어요.",
      //     toastLength: Toast.LENGTH_SHORT,
      //     timeInSecForIosWeb: 1,
      //   );
      // }
    }
  }

  static Future<void> playRestBell() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int assetRestBell = prefs.getInt('restBell') ?? 1;
    String? customRestBell = prefs.getString('customRestBellPath');

    if (customRestBell == null) {
      await _audioPlayer.play(AssetSource(_assetAudios[assetRestBell - 1]));
    } else {
      await _audioPlayer.play(DeviceFileSource(customRestBell));
      // int result = await _audioPlayer.play(customRestBell, isLocal: true);
      // if (result != 1) {
      //   await _audioPlayer.play(AssetSource(_assetAudios[0]));
      //   Fluttertoast.showToast(
      //     msg: "파일에 오류가 있어 기본 종소리를 재생했어요.",
      //     toastLength: Toast.LENGTH_SHORT,
      //     timeInSecForIosWeb: 1,
      //   );
      // }
    }
  }
}
