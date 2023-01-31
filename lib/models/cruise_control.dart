import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/generic.dart';

class CruiseControl extends BaseModel {
  CruiseControl() : super({'set_point': 0.0, 'active': false, 'main': false});

  /// The set point in mph
  double get setPoint => data['set_point']!;

  /// Whether cruise control is actively in control of modulating speed
  bool get active => data['active']!;

  /// Whether cruise control is on (not set, inactive, not in control)
  bool get enabled => data['main']!;

  @override
  ChangeNotifierProvider<CruiseControl> get provider =>
      ChangeNotifierProvider.value(value: this);
}
