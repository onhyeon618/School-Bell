import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BellSoundPlayer {
  static final AudioCache _player = AudioCache(prefix: 'assets/audio/');
  // TODO: 로컬 파일 실행 테스트
  static final AudioPlayer _audioPlayer = AudioPlayer(
    mode: PlayerMode.LOW_LATENCY,
    playerId: 'school_bell_player',
  );

  // TODO: 실제 음원파일 적용
  static final List<String> _assetAudios = ['sample1.wav', 'sample2.wav'];

  Future<void> initialize() async {
    _player.loadAll(_assetAudios);
  }

  static Future<void> playClassBell() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int assetClassBell = prefs.getInt('classBell') ?? 1;
    String? customClassBell = prefs.getString('customClassBell');

    if (customClassBell == null) {
      _player.play(_assetAudios[assetClassBell - 1]);
    } else {
      await _audioPlayer.play(customClassBell, isLocal: true);
    }
  }

  static Future<void> playRestBell() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    int assetRestBell = prefs.getInt('restBell') ?? 1;
    String? customRestBell = prefs.getString('customRestBell');

    if (customRestBell == null) {
      _player.play(_assetAudios[assetRestBell - 1]);
    } else {
      await _audioPlayer.play(customRestBell, isLocal: true);
    }
  }
}
