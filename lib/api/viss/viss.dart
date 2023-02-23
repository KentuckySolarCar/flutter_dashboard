import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import 'package:uuid/uuid.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:uksc_dashboard/api/viss/models/request.dart';
import 'package:uksc_dashboard/api/viss/models/response.dart';

/// VISS (Vehicle Information Service Specification) websocket API version 2.0
class VissApi {
  /// The address pointing to the websocket host
  Uri uri;

  /// The time a message was last received at
  var lastReceived = DateTime.now();

  late WebSocketChannel _websocket;

  final StreamController receiveStream = StreamController.broadcast();

  VissApi(this.uri) {
    // TODO this needs error handling (and probably shouldn't connect in constructor)
    _websocket = WebSocketChannel.connect(uri);
    receiveStream.addStream(_websocket.stream);
  }

  Future<Response> _receiveResponse(String requestId) async {
    // wait for a websocket message that contains a "requestId" in JSON that matches the one we sent, then return that
    await for (var message in _websocket.stream) {
      lastReceived = DateTime.now();
      var json = jsonDecode(message);
      if (json['requestId'] == requestId) {
        return json;
      }
    }
    // if we get here, we didn't receive a response
    throw Exception('No response received');
  }
 
  Future<Response> makeRequest(Request request) async {
    var response = _receiveResponse(request.requestId);
    _websocket.sink.add(jsonEncode(request.toJson()));
    return response;
  }

  void stop() {
    _websocket.sink.close();
  }

  /// Do authorization by passing a jwt token or a token file
  void authorize(String token, {int timeout = 5}) async {
    // TODO
  }

  /// Update VSS Tree Entry
  void updateVSSTree(Map<String, dynamic> json, {int timeout = 5}) async {
    // TODO
  }

  /// Update metadata for a given path
  void updateMetaData(String path, Map<String, dynamic> json,
      {int timeout = 5}) async {
    // TODO
  }

  /// Set value of a given path
  Future<Response> setValue(SetValueRequest setRequest, {int timeout = 5}) async {
    // TODO
  }

  /// Get value from a given path
  Future<Map<String, dynamic>> getValue(String path,
      {String attribute = 'value', int timeout = 5}) async {
    // TODO
  }

  /// Returns a subscription id
  Future<String> subscribe(String path, Function(Map<String, dynamic>) callback,
      {String attribute = 'value', int timeout = 5}) {
    // TODO
  }

  /// Unsubscribe from value changes for a given path
  Future<void> unsubscribe(String subscriptionId, {int timeout = 5}) async {
    // TODO
  }
}
