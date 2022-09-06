import 'package:flutter/foundation.dart';

class BaseModel extends ChangeNotifier {
  /// key value data pairs, keys should match what we expect to have to parse
  final Map<String, dynamic> data;

  BaseModel(this.data);

  /// The last time the data was updated
  var lastUpdated = DateTime.now();

  /// updates the data from a json object, if possible.
  ///
  /// Notifies listener if data is changed. Must be able to handle any data not being present.
  /// Returns true if the data was updated, false otherwise.
  bool updateFromJson(Map<String, dynamic> newData) {
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
}
