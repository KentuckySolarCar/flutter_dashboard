import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

class Battery extends BaseModel {
  // keys should match what we expect to have to parse
  Battery()
      : super({
          'Vehicle.Powertrain.TractionBattery.StateOfCharge.PackSOC': '0',
        });

  double get stateOfCharge => double.parse(data['Vehicle.Powertrain.TractionBattery.StateOfCharge.PackSOC']);

 @override
  ChangeNotifierProvider<Battery> get provider =>
      ChangeNotifierProvider.value(value: this);
}