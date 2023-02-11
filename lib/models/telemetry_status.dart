import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

enum Status { disconnected, connecting, connected }

/// Number of latency measurements to average over
const latencyAverageCount = 300;

class TelemetryStatus extends ChangeNotifier {
  var _status = Status.disconnected;

  var _numErrors = 0;
  final _recentLatencies = <int>[];

  Status get status => _status;

  set status(newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  bool get areErrorsPresent => _numErrors != 0;

  int get numErrors => _numErrors;

  set numErrors(int newNumErrors) {
    _numErrors = newNumErrors;
    notifyListeners();
  }

  /// The average latency, in nanoseconds.
  int get averageLatency {
    if (_recentLatencies.isEmpty) {
      return 0;
    }
    return _recentLatencies.reduce((a, b) => a + b) ~/ _recentLatencies.length;
  }

  /// The average latency over the last 10 messages, in milliseconds.
  double get averageLatencyMs => averageLatency / 1000000;

  /// Add a new latency to the list of recent latencies.
  void addLatency(int newLatency) {
    _recentLatencies.add(newLatency);
    if (_recentLatencies.length > latencyAverageCount) {
      _recentLatencies.removeAt(0);
    }
    notifyListeners();
  }

  @override
  String toString() {
    // return status with first letter capitalized
    final statusString = status.name.substring(0, 1).toUpperCase() + status.name.substring(1);
    final errorString = areErrorsPresent ? '($_numErrors errors caught, please check the logs!)' : '';
    return '$statusString $errorString';
  }

  ChangeNotifierProvider<TelemetryStatus> get provider => ChangeNotifierProvider.value(value: this);
}
