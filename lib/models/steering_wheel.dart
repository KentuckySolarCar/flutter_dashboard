import 'package:uksc_dashboard/models/generic.dart';

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
      : super({for (var name in _buttonNames) 'button_${name}_short': 0}
          ..addAll({for (var name in _buttonNames) 'button_${name}_long': 0})) {
    for (var name in _buttonNames) {
      _buttons[name] = Button(name, data['button_${name}_long'], data['button_${name}_short']);
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

  /// Updates the data from a json object, if possible.
  ///
  /// Notifies listener if data is changed. Must be able to handle keys not being present.
  /// Returns true if the data was updated, false otherwise.
  @override
  bool updateFromJson(Map<String, dynamic> newData) {
    // set all current values to 0
    for (var name in _buttonNames) {
      data['button_${name}_short'] = 0;
      data['button_${name}_long'] = 0;
    }

    var updated = false;
    newData.forEach((key, value) {
      if (data.containsKey(key)) {
        if (data[key] != value) {
          data[key] = value;
          updated = true;
        }
      }
    });
    if (updated) {
      lastUpdated = DateTime.now();
      for (var name in _buttonNames) {
        _buttons[name] = Button(name, data['button_${name}_long'], data['button_${name}_short']);
      }
      notifyListeners();
    }
    return updated;
  }
}
