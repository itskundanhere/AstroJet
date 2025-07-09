import 'dart:async';
import 'package:flame/components.dart';
import 'package:just_audio/just_audio.dart';

class AudioManager extends Component {
  bool musicEnabled = true;
  bool soundsEnabled = true;

  final List<String> _sounds = [
    'click',
    'collect',
    'explode1',
    'explode2',
    'fire',
    'hit',
    'laser',
    'start',
  ];

  final Map<String, AudioPlayer> _soundPlayers = {};
  late AudioPlayer _musicPlayer;

  @override
  FutureOr<void> onLoad() async {
    // Load sound effects
    for (String sound in _sounds) {
      final player = AudioPlayer();
      await player.setAsset('assets/audio/$sound.ogg');
      _soundPlayers[sound] = player;
    }

    // Load background music
    _musicPlayer = AudioPlayer();
    await _musicPlayer.setAsset('assets/audio/music.ogg');
    _musicPlayer.setLoopMode(LoopMode.one); // loop background music

    return super.onLoad();
  }

  void playMusic() {
    if (musicEnabled) {
      _musicPlayer.play();
    }
  }

  void playSound(String sound) {
    if (soundsEnabled && _soundPlayers.containsKey(sound)) {
      final player = _soundPlayers[sound]!;
      player.seek(Duration.zero);
      player.play();
    }
  }

  void toggleMusic() {
    musicEnabled = !musicEnabled;
    if (musicEnabled) {
      playMusic();
    } else {
      _musicPlayer.stop();
    }
  }

  void toggleSounds() {
    soundsEnabled = !soundsEnabled;
  }

  @override
  Future<void> onRemove() async {
    for (var player in _soundPlayers.values) {
      await player.dispose();
    }
    await _musicPlayer.dispose();
    _soundPlayers.clear();
    super.onRemove();
  }
}
