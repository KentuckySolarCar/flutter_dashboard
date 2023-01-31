import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uksc_dashboard/models/cruise_control.dart';

/// Displays the cruise control status.
///
/// The speed also changes colors at different thresholds. This is meant as a template to help show how widgets can be implemented.
class CruiseControlStatus extends StatelessWidget {
  const CruiseControlStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<CruiseControl>(builder: (context, cruiseControl, child) {
        return Container(
            margin: const EdgeInsets.all(30.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                border: Border.all(width: 3, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Cruise  ",
                  ),
                  WidgetSpan(
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(100)
                          //more than 50% of width makes circle
                          ),
                    ),
                  ),
                  TextSpan(
                    text: "\nset speed: ${cruiseControl.setPoint}",
                  ),
                ],
              ),
            ));
      }),
    );
  }
}
