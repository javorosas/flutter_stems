import 'package:flutter/material.dart';
import 'package:stems/player/StemsPlayer.dart';
import 'package:stems/player/Track.dart';
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

class PlayerWidget extends StatefulWidget {
  @override
  PlayerWidgetState createState() {
    return new PlayerWidgetState();
  }
}

class PlayerWidgetState extends State<PlayerWidget> {
  final StemsPlayer stemsPlayer =
      StemsPlayer([Track(title: 'Drums', source: '1_drums.mp3')]);

  @override
  void dispose() {
    stemsPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            color: Colors.deepPurple[200],
            child: Column(children: [
              Expanded(
                  child: ListView(
                children:
                    stemsPlayer.tracks.map((t) => TrackWidget(t)).toList(),
              )),
              _PlayerControls()
            ])));
  }
}
