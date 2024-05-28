import 'dart:async';

import 'package:flutter/material.dart';

import 'package:uksc_dashboard/widgets/speeds_display.dart';
import 'package:uksc_dashboard/widgets/status_bar.dart';
import 'package:uksc_dashboard/widgets/turn_signal_status_bar.dart';
import 'package:uksc_dashboard/widgets/turn_signal_indicators.dart';
import 'package:uksc_dashboard/widgets/throttle.dart';
import 'package:uksc_dashboard/widgets/indicator_lights.dart';
import 'package:uksc_dashboard/widgets/battery_indicators.dart';
import 'package:uksc_dashboard/widgets/time_indicators.dart';


//TODO Maybe rather than it being a status bar we can just put the turn signal widget at the top.
//TODO decide on what were gonna do for appbar. As of now it will be a signal strength indicator.
class MainDashboard extends StatelessWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: const StatusBar(),
      //appBar: const DrivingStatusBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TurnSignalBar(),
            IndicatorLightsRow(),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const BatteryDisplay(),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.transparent, width: 2),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const SpeedDisplay(),
                ),
                const SizedBox(width: 10), // Adjust as needed for spacing
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const Throttle(),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: const TimeReadout(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
