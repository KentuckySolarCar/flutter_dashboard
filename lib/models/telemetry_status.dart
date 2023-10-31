import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

enum State { disconnected, connecting, connected }

/// Number of latency measurements to average over
const latencyAverageCount = 300;

class TelemetryStatus extends ChangeNotifier {
  var _state = State.disconnected;

  var _numErrors = 0;
  final _recentLatencies = <Duration>[];

  State get state => _state;

  set state(newStatus) {
    _state = newStatus;
    notifyListeners();
  }

  bool get areErrorsPresent => _numErrors != 0;

  int get numErrors => _numErrors;

  set numErrors(int newNumErrors) {
    _numErrors = newNumErrors;
    notifyListeners();
  }

  /// The average latency
  Duration get averageLatency {
    if (_recentLatencies.isEmpty) {
      return const Duration(milliseconds: 0);
    }
    return _recentLatencies.reduce((a, b) => a + b) ~/ _recentLatencies.length;
  }

  /// Add a new latency to the list of recent latencies.
  void addLatency(Duration newLatency) {
    _recentLatencies.add(newLatency);
    if (_recentLatencies.length > latencyAverageCount) {
      _recentLatencies.removeAt(0);
    }
    notifyListeners();
  }

  @override
  String toString() {
    // return status with first letter capitalized
    final statusString = state.name.substring(0, 1).toUpperCase() + state.name.substring(1);
    final errorString = areErrorsPresent ? '($_numErrors errors caught, please check the logs!)' : '';
    return '$statusString $errorString';
  }

  ChangeNotifierProvider<TelemetryStatus> get provider => ChangeNotifierProvider.value(value: this);
}
