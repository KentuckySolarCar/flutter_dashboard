import 'dart:async';

import 'package:flutter/material.dart';

import 'package:uksc_dashboard/widgets/speeds_display.dart';
import 'package:uksc_dashboard/widgets/status_bar.dart';
import 'package:uksc_dashboard/widgets/throttle.dart';
import 'package:uksc_dashboard/widgets/indicator_lights.dart';
import 'package:uksc_dashboard/widgets/battery_indicators.dart';
import 'package:uksc_dashboard/widgets/time_indicators.dart';

//TODO decide on what were gonna do for appbar. As of now it will be a signal strength indicator.
//TODO Align main widgets with bottom and rest with the top.
class MainDashboard extends StatelessWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StatusBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IndicatorLightsRow(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(5),
                child: const BatteryDisplay(),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                child: const SpeedDisplay(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(5),
                child: const Throttle(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(5),
                child: TimeReadout(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}