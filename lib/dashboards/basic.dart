import 'package:flutter/material.dart';

import 'package:uksc_dashboard/widgets/basic_speed.dart';
import 'package:uksc_dashboard/widgets/connection_status.dart';

/// A basic dashboard displaying simple stuff such as the speed.
///
/// Primarily meant for development and testing
class BasicDashboard extends StatelessWidget {
  const BasicDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [ConnectionStatus(), BasicSpeed(), BasicSpeedGauge()],
      ),
    );
  }
}
