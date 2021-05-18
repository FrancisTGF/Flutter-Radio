
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';




void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioPlayer audioPlayer = AudioPlayer();
  static const streamUrl =
      "http://icecast-streaming.nice264.com/jaen";

  bool isPlaying;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
  }

  Future<void> audioStart() async {
    print('Audio Start OK');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Radio'),
        ),
        body: new Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.play_circle_filled),
                  onPressed: () {
                   play();
                   isPlaying=true;
                   playingStatus();
                  },
                ),
                FlatButton(
                  child: Icon(Icons.pause_circle_filled),
                  onPressed: () {
                    pause();
                    isPlaying=false;
                    playingStatus();
                  },
                ),
                FlatButton(
                  child: Icon(Icons.stop),
                  onPressed: () {
                    audioPlayer.stop();
                    playingStatus();
                  },
                ),
                Text(
                  'Estado: $isPlaying',
                  style: TextStyle(fontSize: 25.0),
                )
              ],
            )),
      ),
    );
  }

  Future playingStatus() async {
    setState(() {

    });
  }
  Future play() async {


    await audioPlayer.play(streamUrl);

  }
  Future pause() async {

    await audioPlayer.pause();

  }
}