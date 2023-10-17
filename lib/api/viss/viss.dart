import 'dart:collection';
import 'dart:convert';
import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logging/logging.dart';

import 'package:uksc_dashboard/api/viss/models/request.dart';
import 'package:uksc_dashboard/api/viss/models/response.dart';

/// VISS (Vehicle Information Service Specification) websocket API version 1.0
class VissApi {
  /// The address pointing to the websocket host
  Uri uri;

  late WebSocketChannel _websocket;

  final _log = Logger('viss');

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
      _log.severe('Error: $error Stacktrace: $stackTrace');
      onError?.call(error);
    }, onDone: () {
      _log.info('Disconnected from VISS server at $uri');
      onDisconnect?.call();
    });
  }

  /// The listener for the websocket stream.
  void _receiveListener(dynamic message) {
    _log.finest('Received message: $message');
    Map<String, dynamic> json = jsonDecode(message);
    _log.finer('Decoded message: $json');
    if (json.containsKey('requestId') || json.containsKey('subscriptionId')) {
      final response = Response.fromJson(json);
      if (response is SubscriptionDataResponse) {
        _log.fine('Received subscription data for ${response.subscriptionId}');
        if (subscriptionCallbacks.containsKey(response.subscriptionId)) {
          _log.finest(
              'Calling subscription callback for ${response.subscriptionId}');
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
      // All VISS messages should have a requestId or subscriptionId
      _log.warning(
          'Received message without requestId or subscriptionId: $message');
      // TODO should we throw here? If so, is Exception the right type?
      // throw Exception('Received message without requestId or subscriptionId');
      // we could call onError here?
    }
  }

  /// Wait for a response from the VISS websocket server.
  ///
  /// Used internally by [makeRequest] and [subscribe].
  Future<Response> _receiveResponse(String requestId) {
    if (_responseStreams.containsKey(requestId)) {
      // this is an error, but luckily should never happen
      throw Exception('Request ID already exists');
    }
    // init new stream we will listen to after it is inserted into the map
    StreamController<Response> responseStreamController = StreamController();
    _responseStreams[requestId] = responseStreamController;
    _log.finer('Created new response stream for $requestId');
    return responseStreamController.stream.first;
  }

  /// Perform a request.
  Future<Response> makeRequest(Request request,
      {willWarnOnSubscribe = true}) async {
    _log.fine('Making ${request.action.name} request');
    _log.finest('Request: $request');
    onRequest?.call(request);
    final response = _receiveResponse(request.requestId);
    _websocket.sink.add(jsonEncode(request.toJson()));
    if (willWarnOnSubscribe &&
        (request is SubscribeRequest || request is UnsubscribeRequest)) {
      _log.warning('Subscribe/unsubscribe request made without using '
          'subscribe/unsubscribe methods. You must manually handle subscription callbacks!');
    }
    _log.finer('Response received for ${request.requestId}: ${await response}');
    onResponse?.call(await response);
    return response;
  }

  void stop() {
    _log.info('Stopping VISS API');
    _websocket.sink.close();
  }

  /// Perform a subscription request.
  ///
  /// Returns a [SubscriptionResponse] if successful, or an [ErrorResponse] if not.
  Future<Response> subscribe(SubscribeRequest request,
      Function(SubscriptionDataResponse) callback) async {
    _log.fine('Making subscription request for ${request.path}');
    _log.finest('SubscriptionRequest: $request');
    Response response = await makeRequest(request);

    if (response is ErrorResponse) {
      _log.severe('Failed to subscribe to ${request.path}: $response');
      onError?.call(response);
    } else if (response is SubscriptionResponse) {
      _log.fine('Subscribed to ${request.path}');
      _log.finer('Adding subscription callback for ${response.subscriptionId}');
      subscriptionCallbacks[response.subscriptionId] = callback;
    } else {
      _log.severe('Received unexpected response: $response');
      // TODO what should we do here?
    }
    return response;
  }

  /// Perform an unsubscription request.
  ///
  /// Returns a [SubscriptionResponse] if successful, or an [ErrorResponse] if not.
  Future<Response> unsubscribe(UnsubscribeRequest request) async {
    _log.fine('Making unsubscription request for ${request.subscriptionId}');
    _log.finest('UnsubscribeRequest: $request');
    Response response = await makeRequest(request);

    if (response is ErrorResponse) {
      _log.severe(
          'Failed to unsubscribe from ${request.subscriptionId}: $response');
      onError?.call(response);
    } else {
      _log.fine('Unsubscribed from ${request.subscriptionId}');
      _log.finer(
          'Removing subscription callback for ${request.subscriptionId}');
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
    for (final path in paths) {
      final nodes = path.split('.');
      // generate every possible node from the path
      for (int i = 0; i < nodes.length; i++) {
        final node = nodes.sublist(0, i + 1).join('.');
        if (nodeFrequency.containsKey(node)) {
          nodeFrequency[node] = nodeFrequency[node]! + 1;
        } else {
          nodeFrequency[node] = 1;
        }
      }
    }

    // the best node is the longest one with frequency equal to the number of paths
    String bestNode = '';
    for (final node in nodeFrequency.keys) {
      if (nodeFrequency[node] == paths.length &&
          node.length > bestNode.length) {
        bestNode = node;
      }
    }
    return bestNode;
  }
}
