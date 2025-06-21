import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/base_model.dart';
import 'package:flutter/material.dart';

class AlertData {
  final int snitch;
  final int alertCode;
  final int module;
  final int arg1;
  final int arg2;
  final int arg3;

  AlertData({
    required this.snitch,
    required this.alertCode,
    required this.module,
    required this.arg1,
    required this.arg2,
    required this.arg3,
  });
}

class AlertModel extends ChangeNotifier {
  AlertData? _latestAlert;

  AlertData? get latestAlert => _latestAlert;

  void updateFromCanData(Uint8List data) {
    if (data.length != 8) return;

    int readInt16LE(int byte1, int byte2) =>
        (byte2 << 8) | byte1;

    final decoded = AlertData(
      snitch: data[0],
      alertCode: data[1],
      module: data[2],
      arg1: data[3].toSigned(8),
      arg2: readInt16LE(data[4], data[5]).toSigned(16),
      arg3: readInt16LE(data[6], data[7]).toSigned(16),
    );

    _latestAlert = decoded;
    notifyListeners(); // notifies all widgets to react
  }

  void clearAlert() {
    _latestAlert = null;
    notifyListeners();
  }
}

class Alerts extends BaseModel {
  Alerts() : super({
    'Vehicle.Something.Alerts.Name.Of.critical.Alerts': '0',
    'Vehicle.Something.Alerts.Name.Of.high.Alerts': '0',
  });

  
}