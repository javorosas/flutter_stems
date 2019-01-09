import 'dart:async';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:meta/meta.dart';

class Track {
  final _player = AudioCache(fixedPlayer: AudioPlayer());
  AudioPlayer get player => _player.fixedPlayer;

  final String title;
  final String source;

  Track({@required this.title, @required this.source}) {
    _player.load(source);
  }

  Future<void> play() async {
    await _player.play(source);
  }

  Future<void> resume() {
    return _player.fixedPlayer.resume();
  }

  Future<void> pause() async {
    await _player.fixedPlayer.pause();
  }

  Future<void> stop() async {
    await _player.fixedPlayer.stop();
  }

  Future<void> seek(int milliseconds) async {
    await _player.fixedPlayer.seek(Duration(milliseconds: milliseconds));
  }

  Future<void> mute(bool muted) => _player.fixedPlayer.setVolume(muted ? 0 : 1);
}
