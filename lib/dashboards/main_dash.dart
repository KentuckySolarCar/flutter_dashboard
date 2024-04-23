import 'package:flutter/material.dart';

import 'package:uksc_dashboard/widgets/speeds_display.dart';
import 'package:uksc_dashboard/widgets/status_bar.dart';
import 'package:uksc_dashboard/widgets/throttle.dart';
import 'package:uksc_dashboard/widgets/indicator_lights.dart';

class MainDashboard extends StatelessWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StatusBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IndicatorLightsRow(), // Add indicator lights row here
            SizedBox(height: 5), // Add some spacing between indicator lights and other widgets
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: const SpeedDisplay(),
                          ),
                          const SizedBox(height: 10), // Adjust as needed for spacing
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10), // Adjust as needed for spacing
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Throttle(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
