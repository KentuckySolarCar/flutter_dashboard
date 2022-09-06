import 'package:uksc_dashboard/models/base.dart';

class _Motor extends BaseModel {
  // keys should match what we expect to have to parse
  _Motor()
      : super({
          'motorCurrent': 0.0,
          'motorPower': 0.0,
          'motorVelocityRpm': 0.0,
          'motorVelocityMs': 0.0,
          'motorAngularVelocity': 0.0,
          'busCurrent': 0.0,
          'busVoltage': 0.0,
          'phaseCCurrent': 0.0,
          'phaseBCurrent': 0.0,
          'voltageVectorReal': 0.0,
          'voltageVectorImaginary': 0.0,
          'currentVectorReal': 0.0,
          'currentVectorImaginary': 0.0,
          'backEmfD': 0.0,
          'backEmfQ': 0.0,
          'rail15v': 0.0,
          'rail3v3': 0.0,
          'rail1v9': 0.0,
          'ipmTemperature': 0.0,
          'motorTemperature': 0.0,
          'dspBoardTemperature': 0.0,
          'dcBusAmpHours': 0.0,
          'odometer': 0.0,
          'slipSpeed': 0.0
        });

  // getter methods for each value in _data
  /// percentage of maximum
  double get motorCurrent => data['motorCurrent']!;

  /// percentage of maximum
  double get motorPower => data['motorPower']!;

  double get motorVelocityRpm => data['motorVelocityRpm']!;

  double get motorVelocityMs => data['motorVelocityMs']!;

  double get motorAngularVelocity => data['motorAngularVelocity']!;

  double get busCurrent => data['busCurrent']!;

  double get busVoltage => data['busVoltage']!;

  double get phaseCCurrent => data['phaseCCurrent']!;

  double get phaseBCurrent => data['phaseBCurrent']!;

  double get voltageVectorReal => data['voltageVectorReal']!;

  double get voltageVectorImaginary => data['voltageVectorImaginary']!;

  double get currentVectorReal => data['currentVectorReal']!;

  double get currentVectorImaginary => data['currentVectorImaginary']!;

  double get backEmfD => data['backEmfD']!;

  double get backEmfQ => data['backEmfQ']!;

  double get rail15v => data['rail15v']!;

  double get rail3v3 => data['rail3v3']!;

  double get rail1v9 => data['rail1v9']!;

  /// celsius
  double get ipmTemperature => data['ipmTemperature']!;

  /// celsius
  double get motorTemperature => data['motorTemperature']!;

  /// celsius
  double get dspBoardTemperature => data['dspBoardTemperature']!;

  double get dcBusAmpHours => data['dcBusAmpHours']!;

  double get odometer => data['odometer']!;

  /// hz
  double get slipSpeed => data['slipSpeed']!;
}

// create classes for both motors so we can have separate providers
class LeftMotor extends _Motor {}

class RightMotor extends _Motor {}
