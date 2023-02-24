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

  final Map<String, Function(Map<String, dynamic>)> _subscriptionCallbacks =
      HashMap();

  VissApi(this.uri) {
    // TODO this needs error handling (and probably shouldn't connect in constructor)
    _websocket = WebSocketChannel.connect(uri);
    receiveStream.addStream(_websocket.stream);
  }

  // this is a very lazy way of implementing this, every listener will have
  // to decode the JSON of every message. Can be improved if needed later.
  Future<Response> _receiveResponse(String requestId) async {
    // wait for a websocket message that contains a "requestId" in JSON that matches the one we sent, then return that
    await for (var message in _websocket.stream) {
      lastReceived = DateTime.now();
      var json = jsonDecode(message);
      if (json['requestId'] == requestId) {
        return Response.fromJson(json);
      }
    }
    // if we get here, we didn't receive a response
    throw Exception('No response received');
  }

  Future<Response> makeRequest(Request request) {
    var response = _receiveResponse(request.requestId);
    _websocket.sink.add(jsonEncode(request.toJson()));
    if (request is SubscribeRequest || request is UnsubscribeRequest) {
      // TODO handle this appropriately
    }
    return response;
  }

  void stop() {
    _websocket.sink.close();
  }

  // TODO
  // - listener that just calls callbacks for subscriptionIds
  // - thing that finds lowest shared VSS node
  // subscribe convenience method

  Future<Response> subscribe(
      SubscribeRequest request, Function(Map<String, dynamic>) callback) async {
    Response response = await makeRequest(request);
    // check if subscriptionResponse
    if (response is SubscriptionResponse) {
      _subscriptionCallbacks[response.subscriptionId] = callback;
    }
    return response;
  }

  Future<Response> unsubscribe(UnsubscribeRequest request) async {
    Response response = await makeRequest(request);
    // check if not ErrorResponse
    if (response is! ErrorResponse) {
      _subscriptionCallbacks.remove(request.subscriptionId);
    }
    return response;
  }

  // util method to find the lowest shared VSS node from a list of VSS paths
  static String findBestSharedNode(List<String> paths) {
    // where paths might be something like:
    // [
    //   'Vehicle.Drivetrain.FuelSystem.Level',
    //   'Vehicle.Drivetrain.FuelSystem.Tank',
    //   'Vehicle.Drivetrain.FuelSystem.Tank.Capacity',
    // ]
    // we want to return 'Vehicle.Drivetrain.FuelSystem'

    // create a map of nodes and ints
    Map<String, int> nodeFrequency = HashMap();
    for (var path in paths) {
      var nodes = path.split('.');
      // generate every possible node from the path
      for (var i = 0; i < nodes.length; i++) {
        var node = nodes.sublist(0, i + 1).join('.');
        if (nodeFrequency.containsKey(node)) {
          nodeFrequency[node] = nodeFrequency[node]! + 1;
        } else {
          nodeFrequency[node] = 1;
        }
      }
    }

    // the best node is the longest one with frequency equal to the number of paths
    var bestNode = '';
    for (var node in nodeFrequency.keys) {
      if (nodeFrequency[node] == paths.length &&
          node.length > bestNode.length) {
        bestNode = node;
      }
    }
    return bestNode;
  }
}
