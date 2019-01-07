import 'package:flutter/material.dart';
import 'package:stems/player/StemsPlayer.dart';
import 'package:stems/ui/TrackWidget.dart';

class _PlayerButton extends StatelessWidget {
  final IconData icon;

  _PlayerButton(this.icon, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: 50,
            child: FlatButton(
              padding: null,
              textColor: Colors.white,
              child: Icon(this.icon),
              onPressed: () {},
            )));
  }
}

class _PlayerControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[900],
      child: Row(children: [
        _PlayerButton(Icons.skip_previous),
        _PlayerButton(Icons.stop),
        _PlayerButton(Icons.play_arrow),
      ]),
    );
  }
}

class PlayerWidget extends StatelessWidget {
  final StemsPlayer stemsPlayer;

  PlayerWidget(this.stemsPlayer, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.deepPurple[200],
        child: Column(children: [
          Expanded(
              child: ListView(
            children: stemsPlayer.tracks.map((t) => TrackWidget(t)).toList(),
          )),
          _PlayerControls()
        ]));
  }
}
