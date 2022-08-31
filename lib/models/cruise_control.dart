import 'package:flutter/foundation.dart';

class CruiseControl extends ChangeNotifier {
  double _setPoint = 0;
  bool _active = false;
  bool _main = false;

  /// The set point in mph
  double get setPoint => _setPoint;

  set setPoint(double setPoint) {
    _setPoint = setPoint;
    notifyListeners();
  }

  /// Whether cruise control is actively in control of modulating speed
  bool get active => _active;
  set active(bool active) {
    _active = active;
    notifyListeners();
  }

  /// Whether cruise control is on (not set, inactive, not in control)
  bool get main => _main;
  set main(bool main) {
    _main = main;
    notifyListeners();
  }
}
