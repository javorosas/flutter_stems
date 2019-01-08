import 'dart:async';
import 'package:audioplayer/audioplayer.dart';
import 'package:meta/meta.dart';

class Track {
  final _player = AudioPlayer();
  StreamSubscription<Duration> _positionSubscription;
  Duration _position;
  get position => _position;
  get state => _player.state;

  final String title;
  final String source;
  final Function onPositionChanged;

  Future<void> dispose() {
    return _positionSubscription.cancel();
  }

  Track({@required this.title, @required this.source, this.onPositionChanged}) {
    _positionSubscription = _player.onAudioPositionChanged.listen((p) {
      _position = p;
      if (onPositionChanged != null) {
        onPositionChanged(p);
      }
    });
  }

  Future<void> play() {
    return _player.play(source);
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> stop() async {
    await _player.stop();
    _position = new Duration(seconds: 0);
  }

  Future<void> seek(int milliseconds) async {
    await _player.seek(milliseconds / 1000.0);
    _position = new Duration(milliseconds: milliseconds);
  }

  Future<void> mute(bool muted) => _player.mute(muted);
}
