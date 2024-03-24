import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:uksc_dashboard/api/viss/models/response.dart';

class BaseModel extends ChangeNotifier {
  /// key value data pairs, keys should match what we expect to have to parse
  @protected
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
        if (data[newDatum.path].runtimeType == newDatum.latest.runtimeType) {
          data[newDatum.path] = newDatum.latest;
          updated = true;
        } else {
          try {
            dynamic parsedData;
            switch (data[newDatum.path].latest.runtimeType) {
              case int:
                parsedData = int.parse(newDatum.latest);
                break;
              case double:
                parsedData = double.parse(newDatum.latest);
                break;
              case bool:
                parsedData = newDatum.latest.toString().toLowerCase() == 'true';
                break;
              default:
                parsedData = newDatum.latest;
                break;
            }
            if (data[newDatum.path].runtimeType != parsedData.runtimeType) {
              log.severe(
                  'Type mismatch for ${newDatum.path}: ${data[newDatum.path]
                      .runtimeType} != ${parsedData.runtimeType}');
              throw Exception('Type mismatch');
            }
            data[newDatum.path] = parsedData;
            updated = true;
          } catch (e) {
            log.severe(
                'Failed to parse ${newDatum.latest} for ${newDatum.path}: $e');
          }
        }
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
