import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:uksc_dashboard/models/controls.dart';

class Throttle extends StatelessWidget {
  const Throttle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Material(
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
          Consumer<Pedals>(
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
        ],
      ),
    );
  }
}
