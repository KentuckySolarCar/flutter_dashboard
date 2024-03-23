import 'package:flutter/material.dart';

import 'package:uksc_dashboard/widgets/basic_speed.dart';
import 'package:uksc_dashboard/widgets/status_bar.dart';
import 'package:uksc_dashboard/widgets/test_left_motor.dart';

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
            children: const [BasicSpeed(), MotorTemp(), BasicSpeedGauge()],
          ),
        ));
  }
}
