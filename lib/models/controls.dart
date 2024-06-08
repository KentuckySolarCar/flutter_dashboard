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
  'Button_X',
  'Button_Y',
  'Button_A',
  'Button_B',
  'Button_L',
  'Button_R',
  'Right_Turn',
  'Left_Turn',
  'Cruise_Main',
  'Cruise_Plus',
  'Cruise_Minus'
];

class SteeringWheel extends BaseModel {
  late final Map<String, Button> _buttons = {};

  //Map each buttonName to button_name_short and button_name_long for super call
  SteeringWheel()
      : super({for (var name in _buttonNames) '${name}_Short_Press_Count': 0.toString()}
          ..addAll({for (var name in _buttonNames) '${name}_Long_Press_Count': 0.toString()})) {
    for (var name in _buttonNames) {
      _buttons[name] = Button(name, int.parse(data['${name}_Long_Press_Count']!), int.parse(data['${name}_Short_Press_Count']!));
    }
  }
  //Defining button data members
  Button get buttonX => _buttons['Button_X']!;

  Button get buttonY => _buttons['Button_Y']!;

  Button get buttonA => _buttons['Button_A']!;

  Button get buttonB => _buttons['Button_B']!;

  Button get buttonL => _buttons['Button_L']!; //Laptime reset

  Button get buttonR => _buttons['Button_R']!;

  Button get buttonRightTurn => _buttons['Right_Turn']!;

  Button get buttonLeftTurn => _buttons['Left_Turn']!;

  Button get buttonCruiseMain => _buttons['Cruise_Main']!;

  Button get buttonCruisePlus => _buttons['Cruise_Plus']!;

  Button get buttonCruiseMinus => _buttons['Cruise_Minus']!;

  //Button get buttonLeftTurn => Button('Left_Turn', 1, 3);

  @override
  ChangeNotifierProvider<SteeringWheel> get provider =>
      ChangeNotifierProvider.value(value: this);
}


class Pedals extends BaseModel {
  //Pedals get their own provider because there may be a throttle and brake pedal
  Pedals()
    : super({'Vehicle.Chassis.Accelerator.PedalPosition' : '0.0'});

    double get throttlePercentage => double.parse(data['Vehicle.Chassis.Accelerator.PedalPosition']);

  @override
  ChangeNotifierProvider<Pedals> get provider =>
      ChangeNotifierProvider.value(value: this);
}

