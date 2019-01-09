import 'dart:async';
import 'package:stems/player/Track.dart';

enum PlayerState {
  STOPPED,
  PLAYING,
  PAUSED,
  COMPLETED,
}

class StemsPlayer {
  // not to be confused with widget's state
  var _status = PlayerState.STOPPED;
  int _position = 0;
  int get position => _position;

  final List<Track> tracks;
  void Function(int) onPositionChanged;

  void _onPositionChanged(Duration position) {
    _position = position.inMilliseconds;
    if (onPositionChanged != null) {
      onPositionChanged(_position);
    }
  }

  StemsPlayer(this.tracks, {this.onPositionChanged}) {
    if (tracks.length <= 0) {
      throw ('The player must be initialized with at least one track');
    }
    tracks[0].player.positionHandler = _onPositionChanged;
  }

  Future<void> play() async {
    if (_status == PlayerState.STOPPED) {
      await Future.wait(tracks.map((t) => t.play()));
    } else {
      await Future.wait(tracks.map((t) => t.resumeAt(_position)));
    }
    _status = PlayerState.PLAYING;
  }

  Future<void> pause() async {
    _status = PlayerState.PAUSED;
    await Future.wait(tracks.map((t) => t.pause()));
  }

  Future<void> stop() async {
    await Future.wait(tracks.map((t) => t.stop()));
    _status = PlayerState.STOPPED;
  }

  Future<void> seek(int milliseconds) async {
    await Future.wait(tracks.map((t) => t.seek(milliseconds)));
    _status = PlayerState.STOPPED;
  }
}
