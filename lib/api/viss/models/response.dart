import 'package:uksc_dashboard/api/viss/models/request.dart';

class DataPoint {
  DateTime timestamp;
  String value;

  DataPoint(this.timestamp, this.value);

  static DataPoint fromJson(Map<String, dynamic> json) {
    return DataPoint(DateTime.parse(json['ts']), json['value']);
  }
}

class Data {
  List<DataPoint> dataPoints;
  String path;

  Data(this.path, this.dataPoints);

  static Data fromJson(Map<String, dynamic> json) {
    var dataPoints = <DataPoint>[];
    if (json['dp'] is List) {
      for (var dp in json['dp']) {
        dataPoints.add(DataPoint.fromJson(dp));
      }
    } else {
      dataPoints.add(DataPoint.fromJson(json['dp']));
    }
    return Data(json['path'], dataPoints);
  }
}

class Error {
  int number;
  String reason;
  String message;

  Error(this.number, this.reason, this.message);

  static Error fromJson(Map<String, dynamic> json) {
    return Error(json['number'], json['reason'], json['message']);
  }

  @override
  String toString() {
    return 'Error{number: $number, reason: $reason, message: $message}';
  }
}

class Response {
  String requestId;
  Action action;
  DateTime timestamp;

  Response(this.requestId, this.action, this.timestamp);

  static Response fromJson(Map<String, dynamic> json) {
    var action = Action.values.firstWhere((e) => e.name == json['action']);
    var requestId = json['requestId'];
    // json may not have 'ts'
    var timestamp = json['ts'] != null
        ? DateTime.parse(json['ts'])
        : DateTime.now().toUtc();

    if (json.containsKey('error')) {
      return ErrorResponse(
          requestId, action, timestamp, Error.fromJson(json['error']));
    } else if (json.containsKey('data')) {
      var data = <Data>[];
      if (json['data'] is List) {
        for (var d in json['data']) {
          data.add(Data.fromJson(d));
        }
      } else {
        data.add(Data.fromJson(json['data']));
      }
      return DataResponse(requestId, action, timestamp, data);
    } else if (json.containsKey('subscriptionId')) {
      return SubscriptionResponse(
          requestId, action, timestamp, json['subscriptionId']);
    } else {
      return Response(requestId, action, timestamp);
    }
  }
}

class ErrorResponse extends Response {
  Error error;

  ErrorResponse(String requestId, Action action, DateTime timestamp, this.error)
      : super(requestId, action, timestamp);

  // fromJson, use the super fromJson and then set the error

  @override
  String toString() {
    return 'ErrorResponse{error: $error}';
  }
}

class DataResponse extends Response {
  List<Data> data;

  DataResponse(String requestId, Action action, DateTime timestamp, this.data)
      : super(requestId, action, timestamp);

  // fromJson, use the super fromJson and then set the data

  @override
  String toString() {
    return 'DataResponse{data: $data}';
  }
}

class SubscriptionResponse extends Response {
  String subscriptionId;

  SubscriptionResponse(
      String requestId, Action action, DateTime timestamp, this.subscriptionId)
      : super(requestId, action, timestamp);

  // fromJson, use the super fromJson and then set the path and subscriptionId

  @override
  String toString() {
    return 'SubscriptionResponse{subscriptionId: $subscriptionId}';
  }
}
