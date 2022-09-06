import 'package:uksc_dashboard/models/generic.dart';

class Speed extends BaseModel {
  Speed() : super({'speed': 0.0});

  /// The speed of the car in mph.
  double get mph => data['speed']!;

  /// The speed of the car in km/h.
  double get kmh => data['speed']! * 1.60934;

  /// The speed of the car in m/s.
  double get ms => data['speed']! * 0.44704;
}
