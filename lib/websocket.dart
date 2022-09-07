import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:uksc_dashboard/models/cruise_control.dart';
import 'package:uksc_dashboard/models/motors.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:uksc_dashboard/models/generic.dart';
import 'package:uksc_dashboard/constants.dart';

enum Status { disconnected, connecting, connected }

// TODO I kind of don't like how this is organized... should it be in the models directory?
class WebSocketStatus extends ChangeNotifier {
  var _status = Status.disconnected;

  // var _status = Status.connecting;
  // var _status = Status.connected;

  var _numErrors = 0;
  var _recentLatencies = <int>[];

  Status get status => _status;

  set status(newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  bool get areErrorsPresent => _numErrors != 0;

  int get numErrors => _numErrors;

  set numErrors(int newNumErrors) {
    _numErrors = newNumErrors;
    notifyListeners();
  }

  /// The average latency, in nanoseconds.
  int get averageLatency {
    if (_recentLatencies.isEmpty) {
      return 0;
    }
    return _recentLatencies.reduce((a, b) => a + b) ~/ _recentLatencies.length;
  }

  /// The average latency over the last 10 messages, in milliseconds.
  double get averageLatencyMs => averageLatency / 1000000;

  /// Add a new latency to the list of recent latencies.
  void addLatency(int newLatency) {
    _recentLatencies.add(newLatency);
    if (_recentLatencies.length > latencyAverageCount) {
      _recentLatencies.removeAt(0);
    }
    notifyListeners();
  }

  @override
  String toString() {
    // return status with first letter capitalized
    final statusString = status.name.substring(0, 1).toUpperCase() + status.name.substring(1);
    final errorString = areErrorsPresent ? '($_numErrors errors caught, please check the logs!)' : '';
    return '$statusString $errorString';
  }
}

class WebSocketManager extends ChangeNotifier {
  /// The address pointing to the websocket host
  Uri uri;

  /// The time a message was last received at
  var lastReceived = DateTime.now();

  late WebSocketChannel _websocket;

  final webSocketStatus = WebSocketStatus();

  final List<BaseModel> carModels = [
    Speed(),
    LeftMotor(),
    RightMotor(),
    CruiseControl(),
  ];

  WebSocketManager(this.uri, {testing = false}) {
    if (testing) {
      // for testing purposes:
      // async function timer thing to run speed.mph = 50 after 30 seconds
      webSocketStatus.status = Status.connecting;
      Future.delayed(const Duration(seconds: 5), () {
        print('Starting speed simulation');
        // set the speed using a sin wave between 0-100 every 0.01 seconds
        Timer.periodic(const Duration(milliseconds: 10), (timer) {
          webSocketStatus.status = Status.connected;
          // generate random nanosecond value between 1000000 and 3000000
          final latency = Random().nextInt(2000000) + 1000000;
          webSocketStatus.addLatency(latency);

          final newData = {'speed': (sin(timer.tick * 0.01) * 50).toDouble() + 50};
          for (final model in carModels) {
            model.updateFromJson(newData);
          }
        });
      });
    } else {
      _connect();
    }
  }

  /// initialize websocket on uri
  void _connect() {
    webSocketStatus.status = Status.connecting;
    // TODO do we need to handle errors or anything here?
    _websocket = WebSocketChannel.connect(uri);
    webSocketStatus.status = Status.connected;
    // listen for messages, attempt to reconnect if connection is lost
    _websocket.stream.listen((message) {
      lastReceived = DateTime.now();
      // check if message is json
      try {
        final data = json.decode(message);
        // attempt to get timestamp in nanoseconds
        if (data.containsKey('timestamp') && data['timestamp'] is int) {
          final latency =
              DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(data['timestamp'] ~/ 1000)).inMicroseconds;
          webSocketStatus.addLatency(latency);
        } else {
          print('No valid timestamp found in message: $message');
          webSocketStatus.numErrors++;
        }

        // update models (indiscriminately, since it doesn't matter if no relevant keys for a model exist)
        for (final model in carModels) {
          model.updateFromJson(data);
        }
      } catch (e) {
        // TODO need logging
        print('Error decoding message $e');
        print('Message: $message');
        webSocketStatus.numErrors++;
      }
    }, onDone: () {
      webSocketStatus.status = Status.disconnected;
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
}
