import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/generic.dart';

class Battery extends BaseModel {
  Battery() : super({'currentCurrent': 0.0});

  /// The current current flowing in/out
  ///
  /// Positive = current flowing in, negative = current flowing out
  double get current => data['currentCurrent']!;

  @override
  ChangeNotifierProvider<Battery> get provider =>
      ChangeNotifierProvider.value(value: this);
}
