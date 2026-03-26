import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AlarmService {
  final AudioPlayer _player = AudioPlayer();
  bool _isActive = false;

  bool get isActive => _isActive;

  Future<void> startAlarm() async {
    if (_isActive) {
      return;
    }

    _isActive = true;

    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(1.0);
    await _player.play(
      AssetSource('audio/alarm.wav'),
      volume: 1.0,
      ctx: AudioContextConfig(
        route: AudioContextConfigRoute.speaker,
        focus: AudioContextConfigFocus.gain,
        stayAwake: true,
      ).build(),
    );

    await _startVibration();
  }

  Future<void> stopAlarm() async {
    if (!_isActive) {
      return;
    }

    _isActive = false;
    await _player.stop();
    await Vibration.cancel();
  }

  Future<void> dispose() async {
    await stopAlarm();
    await _player.dispose();
  }

  Future<void> _startVibration() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (!hasVibrator) {
      return;
    }

    await Vibration.vibrate(
      pattern: const [0, 1200, 400, 1200],
      repeat: 0,
    );
  }
}
