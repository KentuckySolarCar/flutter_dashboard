import 'package:flutter/foundation.dart';

class _Motor with ChangeNotifier {
  double _motorCurrent = 0.0; // percent
  double _motorPower = 0.0; // percent

  double _motorVelocityRpm = 0.0; // rpm
  double _motorVelocityMs = 0.0; // m/s
  double _motorAngularVelocity = 0.0; // rpm

  double _busCurrent = 0.0; // amps
  double _busVoltage = 0.0; // volts

  double _phaseCCurrent = 0.0;
  double _phaseBCurrent = 0.0;

  double _voltageVectorReal = 0.0;
  double _voltageVectorImaginary = 0.0;

  double _currentVectorReal = 0.0;
  double _currentVectorImaginary = 0.0;

  double _backEmfD = 0.0;
  double _backEmfQ = 0.0;

  double _rail15v = 0.0;
  double _rail3v3 = 0.0;
  double _rail1v9 = 0.0;

  double _ipmTemperature = 0.0; // celsius
  double _motorTemperature = 0.0; // celsius
  double _dspBoardTemperature = 0.0; // celsius

  double _dcBusAmpHours = 0.0; // amp hours
  double _odometer = 0.0; // meters
  double _slipSpeed = 0.0; // hz

  // we need a method to update these values, parsing them from JSON. They may not all be present in the JSON. If any
  // got updated, we need to notify listeners. We don't want to notify listeners until the end of the update method.
  void updateFromJson(Map<String, dynamic> data) {
    _motorCurrent = data['motorCurrent'] ?? _motorCurrent;
    _motorPower = data['motorPower'] ?? _motorPower;
    _motorVelocityRpm = data['motorVelocityRpm'] ?? _motorVelocityRpm;
    _motorVelocityMs = data['motorVelocityMs'] ?? _motorVelocityMs;
    _motorAngularVelocity = data['motorAngularVelocity'] ?? _motorAngularVelocity;
    _busCurrent = data['busCurrent'] ?? _busCurrent;
    _busVoltage = data['busVoltage'] ?? _busVoltage;
    _phaseCCurrent = data['phaseCCurrent'] ?? _phaseCCurrent;
    _phaseBCurrent = data['phaseBCurrent'] ?? _phaseBCurrent;
    _voltageVectorReal = data['voltageVectorReal'] ?? _voltageVectorReal;
    _voltageVectorImaginary = data['voltageVectorImaginary'] ?? _voltageVectorImaginary;
    _currentVectorReal = data['currentVectorReal'] ?? _currentVectorReal;
    _currentVectorImaginary = data['currentVectorImaginary'] ?? _currentVectorImaginary;
    _backEmfD = data['backEmfD'] ?? _backEmfD;
    _backEmfD = data['backEmfD'] ?? _backEmfD;
    _rail15v = data['rail15v'] ?? _rail15v;
    _rail3v3 = data['rail3v3'] ?? _rail3v3;
    _rail1v9 = data['rail1v9'] ?? _rail1v9;
    _ipmTemperature = data['ipmTemperature'] ?? _ipmTemperature;
    _motorTemperature = data['motorTemperature'] ?? _motorTemperature;
    _dspBoardTemperature = data['dspBoardTemperature'] ?? _dspBoardTemperature;
    _dcBusAmpHours = data['dcBusAmpHours'] ?? _dcBusAmpHours;
    _odometer = data['odometer'] ?? _odometer;
    _slipSpeed = data['slipSpeed'] ?? _slipSpeed;
  }
}

// create classes for both motors so we can have separate providers
class LeftMotor extends _Motor {}

class RightMotor extends _Motor {}
