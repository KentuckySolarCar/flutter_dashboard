import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:uksc_dashboard/api/viss/models/response.dart';

class BaseModel extends ChangeNotifier {
  /// key value data pairs, keys should match what we expect to have to parse
  @visibleForTesting
  final Map<String, dynamic> data;

  late final Logger log;

  BaseModel(this.data) {
    log = Logger(runtimeType.toString());
  }

  /// The last time the data was updated
  var lastUpdated = DateTime.now();

  /// Updates the data from a json object, if possible.
  ///
  /// Notifies listener if data is changed. Must be able to handle keys not
  /// being present. Returns `true` if the data was updated, `false` otherwise.
  bool updateFromJson(Map<String, String> newData) {
    var updated = false;
    newData.forEach((key, value) {
      if (data.containsKey(key)) {
        if (data[key] != value) {
          data[key] = value;
          updated = true;
        }
      }
    });
    if (updated) {
      lastUpdated = DateTime.now();
      notifyListeners();
    }
    return updated;
  }

  /// Updates the data from a list of [Data] objects, if possible.
  ///
  /// Notifies listener if data is changed. Must be able to handle paths not
  /// being present. Returns `true` if the data was updated, `false` otherwise.
  bool updateFromData(List<Data> newData) {
    var updated = false;
    for (final newDatum in newData) {
      if (data.containsKey(newDatum.path)) {
        final expectedType = data[newDatum.path].runtimeType;
        final newDatumType = newDatum.latest.runtimeType;

        var newValue = newDatum.latest;
        // if the types don't match, attempt to parse
        if (expectedType != newDatumType) {
          dynamic parsedData;
          switch (expectedType) {
            case == int:
              parsedData = int.tryParse(newDatum.latest.toString());
              break;
            case == double:
              if (newDatumType == int) {
                parsedData = newDatum.latest.toDouble();
              } else {
                parsedData = double.tryParse(newDatum.latest.toString());
              }
              break;
            case == bool:
              parsedData = bool.tryParse(newDatum.latest.toString(),
                  caseSensitive: false);
              break;
            default:
              parsedData = newDatum.latest;
              break;
          }
          newValue = parsedData;
        }

        if (expectedType == newValue.runtimeType) {
          // yay types matched! we can now update this and move on :)
          data[newDatum.path] = newValue;
          updated = true;
          continue;
        }

        // if the types STILL don't match, well we tried.
        log.severe(
            'Type mismatch for ${newDatum.path}: Could not convert "${newDatum.latest}" of type "$newDatumType" to expected type "$expectedType"');
      }
    }

    if (updated) {
      lastUpdated = DateTime.now();
      notifyListeners();
    }
    return updated;
  }

  /// The provider for this model.
  ///
  /// Must be overridden by subclasses to ensure that the provider has the correct type.
  ChangeNotifierProvider<BaseModel> get provider =>
      ChangeNotifierProvider.value(value: this);

  Iterable<String> get nodes => data.keys;
}
