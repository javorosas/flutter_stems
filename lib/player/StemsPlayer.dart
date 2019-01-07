import 'dart:async';
import 'package:audioplayer/audioplayer.dart';
import 'package:stems/player/Track.dart';

class StemsPlayer {
  var _state = AudioPlayerState.STOPPED;
  get state => _state;

  final List<Track> tracks;
  final Function onPositionChanged;

  StemsPlayer(this.tracks, {this.onPositionChanged}) {
    if (this.tracks.length <= 0) {
      throw ('The player must be initialized with at least one track');
    }
  }

  Future<void> play() async {
    await Future.wait(tracks.map((t) => t.play()));
    _state = AudioPlayerState.PLAYING;
  }

  Future<void> pause() async {
    await Future.wait(tracks.map((t) => t.pause()));
    // Sync position with first track
    final firstTrackPosition = tracks[0].position;
    await Future.wait(tracks.map((t) => t.seek(firstTrackPosition)));
    _state = AudioPlayerState.PAUSED;
  }

  Future<void> stop() async {
    await Future.wait(tracks.map((t) => t.stop()));
    _state = AudioPlayerState.STOPPED;
  }

  Future<void> dispose() async {
    await Future.wait(tracks.map((t) => t.dispose()));
  }
}
