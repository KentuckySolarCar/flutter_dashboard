import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/battery.dart';

class BatteryCurrent extends StatelessWidget {
  const BatteryCurrent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<Battery>(builder: (context, battery, child) {
        return Column(
          children: [
            (battery.current >= 0)
                ? Icon(
                    Icons.battery_charging_full,
                    color: Colors.green,
                    size: 50,
                  )
                : Icon(
                    Icons.battery_6_bar,
                    color: Colors.yellow.shade700,
                    size: 50,
                  ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 200,
                height: 20,
                child: Transform.scale(
                  scaleX: -1,
                  child: LinearProgressIndicator(
                    value: (battery.current < 0) ? -battery.current / 60 : 0,
                    color: Colors.yellow.shade700,
                  ),
                ),
              ),
              Container(
                width: 200,
                height: 20,
                child: LinearProgressIndicator(
                  value: (battery.current >= 0) ? battery.current / 60 : 0,
                  color: Colors.green,
                ),
              )
            ]),
            Text(
              "${battery.current.toStringAsFixed(2)} A",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textScaleFactor: 1.5,
            ),
          ],
        );
      }),
    );
  }
}
