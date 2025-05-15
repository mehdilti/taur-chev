import 'package:audioplayers/audioplayers.dart';

class SoundService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playWinSound() async {
    await _audioPlayer.play(AssetSource('sounds/win.mp3'));
  }

  Future<void> playLoseSound() async {
    await _audioPlayer.play(AssetSource('sounds/lose.mp3'));
  }

  Future<void> playClickSound() async {
    await _audioPlayer.play(AssetSource('sounds/click.mp3'));
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
