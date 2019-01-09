import 'package:flutter/material.dart';
import 'package:stems/player/StemsPlayer.dart';
import 'package:stems/player/Track.dart';
import 'package:stems/ui/TrackWidget.dart';

class _PlayerButton extends StatelessWidget {
  final Function _onPressed;
  final IconData icon;

  _PlayerButton(this.icon, {Key key, Function onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: 50,
            child: FlatButton(
              padding: null,
              textColor: Colors.white,
              child: Icon(this.icon),
              onPressed: _onPressed,
            )));
  }
}

class _PlayerControls extends StatefulWidget {
  final Function onTapBack;
  final Function onTapPlay;
  final Function onTapStop;
  var status = PlayerState.STOPPED;

  _PlayerControls(
      {this.onTapBack, this.onTapPlay, this.onTapStop, this.status});

  @override
  _PlayerControlsState createState() {
    return new _PlayerControlsState();
  }
}

class _PlayerControlsState extends State<_PlayerControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[900],
      child: Row(children: [
        _PlayerButton(
          Icons.skip_previous,
          onPressed: widget.onTapBack,
        ),
        _PlayerButton(
          Icons.stop,
          onPressed: widget.onTapStop,
        ),
        _PlayerButton(
          widget.status == PlayerState.PLAYING ? Icons.pause : Icons.play_arrow,
          onPressed: widget.onTapPlay,
        ),
      ]),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  @override
  _PlayerWidgetState createState() {
    return new _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  final stemsPlayer = StemsPlayer([
    Track(title: 'Drums', source: '1_drums.mp3'),
    Track(title: 'Bass', source: '2_bass.mp3'),
    Track(title: 'Guitar', source: '3_guitar.mp3'),
  ]);

  int _position = 0;
  var _status = PlayerState.STOPPED;

  void onTapPlay() async {
    PlayerState newStatus;
    if (_status == PlayerState.PLAYING) {
      newStatus = PlayerState.PAUSED;
      await stemsPlayer.pause();
    } else {
      newStatus = PlayerState.PLAYING;
      await stemsPlayer.play();
    }
    setState(() {
      _status = newStatus;
    });
  }

  void onTapBack() async {
    await stemsPlayer.seek(0);
  }

  void onTapStop() async {
    await stemsPlayer.stop();
  }

  void onPositionChanged(int position) {
    setState(() {
      _position = position;
    });
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
              _PlayerControls(
                  onTapPlay: this.onTapPlay,
                  onTapBack: this.onTapBack,
                  onTapStop: this.onTapStop)
            ])));
  }
}
