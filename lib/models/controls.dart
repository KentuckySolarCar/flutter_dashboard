import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';

class Button {
  /// The name of this button.
  final String name;

  /// The number of times the button has been long pressed.
  final int longPresses;

  /// The number of times the button has been short pressed.
  final int shortPresses;

  Button(this.name, this.longPresses, this.shortPresses);
}

const _buttonNames = [
  'x',
  'y',
  'a',
  'b',
  'l',
  'r',
  'right_turn',
  'left_turn',
  'cruise_main',
  'cruise_plus',
  'cruise_minus'
];

class SteeringWheel extends BaseModel {
  late Map<String, Button> _buttons;

  // map each buttonName to button_name_short and button_name_long for super call
  SteeringWheel()
      : super({for (var name in _buttonNames) 'button_${name}_short': 0.toString()}
          ..addAll({for (var name in _buttonNames) 'button_${name}_long': 0.toString()})) {
    for (var name in _buttonNames) {
      _buttons[name] = Button(name, int.parse(data['button_${name}_long']!), int.parse(data['button_${name}_short']!));
    }
  }

  Button get buttonX => _buttons['x']!;

  Button get buttonY => _buttons['y']!;

  Button get buttonA => _buttons['a']!;

  Button get buttonB => _buttons['b']!;

  Button get buttonL => _buttons['l']!;

  Button get buttonR => _buttons['r']!;

  Button get buttonRightTurn => _buttons['right_turn']!;

  Button get buttonLeftTurn => _buttons['left_turn']!;

  Button get buttonCruiseMain => _buttons['cruise_main']!;

  Button get buttonCruisePlus => _buttons['cruise_plus']!;

  Button get buttonCruiseMinus => _buttons['cruise_minus']!;
}

class Pedals extends BaseModel {
  Pedals()
    :
      super({'Vehicle.Chassis.Accelerator.PedalPosition' : '0.0'});

    double get throttlePercentage => double.parse(data['Vehicle.Chassis.Accelerator.PedalPosition']);

  @override
  ChangeNotifierProvider<Pedals> get provider =>
      ChangeNotifierProvider.value(value: this);
}
