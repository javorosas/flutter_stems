import 'package:flutter/material.dart';
import 'package:stems/player/Track.dart';

class TrackWidget extends StatelessWidget {
  TrackWidget(this.track, {Key key}) : super(key: key);

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Container(
        child: Text(track.title),
        color: Colors.red,
        height: 80,
      ))
    ]);
  }
}
