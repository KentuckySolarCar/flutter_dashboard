import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/generic.dart';

enum DriveMode { forward, reverse }

class CarStatus extends BaseModel {
  CarStatus()
      : super({
          'array_status': 0,
          'drive_mode': 0,
          'regen_status': 0,
          'wheel_pedal': 0,
          'throttle': 0.0,
        });

  bool get isArrayEnabled => data['array_status'] == 1;

  bool get isRegenEnabled => data['regen_status'] == 1;

  DriveMode get driveMode => data['drive_mode'] == 1 ? DriveMode.forward : DriveMode.reverse;

  bool get triggerControlEnabled => data['wheel_pedal'] == 0;

  double get throttle => data['throttle'] * 100;

  @override
  ChangeNotifierProvider<CarStatus> get provider => ChangeNotifierProvider.value(value: this);
}

class CarTime extends BaseModel {
  CarTime() : super({'time': 0, 'last_bottom_shell_power_cycle': 0, 'lap_time': 0});

  DateTime get time => DateTime.fromMillisecondsSinceEpoch(data['time']);

  Duration get bottomShellPowerCycle => Duration(milliseconds: data['last_bottom_shell_power_cycle']);

  Duration get lapTime => Duration(milliseconds: data['lap_time']);

  @override
  ChangeNotifierProvider<CarTime> get provider => ChangeNotifierProvider.value(value: this);
}
