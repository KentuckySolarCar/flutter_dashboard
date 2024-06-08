import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';
// Provider for all signals related to time.
class Timing extends BaseModel {

  Timing()
      : super({
          'Vehicle.CurrentLocation.LapTime' : '0',
          'Vehicle.CurrentLocation.Timestamp' : '0',
        });

  double get lapTime => double.parse(data['Vehicle.CurrentLocation.LapTime']);
  double get unixTime => double.parse(data['Vehicle.CurrentLocation.Timestamp']);


 @override
  ChangeNotifierProvider<Timing> get provider =>
      ChangeNotifierProvider.value(value: this);
}