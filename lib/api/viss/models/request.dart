/// viss2-transport json def
/// {
//     "definitions": {
//         "action": {
//             "enum": [ "get", "set", "subscribe", "subscription", "unsubscribe"],
//             "description": "The type of action requested by the client and/or delivered by the server",
//         },
//         "path": {
//             "description": "The path to the desired vehicle signal(s). It may require synthesis with additional path data, see [[viss2-core]], Paths Filter Operation chapter.",
//             "type": "string"
//         },
//         "ts": {
//             "description": "The time of the issuance of the message. For its format, see [[viss2-core]], Timestamps chapter.",
//             "type": "string"
//         },
//         "filter": {
//             "description": "May be specified in order to throttle the demands of subscriptions on the server. See [[viss2-core]], Filter Request chapter.",
//             "type": "object/array",
//             "properties": {
//                 "type": {
//                     "description": "The different filter types.",
//                     "type": "string"
//                 },
//                 "parameter": {
//                     "description": "Parameter(s) for the different filter types",
//                     "type": "object/array",
//                 }
//             }
//         },
//         "data": {
//             "description": "Data including path(s) and one or more data point(s).",
//             "type": "object/array",
//             "properties": {
//                 "path": {
//                     "description": "The path to the vehicle signal.",
//                     "type": "string"
//                 },
//                 "dp": {
//                     "description": "Data point including one or more value and time samp",
//                     "type": "object/array",
//                     "properties": {
//                         "value": {
//                             "description": "The value related to the associated path.",
//                             "type": "string"
//                         },
//                         "ts": {
//                             "description": "Time of the value capture. For its format, see [[viss2-core]], Timestamps chapter.",
//                             "type": "string"
//                         }
//                     }
//                 }
//             }
//         },
//         "subscriptionId":{
//             "description": "Integer handle value which is used to uniquely identify a subscription session.",
//             "type": "string"
//         },
//         "metadata":{
//             "description": "Static or dynamic metadata.",
//             "type": "object"
//         },
//         "requestId": {
//             "description": "Returned by the server in the response and used by the client to link the request and response messages.",
//             "type": "string"
//         },
//         "error": {
//             "description": "Server response for error cases",
//             "type": "object",
//             "properties": {
//                 "number": {
//                     "description": "HTTP Status Code Number",
//                     "type": "integer"
//                 },
//                 "reason": {
//                     "description": "Pre-defined string value that can be used to distinguish between errors that have the same code",
//                     "type": "string"
//                 },
//                 "message": {
//                     "description": "Message text describing the cause in more detail",
//                     "type": "string"
//                 }
//             }
//         }
//     }
// }

// timestamp "ts" is in ISO8601 UTC format with trailing z.

import 'package:uuid/uuid.dart';
import 'package:uksc_dashboard/api/viss/models/filter.dart';

enum RequestAction {
  authorize,
  updateVSSTree,
  updateMetaData,
  getMetaData,
  set,
  get,
  subscribe,
  unsubscribe
}

/// Base class for all requests
abstract class Request {
  RequestAction action;
  String requestId = const Uuid().v4();
  String ts = DateTime.now().toUtc().toIso8601String();

  Request(this.action);

  Map<String, dynamic> toJson() {
    return {
      "action": action.name,
      "requestId": requestId,
      "ts": ts,
    };
  }
}

class AuthorizeRequest extends Request {
  String token;

  AuthorizeRequest(this.token) : super(RequestAction.authorize);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'token': token,
    };
  }
}

class UpdateVSSTreeRequest extends Request {
  Map<String, dynamic> vssTree;

  UpdateVSSTreeRequest(this.vssTree) : super(RequestAction.updateVSSTree);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'metadata': vssTree,
    };
  }
}

class UpdateMetaDataRequest extends Request {
  String path;
  Map<String, dynamic> metadata;

  UpdateMetaDataRequest(this.path, this.metadata)
      : super(RequestAction.updateMetaData);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'path': path,
      'metadata': metadata,
    };
  }
}

class GetMetaDataRequest extends Request {
  String path;

  GetMetaDataRequest(this.path) : super(RequestAction.getMetaData);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'path': path,
    };
  }
}

// reimplement the above using the base class
class SetValueRequest extends Request {
  String path;
  dynamic value;
  String attribute;

  SetValueRequest(this.path, this.value, {this.attribute = 'value'})
      : super(RequestAction.set);

  @override
  Map<String, dynamic> toJson() {
    var requestJson = {
      ...super.toJson(),
      'path': path,
      'attribute': attribute,
    };
    if (value is List) {
      requestJson[attribute] = [];
      for (var v in value) {
        requestJson[attribute].add(v);
      }
    } else {
      requestJson[attribute] = value;
    }
    return requestJson;
  }
}

// reimplement the above using the base class
class GetValueRequest extends Request {
  String path;
  String attribute;

  GetValueRequest(this.path, {this.attribute = 'value'})
      : super(RequestAction.get);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'path': path,
      'attribute': attribute,
    };
  }
}

class SubscribeRequest extends Request {
  String path;
  String attribute;
  Filter? filter;

  SubscribeRequest(this.path, {this.attribute = 'value', this.filter})
      : super(RequestAction.subscribe);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'path': path,
      'attribute': attribute,
      if (filter != null) 'filter': filter!.toJson(),
    };
  }
}

class UnsubscribeRequest extends Request {
  String subscriptionId;

  UnsubscribeRequest(this.subscriptionId) : super(RequestAction.unsubscribe);

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'subscriptionId': subscriptionId,
    };
  }
}
