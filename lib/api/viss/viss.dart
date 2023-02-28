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

  final Map<String, Function(SubscriptionDataResponse)> subscriptionCallbacks =
      HashMap();

  final Map<String, StreamController<Response>> _responseStreams = HashMap();

  VissApi(this.uri);

  void connect() {
    _websocket = WebSocketChannel.connect(uri);
    _websocket.stream.listen(_receiveListener);
  }

  void _receiveListener(dynamic message) {
    var json = jsonDecode(message);
    if (json['requestId'] != null) {
      var response = Response.fromJson(json);

      if (response is SubscriptionDataResponse) {
        if (subscriptionCallbacks.containsKey(response.subscriptionId)) {
          subscriptionCallbacks[response.subscriptionId]!(response);
        }
      } else {
        if (_responseStreams.containsKey(response.requestId)) {
          _responseStreams[response.requestId]!.add(response);
          // close stream
          _responseStreams[response.requestId]!.close();
        }
      }
    } else {
      // TODO handle this
    }
  }

  // this is a very lazy way of implementing this, every listener will have
  // to decode the JSON of every message. Can be improved if needed later.
  Future<Response> _receiveResponse(String requestId) async {
    if (_responseStreams.containsKey(requestId)) {
      // this is an error, but luckily should never happen
      throw Exception('Request ID already exists');
    }

    // init new stream we will listen to after it is inserted into the map
    StreamController<Response> responseStreamController = StreamController();

    // await response from stream, then return
    return responseStreamController.stream.first;
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

  Future<Response> subscribe(SubscribeRequest request,
      Function(SubscriptionDataResponse) callback) async {
    Response response = await makeRequest(request);
    // check if subscriptionResponse
    if (response is SubscriptionResponse) {
      subscriptionCallbacks[response.subscriptionId] = callback;
    }
    return response;
  }

  Future<Response> unsubscribe(UnsubscribeRequest request) async {
    Response response = await makeRequest(request);
    // check if not ErrorResponse
    if (response is! ErrorResponse) {
      subscriptionCallbacks.remove(request.subscriptionId);
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
