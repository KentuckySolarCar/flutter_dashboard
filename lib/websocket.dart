import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:provider/provider.dart';

import 'package:uksc_dashboard/models/cruise_control.dart';
import 'package:uksc_dashboard/models/motors.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager extends ChangeNotifier {
  // final websocket = WebSocketChannel.connect(
  //     Uri(scheme: 'wss', host: userArgs['host'], port: int.tryParse(userArgs['port']) ?? defaultPort));
  Uri uri;

  late WebSocketChannel _websocket;

  final speed = Speed();
  final leftMotor = LeftMotor();
  final rightMotor = RightMotor();
  final cruiseControl = CruiseControl();

  late final List<ChangeNotifierProvider> providers;

  WebSocketManager(this.uri) {
    // for testing purposes:
    // async function timer thing to run speed.mph = 50 after 30 seconds
    Future.delayed(const Duration(seconds: 5), () {
      print('Starting speed simulation');
      // set the speed using a sin wave between 0-100 every 0.01 seconds
      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        var newData = {'speed': (sin(timer.tick * 0.01) * 50).toDouble() + 50};
        speed.updateFromJson(newData);
      });
    });

    // _connect();
    providers = [
      ChangeNotifierProvider.value(value: this),
      ChangeNotifierProvider.value(value: speed),
      ChangeNotifierProvider.value(value: leftMotor),
      ChangeNotifierProvider.value(value: rightMotor),
      ChangeNotifierProvider.value(value: cruiseControl),
    ];
  }

  /// initialize websocket on uri
  void _connect() {
    // TODO do we need to handle errors or anything here?
    _websocket = WebSocketChannel.connect(uri);
    // listen for messages, attempt to reconnect if connection is lost
    _websocket.stream.listen((message) {
      // check if message is json
      if (message is String) {
        try {
          final data = json.decode(message);
          // update models (indiscriminately, since it doesn't matter if no relevant keys for a model exist)
          speed.updateFromJson(data);
          leftMotor.updateFromJson(data);
          rightMotor.updateFromJson(data);
          cruiseControl.updateFromJson(data);
        } catch (e) {
          // TODO need logging
          print('Error decoding message: $e');
        }
      }
    }, onDone: () {
      // TODO need logging
      print('Websocket connection closed (${_websocket.closeCode}, ${_websocket.closeReason})');
      if (_websocket.closeCode != 1000) {
        // TODO need logging
        print('Attempting to reconnect');
        _connect();
      }
    });
  }

  void send(String message) {
    _websocket.sink.add(message);
  }

  void sendJson(Map<String, dynamic> message) {
    _websocket.sink.add(json.encode(message));
  }

  void close() {
    _websocket.sink.close(1000, 'Done with websocket');
  }
}
