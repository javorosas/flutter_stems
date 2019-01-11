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
  Duration _position = Duration(milliseconds: 0);
  Duration get position => _position;

  final List<Track> tracks;
  void Function(Duration) onPositionChanged;

  void _onPositionChanged(Duration position) {
    _position = position;
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
      // Sync them first
      await Future.wait(tracks.map((t) => t.seek(_position)));
      // Then make them resume
      await Future.wait(tracks.map((t) => t.resume()));
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

  Future<void> seek(Duration position) async {
    await Future.wait(tracks.map((t) => t.seek(position)));
    _status = PlayerState.STOPPED;
  }
}
