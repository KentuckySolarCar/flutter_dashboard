import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/speed.dart';

/// A basic widget that simply displays the speed, nice and big.
///
/// The speed also changes colors at different thresholds. This is meant as a template to help show how widgets can be implemented.
class BasicSpeed extends StatelessWidget {
  const BasicSpeed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<Speed>(builder: (context, speed, child) {
        var color = Colors.green;
        if (speed.mph > 80) {
          color = Colors.red;
        } else if (speed.mph > 65) {
          color = Colors.orange;
        }

        return Text('${speed.mph.toStringAsFixed(1)} MPH',
            style: TextStyle(
              fontSize: 40,
              color: color,
            ));
      }),
    );
  }
}
