import 'dart:async';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FlutterRadioWeb {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'flutter_radio', const StandardMethodCodec(), registrar.messenger);
    final FlutterRadioWeb instance = FlutterRadioWeb();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'audioStart':
        final AudioPlayerItem item = call.arguments['item'];
        return audioStart(item);
      case 'play':
        final String url = call.arguments['url'];
        return play(url: url);
      case 'playOrPause':
        final String url = call.arguments['url'];
        return playOrPause(url: url);

      case 'pause':
        final String url = call.arguments['url'];
        return pause(url: url);

      case 'stop':
        final String url = call.arguments['url'];
        return stop();
      case 'setVolume':
        final double volume = call.arguments['volume'];
        return setVolume(volume);

      case 'stop':
        final AudioPlayerItem item = call.arguments['item'];
        return setMeta(item);

      case '_removePlayerCallback':

        return _removePlayerCallback();

      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_launcher plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }


  static StreamController<PlayStatus> _playerController;

  static const MethodChannel _channel = const MethodChannel('flutter_radio');
  /// Value ranges from 0 to 120
  Stream<PlayStatus> get onPlayerStateChanged => _playerController.stream;

  static bool _isPlaying = false;

  static Future<void> audioStart([AudioPlayerItem item]) async {
    if (item != null) {
      await setMeta(item);
    }

  }

  static Future<void> playOrPause({@required String url}) async {
    try {
      if (FlutterRadioWeb._isPlaying) {
        FlutterRadioWeb.pause(url: url);
      } else {
        FlutterRadioWeb.play(url: url);
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  static Future<void> play({@required String url}) async {
    try {
      _playerController = new StreamController.broadcast();

      if (FlutterRadioWeb._isPlaying) {
        throw Exception('Player is already playing.');
      }
      FlutterRadioWeb._isPlaying = true;

    } catch (err) {
      throw Exception(err);
    }
  }

  static Future<void> pause({@required String url}) async {
    if (!FlutterRadioWeb._isPlaying) {
      throw Exception('Player already stopped.');
    }
    FlutterRadioWeb._isPlaying = false;

    _removePlayerCallback();
  }

  static Future<void> stop() async {
    if (!FlutterRadioWeb._isPlaying) {
      throw Exception('Player already stopped.');
    }
    FlutterRadioWeb._isPlaying = false;

    _removePlayerCallback();
  }

  static Future<bool> isPlaying() async {
    return Future.value(_isPlaying);
  }

  static Future<void> _setPlayerCallback() async {
    if (_playerController == null) {
      _playerController = new StreamController.broadcast();
    }
  }

  static Future<void> _removePlayerCallback() async {
    if (_playerController != null) {
      _playerController
        ..add(null)
        ..close();
      _playerController = null;
    }
  }

  static Future<String> setMeta(AudioPlayerItem item) async {

    _removePlayerCallback();

  }

  static Future<String> setVolume(double volume) async {
    String result = '';
    if (volume < 0.0 || volume > 1.0) {
      result = 'Value of volume should be between 0.0 and 1.0.';
      return result;
    }
  }
}

class PlayStatus {
  final double duration;
  double currentPosition;

  PlayStatus.fromJSON(Map<String, dynamic> json)
      : duration = double.parse(json['duration']),
        currentPosition = double.parse(json['current_position']);

  @override
  String toString() {
    return 'duration: $duration, '
        'currentPosition: $currentPosition';
  }
}

class AudioPlayerItem {
  String id;
  String url;
  String thumbUrl;
  String title;
  Duration duration;
  double progress;
  String album;
  bool local;

  AudioPlayerItem(
      {this.id,
      this.url,
      this.thumbUrl,
      this.title,
      this.duration,
      this.progress,
      this.album,
      this.local});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'url': this.url,
      'thumb': this.thumbUrl,
      'title': this.title,
      'duration': this.duration != null ? this.duration.inSeconds : 0,
      'progress': this.progress ?? 0,
      'album': this.album,
      'local': this.local
    };
  }
}
