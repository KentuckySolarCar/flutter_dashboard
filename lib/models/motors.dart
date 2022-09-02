import 'package:flutter/foundation.dart';


class Motor {
  double _motorCurrent = 0.0; // percent
  double _motorPower = 0.0; // percent

  double _motorVelocityRpm = 0.0; // rpm
  double _motorVelocityMs = 0.0; // m/s
  double _motorAngularVelocity = 0.0; // rpm

  double _busCurrent = 0.0; // amps
  double _busVoltage = 0.0; // volts

  double _phase_c_current = 0.0;
  double _phase_b_current = 0.0;

  double _voltage_vector_real = 0.0;
  double _voltage_vector_imaginary = 0.0;

  double _current_vector_real = 0.0;
  double _current_vector_imaginary = 0.0;

  double _backEmfd = 0.0;
  double _backEmfq = 0.0;

  double _rail15v = 0.0;
  double _rail3v3 = 0.0;
  double _rail1v9 = 0.0;

  double _ipmTemperature = 0.0; // celsius
  double _motorTemperature = 0.0; // celsius
  double _dspBoardTemperature = 0.0; // celsius

  double _dcBusAmpHours = 0.0; // amp hours
  double _odometer = 0.0; // meters
  double _slipSpeed = 0.0; // hz
}