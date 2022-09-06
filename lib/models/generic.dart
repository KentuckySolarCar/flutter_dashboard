import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseModel extends ChangeNotifier {
  /// key value data pairs, keys should match what we expect to have to parse
  final Map<String, dynamic> data;

  BaseModel(this.data);

  /// The last time the data was updated
  var lastUpdated = DateTime.now();

  /// Updates the data from a json object, if possible.
  ///
  /// Notifies listener if data is changed. Must be able to handle keys not being present.
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

  /// The provider for this model.
  // Must be overridden by subclasses to ensure that the provider has the correct type.
  ChangeNotifierProvider<BaseModel> get provider => ChangeNotifierProvider.value(value: this);
}
