import 'package:flutter/material.dart';

import 'package:uksc_dashboard/widgets/basic_speed.dart';
import 'package:uksc_dashboard/widgets/status_bar.dart';
import 'package:uksc_dashboard/widgets/cruise_control.dart';
import 'package:uksc_dashboard/widgets/battery_current.dart';

/// A basic dashboard displaying simple stuff such as the speed.
///
/// Primarily meant for development and testing
class BasicDashboard extends StatelessWidget {
  const BasicDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const StatusBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // BasicSpeed(),
              // BasicSpeedGauge(),
              // CruiseControlStatus(),
              BatteryCurrent()
            ],
          ),
        ));
  }
}
