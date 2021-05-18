import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class StreamingController {
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'streaming', const StandardMethodCodec(), registrar.messenger);
    final StreamingController instance = StreamingController();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }
  MethodChannel _channel;
  var  streamingController =  StreamController<String>();
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'config':
        final String url = call.arguments['url'];
        return config(url: url );
      case 'play':
        return play();

      case 'pause':
        return pause();

      case 'stop':
        final String url = call.arguments['url'];
        return stop();
      case 'dispose':
        return dispose();
      case 'playing_event':
        streamingController.sink.add(call.method);
        return 'Playing, ${call.arguments}';
      case 'paused_event':
        streamingController.sink.add(call.method);
        return 'Paused, ${call.arguments}';
      case 'stopped_event':
        streamingController.sink.add(call.method);
        return 'Stopped, ${call.arguments}';
      case 'loading_event':
        streamingController.sink.add(call.method);
        return 'Loading, ${call.arguments}';
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_launcher plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

Future<void> config({String url,}) async {
  try {
    String result =
    await _channel.invokeMethod('config', <String, dynamic>{
      'url': url,
      'notification_title':"Test " ,
      'notification_description': "Description",
      'notification_color':"#FF0000",
      'notification_stop_button_text': "Stop",
      'notification_pause_button_text': "Pause",
      'notification_play_button_text': "Play",
      'notification_playing_description_text': "Playing",
      'notification_stopped_description_text': "Stopped"

    });
    return result;
  } catch (err) {
    throw Exception(err);
  }
}


Future<void> play() async {
  try {

  } catch (err) {
    throw Exception(err);
  }
}

Future<void> pause() async {
  try {

  } catch (err) {
    throw Exception(err);
  }
}

Future<void> stop() async {
  try {

  } catch (err) {
    throw Exception(err);
  }
}

void dispose(){
  streamingController.close();
}

}
