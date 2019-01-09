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
  final void Function() onSkipBack;
  final void Function(PlayerState) onStatusChanged;

  _PlayerControls({this.onSkipBack, this.onStatusChanged});

  @override
  _PlayerControlsState createState() {
    return new _PlayerControlsState();
  }
}

class _PlayerControlsState extends State<_PlayerControls> {
  var _status = PlayerState.STOPPED;

  void onTapPlay() async {
    PlayerState newStatus;
    if (_status == PlayerState.PLAYING) {
      newStatus = PlayerState.PAUSED;
      widget.onStatusChanged(newStatus);
    } else {
      newStatus = PlayerState.PLAYING;
      widget.onStatusChanged(newStatus);
    }
    setState(() {
      _status = newStatus;
    });
  }

  void onTapBack() async {
    widget.onSkipBack();
  }

  void onTapStop() async {
    widget.onStatusChanged(PlayerState.STOPPED);
    setState(() {
      _status = PlayerState.STOPPED;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[900],
      child: Row(children: [
        _PlayerButton(
          Icons.skip_previous,
          onPressed: widget.onSkipBack,
        ),
        _PlayerButton(
          Icons.stop,
          onPressed: onTapStop,
        ),
        _PlayerButton(
          _status == PlayerState.PLAYING ? Icons.pause : Icons.play_arrow,
          onPressed: onTapPlay,
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
    Track(title: 'Vocals', source: '4_vocals.mp3'),
    Track(title: 'Additional', source: '5_additional_instruments.mp3'),
  ]);

  int _position = 0;
  var _status = PlayerState.STOPPED;

  void _onPositionChanged(int position) {
    setState(() {
      _position = position;
    });
  }

  void _onStatusChanged(PlayerState newStatus) async {
    switch (newStatus) {
      case PlayerState.PLAYING:
        await stemsPlayer.play();
        break;
      case PlayerState.PAUSED:
        await stemsPlayer.pause();
        break;
      default:
        await stemsPlayer.stop();
    }
    setState(() {
      _status = newStatus;
    });
  }

  void _onSkipBack() async {
    await stemsPlayer.seek(0);
  }

  @override
  void initState() {
    super.initState();
    stemsPlayer.onPositionChanged = _onPositionChanged;
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
                onStatusChanged: this._onStatusChanged,
                onSkipBack: this._onSkipBack,
              )
            ])));
  }
}
