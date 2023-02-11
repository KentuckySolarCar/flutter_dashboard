import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:uksc_dashboard/models/cruise_control.dart';
import 'package:uksc_dashboard/models/motors.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:uksc_dashboard/models/base_model.dart';
import 'package:uksc_dashboard/models/telemetry_status.dart';

class TelemetryManager extends ChangeNotifier {
  /// The address pointing to the websocket host
  Uri uri;

  /// The time a message was last received at
  var lastReceived = DateTime.now();
  
  late WebSocketChannel _websocket;

  /// The status model
  final telemetryStatus = TelemetryStatus();
  
  final List<BaseModel> carModels = [
    Speed(),
    LeftMotor(),
    RightMotor(),
    CruiseControl(),
  ];


  // Map<String, dynamic> newData
  final Map<String, bool Function(Map<String, dynamic>)> subscriptions = HashMap();

  String _subscribe(List<String> ids) {
    // TODO
    return 'abc123';
  }

  void _connect() {
    for (final model in carModels) {
      // TODO subscribe to all keys in model.data
      // TODO add a callback to the subscription map
      // ... blah blah blah
      var subscriptionId = _subscribe(model.data.keys.toList());
      subscriptions[subscriptionId] = (Map<String, dynamic> newData) {
        return model.updateFromJson(newData);
      };
    }

  }


  TelemetryManager(this.uri, {testing = false}) {

    if (testing) {
      // for testing purposes:
      // async function timer thing to run speed.mph = 50 after 30 seconds
      telemetryStatus.status = Status.connecting;
      Future.delayed(const Duration(seconds: 5), () {
        print('Starting speed simulation');
        // set the speed using a sin wave between 0-100 every 0.01 seconds
        Timer.periodic(const Duration(milliseconds: 50), (timer) {
          telemetryStatus.status = Status.connected;
          // generate random nanosecond value between 1000000 and 3000000
          final latency = Random().nextInt(2000000) + 1000000;
          telemetryStatus.addLatency(latency);

          final newData = {'speed': (sin(timer.tick * 0.01) * 50).toDouble() + 50};
          for (final model in carModels) {
            model.updateFromJson(newData);
          }
        });
      });
    } else {
      // _connect();
    }
  }

  /// initialize websocket on uri
  void _connect() {
    telemetryStatus.status = Status.connecting;
    // TODO do we need to handle errors or anything here?
    _websocket = WebSocketChannel.connect(uri);
    telemetryStatus.status = Status.connected;
    // listen for messages, attempt to reconnect if connection is lost
    _websocket.stream.listen((message) {
      lastReceived = DateTime.now();
      // check if message is json
      try {
        final data = json.decode(message);
        // attempt to get timestamp in microseconds
        if (data.containsKey('timestamp') && data['timestamp'] is int) {
          final latency =
              DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(data['timestamp'])).inMicroseconds;
          telemetryStatus.addLatency(latency);
        } else {
          print('No valid timestamp found in message: $message');
          telemetryStatus.numErrors++;
        }

        // update models (indiscriminately, since it doesn't matter if no relevant keys for a model exist)
        for (final model in carModels) {
          model.updateFromJson(data);
        }
      } catch (e) {
        // TODO need logging
        print('Error decoding message $e');
        print('Message: $message');
        telemetryStatus.numErrors++;
      }
    }, onDone: () {
      telemetryStatus.status = Status.disconnected;
      // TODO need logging
      print('Websocket connection closed (${_websocket.closeCode}, ${_websocket.closeReason})');
      if (_websocket.closeCode != 1000) {
        // TODO need logging
        print('Attempting to reconnect');
        _connect();
      }
    });
  }

  /// send a message to the host
  void send(String message) {
    _websocket.sink.add(message);
  }

  /// send a json message to the host
  void sendJson(Map<String, dynamic> message) {
    _websocket.sink.add(json.encode(message));
  }

  /// close the websocket connection
  void close() {
    _websocket.sink.close(1000, 'Done with websocket');
  }

  ChangeNotifierProvider<TelemetryManager> get provider => ChangeNotifierProvider.value(value: this);
}
