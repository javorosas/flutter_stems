import 'package:flutter/material.dart';
import 'package:stems/player/Track.dart';

class TrackWidget extends StatefulWidget {
  TrackWidget(this._track, {Key key}) : super(key: key);

  final Track _track;

  @override
  TrackWidgetState createState() {
    return new TrackWidgetState(_track);
  }
}

class TrackWidgetState extends State<TrackWidget> {
  bool _muted = false;
  Track _track;

  TrackWidgetState(Track track, {Key key}) : _track = track;

  void _toggleMute() async {
    await _track.mute(_muted);
    setState(() {
      _muted = !_muted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Opacity(
        opacity: _muted ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: _toggleMute,
          child: Container(
            alignment: Alignment.center,
            child: Text(_track.title, style: TextStyle(fontSize: 24)),
            color: Colors.lightBlue,
            height: 80,
          ),
        ),
      ))
    ]);
  }
}
