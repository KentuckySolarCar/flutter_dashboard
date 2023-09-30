import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:uksc_dashboard/models/cruise_control.dart';
import 'package:uksc_dashboard/models/motors.dart';
import 'package:uksc_dashboard/models/speed.dart';
import 'package:uksc_dashboard/models/base_model.dart';
import 'package:uksc_dashboard/models/telemetry_status.dart';

import 'package:uksc_dashboard/api/viss/viss.dart';
import 'package:uksc_dashboard/api/viss/models/request.dart';

class TelemetryManager extends ChangeNotifier {
  /// The address pointing to the websocket host
  Uri uri;

  /// The time a message was last received at
  var lastReceived = DateTime.now();

  late WebSocketChannel _websocket;

  late VissApi _vissApi;

  /// The status model
  final telemetryStatus = TelemetryStatus();

  final List<BaseModel> carModels = [
    Speed(),
    // LeftMotor(),
    // RightMotor(),
    // CruiseControl(),
  ];

  void _subscribeModels() {
    for (final model in carModels) {
      var bestNode = VissApi.findBestSharedNode(model.nodes);

      var subscriptionRequest = SubscribeRequest(bestNode);
      _vissApi.subscribe(subscriptionRequest, (subscriptionDataResponse) {
        print(
            'Received subscription data for ${subscriptionDataResponse.subscriptionId}');
        model.updateFromData(subscriptionDataResponse.data);
      });
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

          final newData = {
            'Vehicle.Speed':
                ((sin(timer.tick * 0.01) * 50).toDouble() + 50).toString()
          };
          for (final model in carModels) {
            model.updateFromJson(newData);
          }
        });
      });
    } else {
      // _connect();
      print('Connecting to VISS API $uri');
      _vissApi = VissApi(uri);
      _vissApi.connect();
      var authorizeRequest = AuthorizeRequest(
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJrdWtzYS52YWwiLCJpc3MiOiJFY2xpcHNlIEtVS1NBIERldiIsImFkbWluIjp0cnVlLCJpYXQiOjE1MTYyMzkwMjIsImV4cCI6MTc2NzIyNTU5OSwia3Vrc2EtdnNzIjp7IioiOiJydyJ9fQ.QQcVR0RuRJIoasPXYsMGZhdvhLjUalk4GcRaxhh3-0_j3CtVSZ0lTbv_Z3As5BfIYzaMlwUzFGvCVOq2MXVjRK81XOAZ6wIsyKOxva16zjbZryr2V_m3yZ4twI3CPEzJch11_qnhInirHltej-tGg6ySfLaTYeAkw4xYGwENMBBhN5t9odANpScZP_xx5bNfwdW1so6FkV1WhpKlCywoxk_vYZxo187d89bbiu-xOZUa5D-ycFkd1-1rjPXLGE_g5bc4jcQBvNBc-5FDbvt4aJlTQqjpdeppxhxn_gjkPGIAacYDI7szOLC-WYajTStbksUju1iQCyli11kPx0E66me_ZVwOX07f1lRF6D2brWm1LcMAHM3bQUK0LuyVwWPxld64uSAEsvSKsRyJERc7nZUgLf7COnUrrkxgIUNjukbdT2JVN_I-3l3b4YXg6JVD7Y5g0QYBKgXEFpZrDbBVhzo7PXPAhJD6-c3DcUQyRZExbrnFV56RwWuExphw8lYnbMvxPWImiVmB9nRVgFKD0TYaw1sidPSSlZt8Uw34VZzHWIZQAQY0BMjR33fefg42XQ1YzIwPmDx4GYXLl7HNIIVbsRsibKaJnf49mz2qnLC1K272zXSPljO11Ke1MNnsnKyUH7mcwEs9nhTsnMgEOx_TyMLRYo-VEHBDLuEOiBo');
      _vissApi.makeRequest(authorizeRequest).then((value) => {
            print('Authorized'),
            _subscribeModels(),
          });
    }
  }

  /// initialize websocket on uri
  // void _connect() {
  //   telemetryStatus.status = Status.connecting;
  //   // TODO do we need to handle errors or anything here?
  //   _websocket = WebSocketChannel.connect(uri);
  //   telemetryStatus.status = Status.connected;
  //   // listen for messages, attempt to reconnect if connection is lost
  //   _websocket.stream.listen((message) {
  //     lastReceived = DateTime.now();
  //     // check if message is json
  //     try {
  //       final data = json.decode(message);
  //       // attempt to get timestamp in microseconds
  //       if (data.containsKey('timestamp') && data['timestamp'] is int) {
  //         final latency =
  //             DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(data['timestamp'])).inMicroseconds;
  //         telemetryStatus.addLatency(latency);
  //       } else {
  //         print('No valid timestamp found in message: $message');
  //         telemetryStatus.numErrors++;
  //       }
  //
  //       // update models (indiscriminately, since it doesn't matter if no relevant keys for a model exist)
  //       for (final model in carModels) {
  //         model.updateFromJson(data);
  //       }
  //     } catch (e) {
  //       // TODO need logging
  //       print('Error decoding message $e');
  //       print('Message: $message');
  //       telemetryStatus.numErrors++;
  //     }
  //   }, onDone: () {
  //     telemetryStatus.status = Status.disconnected;
  //     // TODO need logging
  //     print('Websocket connection closed (${_websocket.closeCode}, ${_websocket.closeReason})');
  //     if (_websocket.closeCode != 1000) {
  //       // TODO need logging
  //       print('Attempting to reconnect');
  //       _connect();
  //     }
  //   });
  // }

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

  ChangeNotifierProvider<TelemetryManager> get provider =>
      ChangeNotifierProvider.value(value: this);
}
