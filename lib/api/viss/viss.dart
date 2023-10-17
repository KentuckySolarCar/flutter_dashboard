import 'dart:collection';
import 'dart:convert';
import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:uksc_dashboard/api/viss/models/request.dart';
import 'package:uksc_dashboard/api/viss/models/response.dart';

/// VISS (Vehicle Information Service Specification) websocket API version 1.0
class VissApi {
  /// The address pointing to the websocket host
  Uri uri;

  /// The time a message was last received at
  DateTime lastReceived = DateTime.now();

  late WebSocketChannel _websocket;

  final Map<String, Function(SubscriptionDataResponse)> subscriptionCallbacks =
      HashMap();

  final Map<String, StreamController<Response>> _responseStreams = HashMap();

  final Function(Response)? onResponse;
  final Function(Request)? onRequest;
  final Function(Object)? onError;
  final Function()? onDisconnect;

  VissApi(this.uri,
      {this.onRequest, this.onResponse, this.onError, this.onDisconnect});

  /// Connect to the VISS websocket server and start listening for messages.
  void connect() {
    _websocket = WebSocketChannel.connect(uri);
    _websocket.stream.listen(_receiveListener, onError: (error, stackTrace) {
      print('Error: $error Stacktrace: $stackTrace');
      onError?.call(error);
    }, onDone: () {
      print('Done');
      onDisconnect?.call();
    });
  }

  /// The listener for the websocket stream.
  void _receiveListener(dynamic message) {
    print('Received message: $message');
    Map<String, dynamic> json = jsonDecode(message);
    print('Decoded message: $json');
    if (json.containsKey('requestId') || json.containsKey('subscriptionId')) {
      lastReceived = DateTime.now();
      var response = Response.fromJson(json);

      if (response is SubscriptionDataResponse) {
        print('Received subscription data for ${response.subscriptionId}');
        if (subscriptionCallbacks.containsKey(response.subscriptionId)) {
          print('Calling subscription callback for ${response.subscriptionId}');
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
      // TODO log something (maybe throw an exception?). All responses should have a requestId
      print('Received message without requestId or subscriptionId: $message');
    }
  }

  /// Wait for a response from the VISS websocket server.
  ///
  /// Used internally by [makeRequest] and [subscribe].
  Future<Response> _receiveResponse(String requestId) async {
    if (_responseStreams.containsKey(requestId)) {
      // this is an error, but luckily should never happen
      throw Exception('Request ID already exists');
    }

    print('init new stream');
    // init new stream we will listen to after it is inserted into the map
    StreamController<Response> responseStreamController = StreamController();
    _responseStreams[requestId] = responseStreamController;

    print('awaiting response');
    // await response from stream, then return
    return responseStreamController.stream.first;
  }

  /// Perform a request.
  Future<Response> makeRequest(Request request) async {
    print('Making request: ${request.toJson()}');
    onRequest?.call(request);
    var response = _receiveResponse(request.requestId);
    _websocket.sink.add(jsonEncode(request.toJson()));
    if (request is SubscribeRequest || request is UnsubscribeRequest) {
      // TODO log warning, should use subscribe() or unsubscribe() instead to ensure subscription callbacks are handled
      print(
          'Warning: subscribe/unsubscribe request made without using subscribe/unsubscribe methods');
    }
    onResponse?.call(await response);
    return response;
  }

  void stop() {
    _websocket.sink.close();
  }

  /// Perform a subscription request.
  ///
  /// Returns a [SubscriptionResponse] if successful, or an [ErrorResponse] if not.
  Future<Response> subscribe(SubscribeRequest request,
      Function(SubscriptionDataResponse) callback) async {
    print('Making subscription request');
    Response response = await makeRequest(request);
    assert(response is ErrorResponse || response is SubscriptionResponse);
    // check if subscriptionResponse
    print('Adding subscription callback for ${response}');
    if (response is SubscriptionResponse) {
      print('Adding subscription callback for ${response.subscriptionId}');
      subscriptionCallbacks[response.subscriptionId] = callback;
    }
    return response;
  }

  /// Perform an unsubscription request.
  ///
  /// Returns a [SubscriptionResponse] if successful, or an [ErrorResponse] if not.
  Future<Response> unsubscribe(UnsubscribeRequest request) async {
    Response response = await makeRequest(request);
    assert(response is ErrorResponse || response is SubscriptionResponse);

    // check if not ErrorResponse
    if (response is! ErrorResponse) {
      subscriptionCallbacks.remove(request.subscriptionId);
    }
    return response;
  }

  /// Find the best shared VSS node from a list of VSS [paths].
  ///
  /// For example, given the following paths:
  /// ```
  ///  Vehicle.Drivetrain.FuelSystem.Level,
  ///  Vehicle.Drivetrain.FuelSystem.Tank,
  ///  Vehicle.Drivetrain.FuelSystem.Tank.Capacity
  /// ```
  ///
  /// The best shared node is `Vehicle.Drivetrain.FuelSystem`.
  static String findBestSharedNode(Iterable<String> paths) {
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
