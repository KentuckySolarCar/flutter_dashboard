import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:uksc_dashboard/models/controls.dart';

// Class that creates the throttle display
class Throttle extends StatelessWidget {
  const Throttle({Key? key}) : super(key: key);

  // We use a syncfusion gauge to display the throttle percent
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 300,
      child: Material(
        child: Column(
          children: [
            const Text(
              "%Throttle",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 270, // Adjust the height of the throttle display as needed
              child: Consumer<Pedals>(
                builder: (context, throttle, child) {
                  return SfLinearGauge(
                    orientation: LinearGaugeOrientation.vertical,
                    interval: 50,
                    barPointers: [
                      LinearBarPointer(
                        value: throttle.throttlePercentage,
                        color: Colors.green,
                        thickness: 10,
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
