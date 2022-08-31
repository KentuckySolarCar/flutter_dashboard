import 'package:flutter/foundation.dart';

class SpeedModel extends ChangeNotifier {
  double _speed = 0; // mph

  /// The speed of the car in mph.
  double get speed => _speed;

  set speed(double speed) {
    _speed = speed;
    notifyListeners();
  }

  /// The speed of the car in km/h.
  double get kmh => _speed * 1.60934;

  /// The speed of the car in m/s.
  double get ms => _speed * 0.44704;
}
